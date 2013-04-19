#!/bin/bash

if [ $# -lt 1 ]; then
	echo " " 
	echo " cmd filename "
    echo " example: ./create_html.bash example.outputfrompreviouscmd"
	echo " if any problem, improvement made, or any Q, please contact me: leiw@ustc.edu.cn"
	echo " "
	exit -1
fi

num=0
for i in `cat itemlist.lst`; do
	let num=$num+1
	echo " $num $i"
done

format="eps"

if [ `ls *.$format | wc -l` -ne 0 ]; then
	rm -f *.$format
	echo " delete *.$format done!"
fi

for((i=1;i<${num};i++)); do
	let tempnum=$i+1
	./showdata.bash $1 1 ${tempnum}
	#echo " ./showdata.bash $1 1 ${tempnum}"
done
#echo -e " "`cat itemlist.lst `

if [ -f "allfig.html" ]; then
	rm -fr allfig.html
	echo " delete allfig.html done!"
fi

format="png"

if [ `ls *.$format | wc -l` -ne 0 ]; then
	rm -f *.$format
	echo " delete *.$format done!"
fi

echo "<html>" > allfig.html
echo "	<body>" >> allfig.html
for i in `ls *.eps`; do
	if [ -f $i.$format ]; then 
		echo " $i.$format exists, do nothing..."
	else
		convert -rotate 90 $i $i.$format
		echo " $i was converted to $i.$format"
	fi
	echo "	<p>$i.$format</p><br>" >> allfig.html
	echo "	<img src=\"$PWD/$i.$format\"><br>" >> allfig.html
  	#echo "	</a>" >> allfig.html
  	#echo "	</p>" >> allfig.html
done
echo "	</body>" >> allfig.html
echo "</html>" >> allfig.html

echo " allfig.html created, please double-click to check it out."
sleep 1
open allfig.html

exit
