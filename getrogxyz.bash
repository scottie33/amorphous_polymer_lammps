#!/bin/bash

if [ $# -lt 4 ]; then
	echo " you should have VMD installed with path set well."
	echo " "
	echo " cmd psffile dcdfile fromid1 toid1 "
	echo " "
	echo " please try again."
	exit -1
fi

#### generating tempinput.tcl here ####
echo  "set inputpsf \"$1\"" > tempinput.tcl
echo  "set inputdcd \"$2\"" >> tempinput.tcl
echo  "set sresids $3 " >> tempinput.tcl
echo  "set sreside $4 " >> tempinput.tcl
#######################################

vmd -dispdev text -e getrogxyz.tcl

gnuplot draw_rogyr_xyz.gpl

exit 0