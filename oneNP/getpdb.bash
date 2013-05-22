#!/bin/bash

if [ $# -lt 9 ]; then
	echo " you should have VMD installed with path set well."
	echo " "
	echo " cmd psffile dcdfile fromid1 toid1 fromid2 toid2 distance deltadis withindis"
	echo " "
	echo " please try again."
	exit -1
fi

pdbdir="pdbfiles"

if [ -d "${pdbdir}" ]; then 
	rm -fr ${pdbdir}
fi
mkdir ${pdbdir}
#### generating tempinput.tcl here ####
echo  "set inputpsf \"$1\"" > tempinput.tcl
echo  "set inputdcd \"$2\"" >> tempinput.tcl
echo  "set sresids $3 " >> tempinput.tcl
echo  "set sreside $4 " >> tempinput.tcl
echo  "set eresids $5 " >> tempinput.tcl
echo  "set ereside $6 " >> tempinput.tcl
echo  "set distance $7 " >> tempinput.tcl
echo  "set deltadis $8 " >> tempinput.tcl
echo  "set withindis $9 " >> tempinput.tcl
echo  "set pdbdir \"${pdbdir}\"" >> tempinput.tcl
#######################################

vmd -dispdev text -e getpdb.tcl

exit 0