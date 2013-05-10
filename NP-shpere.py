#!/usr/bin/python

import random
import math
from array import array

nc=128
cl=64
MASS=100.0
offset=100.0 ;# the dimension of polymer matrix. isotropic.
start_index=nc*cl+1
start_mol=nc+1
NP_type=nc+1
RadiusS=50.0
RadiusP=4.7
RadiusP=RadiusP/2.0
VLPI=math.acos(-1.0)
dTheta=2.0*math.asin(RadiusP/2.0/RadiusS)/VLPI*180.0
print " delta theta is: %f degree" %  (dTheta)
dTheta=dTheta*VLPI/180.0
print " delta theta is: %f" %  (dTheta)
Nlayer=VLPI/dTheta
print " there should be [%f] layers of particles" % (Nlayer)
if (Nlayer-int(Nlayer))>0.0:
	Nlayer=int(Nlayer)+1
else:
	Nlayer=int(Nlayer)
print " there are %d layers of particles. (rounded value)" % (Nlayer)
dTheta=VLPI/Nlayer
print " delta theta is updated to: %f (%f degree)" %  (dTheta, dTheta/VLPI*180.0)
#if Nlayer%2==0:
#else:
tangle=dTheta/2.0

NP_coord=[]
for i in range(0,Nlayer):
	tempR=RadiusS*math.sin(tangle)
	tempN=2*VLPI*tempR/RadiusP
	if tempN-int(tempN)>0.0:
		tempN=int(tempN)+1
	else:
		tempN=int(tempN)
	dPhi=2.0*VLPI/float(tempN)
	TempPhi=0.0
	for j in range(0,tempN):
		tempcoor=[math.cos(TempPhi)*tempR+offset, math.sin(TempPhi)*tempR+offset, RadiusS*math.cos(tangle)+offset]
		NP_coord.append(tempcoor)
		TempPhi+=dPhi
	tangle+=dTheta


NP_num=len(NP_coord)
outfile = file('NP.dat', 'w')
print >> outfile, "%10.4f" % (MASS)
for i in range(0,NP_num):
	print >> outfile, "%10d%10d%10d%10.4f%10.4f%10.4f" % (start_index,start_mol,NP_type,NP_coord[i][0],NP_coord[i][1],NP_coord[i][2])
	start_index=start_index+1
	#start_mol=start_mol+1
outfile.close()
