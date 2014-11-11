#!/bin/sh
source=''
output='sa.out'
lang=''
compiler=''
compilerc='gcc'
compilercpp='g++'
USAGE(){
echo 'Usage: ./HW3-2.sh [-h help] [-s source file] [-o output file name(default:sa.out)] [-l languages] [-c select compilers]'
}
while getopts hs:o:l:c: OPTIONS ; do
    case $OPTIONS in
	h)
	    USAGE
	    exit 0
	    ;;
	s)
	    source=$OPTARG;;
	o)
	    output=$OPTARG;;
	l)
	    lang=$OPTARG;;
	c)
	    compiler=$OPTARG;;
	*)
	    echo 'Unknown flag!'
	    USAGE
	    exit 0
	    ;;
    esac
done
echo '========================='
if [ ${#source} -eq 0 ] ; then
    echo 'Please enter source code!'
    echo '========================='
    exit 0
fi
if ! [ -e ${source} ] ; then
    echo 'Source file does not exist!'
    echo '========================='
    exit 0
fi
if [ ${#lang} -eq 0 ] ; then
    echo 'Please choose compiling language!'
    echo '========================='
    exit 0
fi
IFS=","
for com in $compiler ; do
    case $com in
	gcc)
	    compilerc='gcc'
	    echo 'C compiler changed to gcc'
	    ;;
	clang)
	    compilerc='clang'
	    echo 'C compiler changed to clang'
	    ;;
	g++)
	    compilercpp='g++'
	    echo 'c++ compiler changed to g++'
	    ;;
	clang++)
	    echo 'c++ compiler changed to clang++'
	    compilercpp='clang++'
	    ;;
	*)
	    echo "Unknown compiler ${com}, Skipping!"
	    echo 'Known compilers(gcc,clang,g++.clang++)'
	    ;;
    esac
done 
if [ ${#compiler} -ne 0 ] ; then
    echo '========================='
fi
IFS=","
for word in $lang ; do
    case $word in
	c|C)
	    if [ $compilerc = 'gcc' ] ; then
		echo 'Running in C (gcc)!'
		env gcc48 $source -o $output
		if [ -e $output ] ; then
		    ./$output
		fi
		echo '========================='
	    fi
	    if [ $compilerc = 'clang' ] ; then
		echo 'Running in C (clang)!'
		env g++48 $source -o $output
		if [ -e $output ] ; then
		    ./$output
		fi
		echo '========================='
	    fi
	    ;;
	cc|cpp|Cpp|c++|C++)
	    if [ $compilercpp = 'g++' ] ; then
		echo 'Running in C++ (g++)!'
		env g++48 $source -o $output
		if [ -e $output ] ; then
		    ./$output
		fi
		echo '========================='
	    fi
	    if [ $compilercpp = 'clang++' ] ; then
		echo 'Running in C++ (clang++)!'
		env clang++ $source -o $output
		if [ -e $output ] ; then
		    ./$output
		fi
		echo '========================='
	    fi
	    ;;
	awk|AWK)
	    echo 'Running in Awk!'
	    env awk -f $source
	    echo '========================='
	    ;;
	perl|Perl)
	    echo 'Running in Perl!'
	    env perl $source
	    echo '========================='
	    ;;
	python|Python|py|python2|Python2|py2)
	    echo 'Running in Python2!'
	    env python $source
	    echo '========================='
	    ;;
	python3|Python3|py3)
	    echo 'Running in Python3!'
	    env python3 $source
	    echo '========================='
	    ;;
	ruby|Ruby|rb)
	    echo 'Running in Ruby!'
	    env ruby $source
	    echo '========================='
	    ;;
	Haskell|haskell|hs)
	    echo 'Running in Haskell!'
	    env runhaskell $source
	    echo '========================='
	    ;;
	lua|Lua)
	    echo 'Running in Lua!'
	    env lua52 $source
	    echo '========================='
	    ;;
	bash|Bash)
	    echo 'Running in Bash'
	    env bash $source
	    echo '========================='
	    ;;
	*) 
	    echo "Unknown language ${word}, Skipping!"
	    echo '========================='
	    ;;
    esac
done

