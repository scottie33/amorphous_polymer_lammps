#!/bin/bash

echo " cmd + chnlen"
#cp rogyrxyz.dat rogyrxyz.dat.bak
if [ $1 -gt 99 ]; then
	cat rogyrxyz.dat | awk '{print $2,$3,$4}' > rg2001001$1.dat
elif [ $1 -gt 9 ]; then
	cat rogyrxyz.dat | awk '{print $2,$3,$4}' > rg20010010$1.dat
else
	cat rogyrxyz.dat | awk '{print $2,$3,$4}' > rg200100100$1.dat
fi
