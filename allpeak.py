#!/usr/bin/python

import math

r0=4.7
r=r0*pow(2.0, 1.0/6.0)
print "P? r1=%.2f, r2=%.2f, dis=%f" % (r0, r0, r)

for r1 in [4.6, 6.1, 9.2]:
	for r2 in [4.7]:
		dis1=(r1+r2)/2.0*pow(2.0, 1.0/6.0)
		dis2=2.0*pow(dis1*dis1-r0*r0*0.25, 0.5)
		print "N? r1=%.2f, r2=%.2f, dis1=%f, dis2=%f" % (r1, r2, dis1, dis2)
 
