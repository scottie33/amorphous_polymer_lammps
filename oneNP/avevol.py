#!/usr/bin/python

import sys,os
from operator import itemgetter, attrgetter

inpfile1="npt2zero.ene.dat"
try:
	inpfp1=open(inpfile1, 'r')
	print " loading from [",inpfile1,"]."
except IOError:
	print " ERROR: can not open file: [",inpfile1,"]"
	exit(-1)
alllines=[]

while True:
	line=inpfp1.readline()
	if line:
		elements=line.split()
	else:
		print " end of file, loading over. 1"
		break
	if len(elements)!=0 and elements[0] != "#":
		templist=[]
		templist.append(float(elements[0]))
		templist.append(float(elements[1]))
		alllines.append(templist)
		#print alllines[-1]

inpfp1.close() # out
#alllines=sorted(alllines, cmp=lambda x,y : cmp(x[0], y[0]))
alllines=sorted(alllines, key=itemgetter(0))

outfp1=open(inpfile1+".new.dat", 'w')
for i in range(0,len(alllines)):
	print >> outfp1, alllines[i][0],alllines[i][1]
outfp1.close()

outfp=open("tempdata.gpl", 'w')
print >> outfp, "inp='"+inpfile1+".new.dat'"
print >> outfp, "out='TotEner-Vol'"
print >> outfp, "colx=1"
print >> outfp, "coly=2"
print >> outfp, "xlabeltext='Volume'" 
print >> outfp, "ylabeltext='Total Energy'" 
outfp.close()
os.system("gnuplot draw_data.gpl")
print " check out your [ TotEner-Vol.eps ] :)"


print " << avevol.py can be used for aniso- or iso- npt result. >>"
inpfile2="npt2zero.vol.dat"
try:
	inpfp=open(inpfile2, 'r')
	print " loading from [",inpfile2,"]."
except IOError:
	print " ERROR: can not open file: [",inpfile2,"]"
	exit(-1)

listlx=[]
listly=[]
listlz=[]

while True:
	line=inpfp.readline()
	if line:
		elements=line.split()
	else:
		print " end of file, loading over. 1"
		break
	if len(elements)!=0 and elements[0] != "#":
		listlx.append(float(elements[0]))
		listly.append(float(elements[1]))
		listlz.append(float(elements[2]))

inpfp.close()

size=len(listlx)
halfsize=len(listlx)/2

totlx=0.0
totly=0.0
totlz=0.0

for i in range(halfsize,size):
	totlx+=listlx[i]
	totly+=listly[i]
	totlz+=listlz[i]

totlx=totlx/(size-halfsize)
totly=totly/(size-halfsize)
totlz=totlz/(size-halfsize)

os.system("g++ restart2data.cpp -o restart2data.x")
os.system("chmod +x restart2data.x")
os.system("./restart2data.x restart.npt2zero.dat temp.data")
inpfile2="temp.data"
xlo=0.0
xhi=0.0
ylo=0.0
yhi=0.0
zlo=0.0
zhi=0.0
ctx=0.0
cty=0.0
ctz=0.0
try:
	inpfp2=open(inpfile2, 'r')
	print " loading from [",inpfile2,"]."
	#alllines=[]
	line=inpfp2.readline()
	while True:
		line=inpfp2.readline()
		if line:
			elements=line.split()
		else:
			print " end of file, loading over. 1"
			break
		if len(elements)>2 and elements[2]=="xlo":
			xlo=float(elements[0])
			xhi=float(elements[1])
		if len(elements)>2 and elements[2]=="ylo":
			ylo=float(elements[0])
			yhi=float(elements[1])
		if len(elements)>2 and elements[2]=="zlo":
			zlo=float(elements[0])
			zhi=float(elements[1])
	#print " there are %d NP in the system." % (totnum)
except IOError:
	print " ERROR: can not open file: [",inpfile2,"], regular calculation implemented: "
	xhi=totlx
	yhi=totly
	zhi=totlz

ctx=(xhi-xlo)/2.0+xlo
cty=(yhi-ylo)/2.0+ylo
ctz=(zhi-zlo)/2.0+zlo

outfp2=open("volume.in", 'w')
print >> outfp2, "variable fromlx index %f" % (ctx-totlx/2.0)
print >> outfp2, "variable fromly index %f" % (cty-totly/2.0)
print >> outfp2, "variable fromlz index %f" % (ctz-totlz/2.0)
print >> outfp2, "variable tolx index %f" % (ctx+totlx/2.0)
print >> outfp2, "variable toly index %f" % (cty+totly/2.0)
print >> outfp2, "variable tolz index %f" % (ctz+totlz/2.0)
print " [ volume.in ] created for be4nvtlow."
outfp2.close()


		