echo''|awk 'BEGIN{Mapsize=30;Low=1;High=4;Born=3;seedratio=0.15;srand();for(s=1;s<=Mapsize+2;s++){Map[s]=0;}for(temp=0;temp<Mapsize;temp++){printf"-"}printf"\n";for(x=1;x<=Mapsize;x++){Map[(Mapsize+2)*x+1]=0;for(y=2;y<=Mapsize+1;y++){if(rand()<seedratio){Map[(Mapsize+2)*x+y]=1;printf"X";}else{Map[(Mapsize+2)*x+y]=0;printf" ";}}Map[(Mapsize+2)*(x+1)]=0;printf"|\n"}for(e=(Mapsize+1)*(Mapsize+2)+1;e<=(Mapsize+2)*(Mapsize+2);e++){Map[e]=0;}for(temp=0;temp<Mapsize;temp++){printf"-"}printf"\n";system("sleep 0.1");}{while(1){system("clear");for(temp=0;temp<Mapsize;temp++){printf"-"}printf"\n";for(x=1;x<=Mapsize;x++){for(y=2;y<=Mapsize+1;y++){test=Map[(Mapsize+2)*(x-1)+y-1]+Map[(Mapsize+2)*(x-1)+y]+Map[(Mapsize+2)*(x-1)+y+1]+Map[(Mapsize+2)*x+y-1]+Map[(Mapsize+2)*x+y+1]+Map[(Mapsize+2)*(x+1)+y-1]+Map[(Mapsize+2)*(x+1)+y]+Map[(Mapsize+2)*(x+1)+y+1];if(Map[(Mapsize+2)*x+y]==1){if(test>Low&&test<High){Map2[(Mapsize+2)*x+y]=1;printf"X";}else{Map2[(Mapsize+2)*x+y]=0;printf" ";}}else{if(test==Born){Map2[(Mapsize+2)*x+y]=1;printf"X"}else{Map2[(Mapsize+2)*x+y]=0;printf" "}}}printf"|\n"}for(x=1;x<=Mapsize;x++){for(y=2;y<=Mapsize+1;y++){Map[(Mapsize+2)*x+y]=Map2[(Mapsize+2)*x+y];}}for(temp=0;temp<Mapsize;temp++){printf"-"}printf"\n";system("sleep 0.1");}}'
