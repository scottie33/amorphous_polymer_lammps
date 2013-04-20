#!/bin/bash

if [ $# -lt 8 ]; then
	echo " you should have VMD installed with path set well.\n"
	echo " cmd psffile dcdfile fromid1 toid1 fromid2 toid2 sigma1 sigma2\n"
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
echo "inp='contacts.dat'" > tempdata.gpl
echo "out='Contacts'" >> tempdata.gpl
echo "colx=1" >> tempdata.gpl
echo "col2=2" >> tempdata.gpl
echo "col3=3" >> tempdata.gpl
echo "col4=4" >> tempdata.gpl
echo "col5=5" >> tempdata.gpl
echo "xlabeltext='TimeStep'" >> tempdata.gpl
echo "ylabeltext='Contacts'" >> tempdata.gpl
gnuplot draw_data_contact.gpl
echo " check out your [ Contacts.eps ] :)"
#######################################
exit 0 