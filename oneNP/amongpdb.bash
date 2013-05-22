#!/bin/bash

if [ $# -lt 11 ]; then
	echo " you should have VMD installed with path set well."
	echo " "
	echo " cmd psffile dcdfile fromid1 toid1 fromid2 toid2 fromid3 toid3 distance deltadis withindis"
	echo " "
	echo " please try again."
	exit -1
fi

#pdbdir="apdbfiles"

#if [ -d "${pdbdir}" ]; then 
#	rm -fr ${pdbdir}
#fi
#mkdir ${pdbdir}
#### generating tempinput.tcl here ####
echo  "set inputpsf \"$1\"" > tempinput.tcl
echo  "set inputdcd \"$2\"" >> tempinput.tcl
echo  "set sresids $3 " >> tempinput.tcl
echo  "set sreside $4 " >> tempinput.tcl
echo  "set eresids $5 " >> tempinput.tcl
echo  "set ereside $6 " >> tempinput.tcl
echo  "set iresids $7 " >> tempinput.tcl
echo  "set ireside $8 " >> tempinput.tcl
echo  "set distance $9 " >> tempinput.tcl
echo  "set deltadis ${10} " >> tempinput.tcl
echo  "set withindis ${11} " >> tempinput.tcl
#echo  "set pdbdir \"${pdbdir}\"" >> tempinput.tcl
#######################################

vmd -dispdev text -e amongpdb.tcl

exit 0