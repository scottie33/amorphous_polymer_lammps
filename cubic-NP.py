#!/usr/bin/python

import random
import math
from array import array

wellcoeff=math.pow(2.0,1.0/6.0)

box_size=100
nc=16
cl=64
pp_sigma=4.7
nn_sigma=4.7 # nanoparticle-nanoparticle sigma
np_sigma=(nn_sigma+pp_sigma)/2.0
NP_num=2
offset=0.0 # isotropically offsetting the com of NP-lattice (all nps).
perNP=0.0  # if NP_num == 0 this will be used to generate the specified mass loading...
perVol=0.05 # show message, no use at all.

Radius=37.6/2.00
pmass=56.0
pradi=4.7 #polymer radii
start_index=nc*cl+1
start_mol=nc+1
NP_type=nc+1

MASS=pow(Radius/pradi,3.0)*pmass
print " NP mass : %.2f" % (MASS)
print " NP hard-core-radius: %.2f (%.2f-%.2f)" % (Radius-np_sigma*wellcoeff , Radius, wellcoeff*np_sigma)	

print " [ there should be %d monomers in the system if you want vol%% 2be: %.2f ]" % (int(NP_num*MASS/pmass*(1/perVol-1)), perVol)
if NP_num==0:
	#if perNP-1e-12 <=0.0:
	#	print " NP load : %f " % (perNP)
	#	print " NP numb : %f, truncated to %d " % (NP_num, int(NP_num)) 
	#	print " No NP at all, exit. "
	#	exit(-1)
	NP_num=nc*cl*pmass*perNP/(1.0-perNP)/MASS
	print " NP load : %f " % (perNP)
	print " NP numb : %f, truncated to %d " % (NP_num, int(NP_num)) 
	NP_num=int(NP_num)
else:
	perNP=NP_num*MASS/(NP_num*MASS+pmass*nc*cl)
	print " NP numb : %f, the mass load %% is %f : " % (NP_num, perNP) 

NP_single=pow(NP_num, 1.0/3.0)
if (NP_single-int(NP_single))>1e-12:
	NP_single=int(NP_single)+1
else:
	NP_single=int(NP_single)
print " there are %d monomers each dimension " % (NP_single)

if NP_single == 0:
	dimension = 0.0
else:
	dimension=box_size/float(NP_single)


nn_dis=nn_sigma*wellcoeff
nn_dis=nn_dis+2*(Radius-np_sigma) #?diameter?
if dimension < nn_dis :
	dimension = nn_dis
	box_size=NP_single*nn_dis
print " the distance of n-n is %f (>= %f x 2+%f)" % (dimension, Radius-np_sigma, nn_sigma*wellcoeff)
print " the box_size is : %f (better bigger than %f x %d)" % (box_size, 2.0*(Radius-np_sigma)+nn_sigma*wellcoeff, NP_single)


NP_coord=[]

for k in range(0, NP_single): # k j i for along x y z the order.
	for j in range(0, NP_single):
		for i in range(0, NP_single):
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
