#!/bin/bash

if [ $# -lt 8 ]; then
	echo " you should have VMD installed with path set well."
	echo " "
	echo " cmd psffile dcdfile fromid1 toid1 fromid2 toid2 sigma1 sigma2"
	echo " "
	echo " please try again."
	exit -1
fi

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
	echo "ylabeltext='Contacts_$i'" >> tempdata.gpl
	gnuplot draw_data.gpl
	echo " check out your [ ${i}-contact.eps ] :)"
done
#######################################
exit 0 
