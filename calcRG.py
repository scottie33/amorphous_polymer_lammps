#!/usr/bin/python


import math
ylist=[33.95,37.1]
xlist=[64,256]
unknownx=6400

xlen=len(xlist)
ylen=len(ylist)

if xlen != ylen:
	print " xlen ! = ylen"
	exit(-1)

for i in range(0,xlen):
	xlist[i]=math.log(xlist[i])
	ylist[i]=math.log(ylist[i])

k=0.0
for i in range(1,xlen):
	k+=(ylist[i]-ylist[i-1])/(xlist[i]-xlist[i-1])

k=k/(xlen-1)

LOGRG2=ylist[0]+k*((math.log(unknownx)-xlist[0]))
RG2=math.exp(LOGRG2)

print " N=%d" % (unknownx)
print " Rg^2=%f" % (RG2)
print " Rg=%f" % (math.sqrt(RG2))