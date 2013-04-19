#!/bin/bash

if [ $# -lt 6 ]; then
	echo " cmd psffile dcdfile fromid1 toid1 fromid2 toid2"
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
#######################################

vmd -dispdev text -e "rdf.tcl"

#### gnuplot code to be added here ####
echo "inp='grdf.dat'" > tempdata.gpl
echo "out='grdf'" >> tempdata.gpl
echo "colx=1" >> tempdata.gpl
echo "coly=2" >> tempdata.gpl
echo "xlabeltext='Distance'" >> tempdata.gpl
echo "ylabeltext='Distribution'" >> tempdata.gpl
gnuplot draw_data_rdf.gpl
echo " check out your [ grdf.eps ] :)"
#######################################
exit 0 