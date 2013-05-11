#!/usr/bin/python

import random
import math
from array import array

box_size=100
nc=16
cl=64

nn_sigma=4.7
NP_num=1
offset=0.0 # isotropically offsetting the com of NP-lattice (all nps).
perNP=0.8  # if NP_num == 0 this will be used to generate the specified mass loading...

Radius=37.6/2.00
pmass=56.0
pradi=4.7 #polymer radii
start_index=nc*cl+1
start_mol=nc+1
NP_type=nc+1

MASS=pow(Radius/pradi,3.0)*pmass
print " NP mass : %d" % (MASS)
if NP_num==0:
	NP_num=nc*cl*pmass*perNP/(1.0-perNP)/MASS
	print " NP load : %f " % (perNP)
	print " NP numb : %f, truncated to %d " % (NP_num, int(NP_num)) 
	NP_num=int(NP_num)
else:
	perNP=NP_num*MASS/(NP_num*MASS+pmass*nc*cl)
	print " NP numb : %f, the mass load %% is %f : " % (NP_num, perNP) 

NP_single=int(pow(NP_num, 1/3.0))
dimension=box_size/NP_single

nn_dis=4.7*math.pow(2, 1/6.0)
nn_dis=nn_dis+2*Radius #?diameter?
print " the distance between n-n is %f" % (nn_dis)
if dimension < nn_dis :
	dimension = nn_dis
	box_size=NP_single*nn_dis
	print " and the box_size is : %f" % (box_size)


NP_coord=[]

for i in range(0, NP_single):
	for j in range(0, NP_single):
		for k in range(0, NP_single):
			randoma=(0.5+i)*dimension
			randomb=(0.5+j)*dimension
			randomc=(0.5+k)*dimension
			list_random=[randoma,randomb,randomc]
			NP_coord.append(list_random)
outfile = file('NP.dat', 'w')
print >> outfile, "%10.4f%10.4f xlo xhi" % (0.0,box_size)
print >> outfile, "%10.4f%10.4f ylo yhi" % (0.0,box_size)
print >> outfile, "%10.4f%10.4f zlo zhi" % (0.0,box_size)
print >> outfile, "%10.4f" % (MASS)
for i in range(0,NP_num):
	print >> outfile, "%10d%10d%10d%10.4f%10.4f%10.4f" % (start_index,start_mol,NP_type,NP_coord[i][0]-offset,NP_coord[i][1]-offset,NP_coord[i][2]-offset)
	start_index=start_index+1
	#start_mol=start_mol+1
outfile.close()
