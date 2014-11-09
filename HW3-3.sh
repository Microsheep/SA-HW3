#!/bin/bash
now='Welcome'
feedpy='./feed.py'
mainsite='./.feed'
sublist='./.feed/sublist'
sublist_name='./.feed/sublist_name'
tmp='./.feed/tmp'
if ! [ -e '.feed/' ] ; then
    mkdir ./.feed
    touch $sublist
    touch $sublist_name
fi

welcome(){
    dialog --ascii-lines --ok-label 'GO!' --title 'Welcome to RSS MICRO!' \
	--msgbox "This is a RSS reader ~\n\n \
         ///////////    /////////    /////////\n \
        /         /    /            /\n \
       /         /    /            /\n \
      /         /    /            /\n \
     ///////////    //////////   //////////\n \
    /      /                /            /\n \
   /        /              /            /\n \
  /          /            /            /\n \
 /            /  /////////    /////////\n\n \
     ///    ///    //  //////   ///////  //////\n \
    /  /  /  /        /        /     /  /    /\n \
   /    /   /    //  /        ///////  /    /\n \
  /        /    //  /        /   /    /    /\n \
 /        /    //  //////   /     /  //////\n \
    " 0 0
    now='Main_menu'
}
main_menu(){
    now="$(dialog --output-fd 1 --ascii-lines --title 'Main Menu' \
	--menu 'Please choose an action :' 0 0 5 \
        'Read' 'Read - Read subscribed feeds' \
	'Sub' 'Subscribe - New subscription' \
	'Del' 'Delete - Delete subscription' \
	'Update' 'Update - Update subscription' \
	'Leave' 'Saying goodbye ~')"
}
leave(){
    dialog --ascii-lines --title 'Comfirmation' \
	--yesno 'Want to leave RSS Micro?' 0 0
    if [ $? -eq 0 ] ; then
	exit 0;
    else
	now='Main_menu'
    fi
}
subscribe(){
    sub="$(dialog --output-fd 1 --ascii-lines --title 'Subscribe' \
	--inputbox 'Please enter URL here!' 0 50)"
    if [ $? -eq 1 ] ; then
	now='Main_menu'
	return
    fi
    if [ ${#sub} -eq 0 ] ; then
	dialog --ascii-lines --title 'Subscribe' \
	    --msgbox 'NO URL!' 0 0
	now='Sub'
    else
	dialog --ascii-lines --title 'Subscribe' \
	    --msgbox "URL GET!\n$sub" 6 70
	eval python3 $feedpy -u $sub -t>>$tmp
	if [ $? -ne 0 ] ; then
	    dialog --ascii-lines --title 'Subscribe' \
		--msgbox "Something wrong!\nIs the URL correct?\n(Otherwise check your internet connection!)" 0 0
	    now='Main_menu'
	    rm $tmp
	    return
	fi
	if [ $(eval grep -c \'$sub\' $sublist) -ne 0 ] ; then
	    dialog --ascii-lines --title 'Subscribe' \
		--msgbox "You have subscribe this before!\nSkipping~" 0 0
	    now='Main_menu'
	    rm $tmp
	    return
	fi
	echo $sub>>$sublist
	cat $tmp>>$sublist_name
	mk=$(cat $tmp)
	eval touch \"$mainsite/$mk\"
	rm $tmp
	now='Main_menu'
    fi
}
delete(){
    num=$(wc -l $sublist|awk '{print $1}')
    if [ $num -eq 0 ] ; then
	dialog --ascii-lines --title 'Delete' \
	    --msgbox "\nNo item to delete!" 6 30
	now='Main_menu'
	return
    fi
    listofdelete=''
    x=0
    while read line ; do
	x=$((x+1))
	listofdelete=$listofdelete' '$x' '\""$line"\"' '
    done < $sublist_name
    del=$(eval dialog --output-fd 1 --ascii-lines --title \'Delete\' \
	--menu \'Choose what you want to delete!\' 0 0 0 \
	$listofdelete )
    if [ $? -eq 1 ] ; then
	now='Main_menu'
	return
    fi
    cat $sublist_name|eval sed -n \'$del p\'>$tmp
    mes=$(cat $tmp)
    eval rm \"$mainsite/$mes\"
    rm $tmp
    dialog --ascii-lines --title 'Subscribe' \
        --msgbox "Items deleted\n$mes" 0 0
    cat $sublist|eval sed \'$del d\' > $tmp
    mv $tmp $sublist
    cat $sublist_name|eval sed \'$del d\' > $tmp
    mv $tmp $sublist_name
    now='Main_menu'
}
update(){
    num=$(wc -l $sublist|awk '{print $1}')
    if [ $num -eq 0 ] ; then
	dialog --ascii-lines --title 'Update' \
	    --msgbox "\nNo item to update!" 6 30
	now='Main_menu'
	return
    fi
    listofupdate=''
    z=0
    while read line ; do
	z=$((z+1))
	listofupdate=$listofupdate' '$z' '\""$line"\"' off '
    done < $sublist_name
    update=$(eval dialog --output-fd 1 --ascii-lines --title \'Update\' \
	--checklist \'Choose subscription to update!\' 0 0 0 \
	$listofupdate )
    if [ $? -eq 1 ] ; then
	now='Main_menu'
	return
    fi
    if [ ${#update} -eq 0 ] ; then
	dialog --ascii-lines --title 'Subscribe' \
	    --msgbox "Nothing selected!" 0 0
	now='Main_menu'
	return
    else
	percent=0
	totalup=0
	for i in $update ; do
	    totalup=$((totalup+1))
	done
	for nowupno in $update ; do
	    cat $sublist_name|eval sed -n \'$nowupno p\'>$tmp
	    nowup=$(cat $tmp)
	    cat $sublist|eval sed -n \'$nowupno p\'>$tmp
	    nowupurl=$(cat $tmp)
	    eval python3 $feedpy -u $nowupurl -i>$tmp
	    if [ $? -ne 0 ] ; then
		dialog --ascii-lines --title 'Subscribe' \
		    --msgbox "Something wrong!\nCheck your internet connection!" 0 0
		now='Main_menu'
		rm $tmp
		return
	    fi
	    cat $tmp>"$mainsite/$nowup"
	    echo $((100/$totalup*$percent))
	    echo "XXX"
	    echo "Updating $nowup ..."
	    echo "XXX"
	    percent=$((percent+1))
	    rm $tmp
	done | dialog --sleep 3 --ascii-lines --title 'Update'  --gauge 'Updating!' 6 70 
	now='Main_menu'
    fi
}
read_main(){
    num=$(wc -l $sublist|awk '{print $1}')
    if [ $num -eq 0 ] ; then
	dialog --ascii-lines --title 'Read' \
	    --msgbox "\nNo item to read!" 6 30
	now='Main_menu'
	return
    fi
    listofread=''
    y=0
    while read line ; do
	y=$((y+1))
	listofread=$listofread' '$y' '\""$line"\"' '
    done < $sublist_name
    red=$(eval dialog --output-fd 1 --ascii-lines --title \'Read\' \
	--menu \'Choose subscription!\' 0 0 0 \
	$listofread )
    if [ $? -eq 1 ] ; then
	now='Main_menu'
	return
    fi
    cat $sublist_name|eval sed -n \'$red p\'>$tmp
    redtitle=$(cat $tmp)
    rm $tmp
    redplace=$mainsite/$redtitle
    redex=$(wc -l "$redplace"|awk '{print $1}')
    if [ $redex -eq 0 ] ; then
	dialog --ascii-lines --title 'Update' \
	    --msgbox "\nNo item of this feed\nPlease update first!" 8 30
	now='Main_menu'
	return
    fi
    now='Readlist'
}
readlist(){
    listofreadin=''
    q=0
    check=0
    while read line ; do
	if [ $check -eq 0 ] ; then
	    q=$((q+1))
	    listofreadin=$listofreadin' '$q' '\""$line"\"' '
	    check=1
	elif [ $check -eq 1 ] ; then
	    check=2
	else
	    check=0
	fi
    done < $redplace
    redin=$(eval dialog --output-fd 1 --ascii-lines --title \'Read\' \
	--menu \'Choose item\' 0 70 20 \
	$listofreadin )
    if [ $? -eq 1 ] ; then
	now='Read'
	return
    fi
    now='Readin'
}
readin(){
    cat "$redplace"|eval sed -n \'$((3*redin)) p\'>$tmp
    textlength=$(wc -m $tmp|awk '{print $1}')
    rm $tmp
    cat "$redplace"|eval sed -n \'$((3*redin-2)) p\'>$tmp
    echo =============================================>>$tmp
    cat "$redplace"|eval sed -n \'$((3*redin-1)) p\'>>$tmp
    echo =============================================>>$tmp
    text=1
    while [ true ] ; do
	cat "$redplace"|eval sed -n \'$((3*redin)) p\'|cut -c $text-$((text+65))>>$tmp
	text=$((text+66))
	if [ $textlength -lt $text ] ; then
	    break
	fi
    done
    echo =============================================>>$tmp
    dialog --ascii-lines --textbox $tmp 20 70
    rm $tmp
    now='Readlist'
}
while [ true ] ; do
    case $now in
	'Welcome')
	    welcome
	    ;;
	'Main_menu')
	    main_menu
	    ;;
	'Leave')
	    leave
	    ;;
	'Read')
	    read_main
	    ;;
	'Sub')
	    subscribe
	    ;;
	'Del')
	    delete
	    ;;
	'Update')
	    update
	    ;;
	'Readlist')
	    readlist
	    ;;
	'Readin')
	    readin
	    ;;
	*)    
	    now='Leave'
	    ;;
    esac
done
