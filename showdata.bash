#!/bin/bash

if [ $# -lt 3 ]; then
	echo " " 
	echo " cmd filename col1index col2index [xmin] [xmax] [ymin] [ymax]"
	echo " NOTE: 'xmin' = 'xmax' means ignoring axis adjusting and goto the next args."
	echo " or you may just hit the cmd and see the itemlist"
	echo " if any problem, improvement made, or any Q, please contact me: leiw@ustc.edu.cn"
	echo " "
	num=0
	for i in `cat itemlist.lst`; do
		let num=$num+1
		echo " $num $i"
	done
	#echo -e " "`cat itemlist.lst `
	exit -1
fi

filename=$1
col1index=$2
col2index=$3

if [ ${col1index} -lt 1 ]; then
	echo " col1: no such small index, exit."
	exit -1 
fi

if [ ${col2index} -lt 1 ]; then
	echo " col2: no such small index, exit."
	exit -1 
fi

num=0
for i in `cat itemlist.lst`; do
	#echo $i
	let num=$num+1
	if [ ${num} -eq ${col1index} ]; then
		col1name=$i
	fi
	if [ ${num} -eq ${col2index} ]; then
		col2name=$i
	fi
done

if [ ${col1index} -gt ${num} ]; then
	echo " col1: no such large index, exit."
	exit -1 
fi

if [ ${col2index} -gt ${num} ]; then
	echo " col2: no such large index, exit."
	exit -1 
fi

if [ -f "tempdata.gpl" ]; then
	#echo " temdata.gpl exist, now i delete it n gonna write a new one."
	rm tempdata.gpl
fi

echo "inp='${filename}'" > tempdata.gpl
echo "out='${col2name}-${col1name}'" >> tempdata.gpl
echo "colx=${col1index}" >> tempdata.gpl
echo "coly=${col2index}" >> tempdata.gpl
echo "xlabeltext='${col1name}'" >> tempdata.gpl
echo "ylabeltext='${col2name}'" >> tempdata.gpl
if [ $# -gt 4 ]; then 
	echo "xmin='$4'" >> tempdata.gpl
fi
if [ $# -gt 5 ]; then 
	echo "xmax='$5'" >> tempdata.gpl
	if [ $4 -ne $5 ]; then
		echo "set xrange [xmin:xmax]" >> tempdata.gpl
	fi
fi
if [ $# -gt 6 ]; then 
	echo "ymin='$6'" >> tempdata.gpl
fi
if [ $# -gt 7 ]; then 
	echo "ymax='$7'" >> tempdata.gpl
	if [ $6 -ne $7 ]; then
		echo "set yrange [ymin:ymax]" >> tempdata.gpl
	fi

fi

#echo " tempdata.gpl written successfully!"

gnuplot draw_data.gpl

echo " check out your [ ${col2name}-${col1name}.eps ] :)"
