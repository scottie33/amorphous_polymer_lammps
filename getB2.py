#!/usr/bin/python

import math
import os,sys

def log_cc(log_aa, log_bb): 
	if log_aa>log_bb: 
		return log_aa+math.log(1+math.exp(log_bb-log_aa))
	else:
		return log_bb+math.log(1+math.exp(log_aa-log_bb))

if len(sys.argv)<7:
	print " syntax epsilon simga rev rcut temp dist"
	exit(-1)

Epsilon=float(sys.argv[1])
Sigma=float(sys.argv[2])
Rev=float(sys.argv[3])
Rcut=float(sys.argv[4])
Temperature=float(sys.argv[5])
distance=float(sys.argv[6])
Boltzmann=1.38e-23*0.23901*0.001*6.02e23 # kcal/k/mol

ValuePI=math.acos(-1.0)

u_cut=4.0*Epsilon*(math.pow(Sigma/Rcut,12.0)-math.pow(Sigma/Rcut,6.0))

B2=0.0
rmax=0.0
if distance>Rcut:
	rmax=Rcut-Rev
else:
	rmax=distance-Rev

deltadis=rmax/10000.0
r=Rev+deltadis
for i in range(0,10000):
	r=r+deltadis
	#print "r=%f deltadis=%f" % (r, deltadis)
	if r<Rcut+Rev:
		u=4.0*Epsilon*(math.pow(Sigma/(r-Rev),12.0)-math.pow(Sigma/(r-Rev),6.0))-u_cut
	else:
		u=0.0
	#print " u %f" % (u)
	#print " 1/B/T = %f" % (1.0/Boltzmann/Temperature)
	B2+=(math.exp(-u/Boltzmann/Temperature)-1.0)*4*ValuePI*r*r*deltadis
	#print " B2 is %f" % (B2)

B2=B2*-0.5

print " B2 is %f" % (B2)

exit(0)





