#!/bin/bash

if [ $# -lt 1 ]; then # 0 para
	echo " you should have VMD installed with path set well."
	echo " "
	echo " $ cmd psffile dcdfile fromid1 toid1 fromid2 toid2 sigma1 sigma2"
	echo " - or - "
	echo " $ cmd num_of_atoms "
	echo " (number of atoms of current system needed, to created normalized figure of all kinds of contacts)"
	echo " please try again."
	exit -1
fi

if [ $# -lt 2 ]; then # 1 para
	#### gnuplot code to be added here ####
	if [ ! -f "contacts.dat" -o ! -s "contacts.dat" ];then
		echo " [ contacts.dat ] does not exist, please use "
		echo " $ cmd psffile dcdfile fromid1 toid1 fromid2 toid2 sigma1 sigma2"
		echo " to generate it first."
		echo " please try again later."  
		exit -1
	fi
	echo " normalized data will be plotted ... "
	echo "inp='contacts.dat'" > tempdata.gpl
	echo "out='Normalized-Contacts'" >> tempdata.gpl
	echo "colx=1" >> tempdata.gpl
	echo "col2=2" >> tempdata.gpl
	echo "col3=3" >> tempdata.gpl
	echo "col4=4" >> tempdata.gpl
	echo "col5=5" >> tempdata.gpl
	echo "totnum=$1" >> tempdata.gpl
	echo "xlabeltext='TimeStep'" >> tempdata.gpl
	echo "ylabeltext='Contacts'" >> tempdata.gpl
	gnuplot draw_data_contact.gpl
	echo " check out your [ Normalized-Contacts.eps ] :)"
	#######################################
	exit 0
fi 

if [ $# -lt 8 ]; then # 2 - 7 paras
	echo " you should have VMD installed with path set well."
	echo " "
	echo " $ cmd psffile dcdfile fromid1 toid1 fromid2 toid2 sigma1 sigma2"
	echo " - or - "
	echo " $ cmd num_of_atoms "
	echo " (number of atoms of current system needed, to created normalized figure of all kinds of contacts)"
	echo " "
	echo " please try again."
	exit -1
fi

if [ -f "contacts.dat" ];then
	cp contacts.dat protected_contacts.dat
	echo " backup [ contacts.dat ] to [ protected_contacts.dat ] "
fi 

echo " will do statistics of contacts number, loading dcd now..."

#### generating tempinput.tcl here ####
echo  "set inputpsf \"$1\"" > tempinput.tcl
echo  "set inputdcd \"$2\"" >> tempinput.tcl
echo  "set sresids $3 " >> tempinput.tcl
echo  "set sreside $4 " >> tempinput.tcl
echo  "set eresids $5 " >> tempinput.tcl
echo  "set ereside $6 " >> tempinput.tcl
echo  "set r1 $7 " >> tempinput.tcl
echo  "set r2 $8 " >> tempinput.tcl
#######################################

vmd -dispdev text -e contact.tcl

#### gnuplot code to be added here ####
num=1
for i in `echo PP PN NP NN`; do 
	let num=${num}+1
	echo " using ${num}-th column data as input."
	echo "inp='contacts.dat'" > tempdata.gpl
	echo "out='${i}-contact'" >> tempdata.gpl
	echo "colx=1" >> tempdata.gpl
	echo "coly=${num}" >> tempdata.gpl
	echo "xlabeltext='TimeStep'" >> tempdata.gpl
	echo "ylabeltext='Contacts-$i'" >> tempdata.gpl
	gnuplot draw_data.gpl
	echo " check out your [ ${i}-contact.eps ] :)"
done
#######################################
exit 0 
