#!/usr/bin/python

import random
import math
from array import array

box_size=50.0
nc=64
cl=64
perNP=0.10
Radius=9.2
pmass=56.0
pradi=4.7
MASS=pow(Radius/pradi,3.0)*pmass
print " NP load : %f " % (perNP)
print " NP mass : %d" % (MASS)
NP_num=nc*cl*pmass*perNP/(1.0-perNP)/MASS
print " NP numb : %f, truncated to %d " % (NP_num, int(NP_num)) 
NP_num=int(NP_num)
start_index=nc*cl+1
start_mol=nc+1
NP_type=nc+1
randoma=random.uniform(0, box_size)
randomb=random.uniform(0, box_size)
randomc=random.uniform(0, box_size)
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
