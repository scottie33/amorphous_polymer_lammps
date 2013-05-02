#!/usr/bin/python

import random
import math
from array import array

box_size=10.0
nc=128
cl=64
NP_num=793*2
MASS=52.5
start_index=nc*cl+1
start_mol=nc+1
NP_type=nc+1
randoma=random.uniform(0, 10)
randomb=random.uniform(0, 10)
randomc=random.uniform(0, 10)
NP_coord=[(randoma,randomb,randomc)]
for i in range(1, NP_num):
	randoma=random.uniform(0, box_size)
	randomb=random.uniform(0, box_size)
	randomc=random.uniform(0, box_size)
	list_random=[randoma,randomb,randomc]
	NP_coord.append(list_random)
outfile = file('NP.dat', 'w')
print >> outfile, "%10.4f" % (MASS)
for i in range(0,NP_num):
	print >> outfile, "%10d%10d%10d%10.4f%10.4f%10.4f" % (start_index,start_mol,NP_type,NP_coord[i][0],NP_coord[i][1],NP_coord[i][2])
	start_index=start_index+1
	#start_mol=start_mol+1
outfile.close()
