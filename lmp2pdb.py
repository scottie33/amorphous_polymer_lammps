#!/usr/bin/python

import sys,os

if len(sys.argv) < 2: 
  raise StandardError, "Syntax: lmp2pdb.py datafile [shift]"

datfile = sys.argv[1]
if len(sys.argv) == 3: shift=int(sys.argv[2])
else: shift=0

atlst = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O']

fp = open(datfile, 'r')
pdbfp = file(datfile+".pdb",'w')
psffp = file(datfile+".psf",'w')

#read title
line = fp.readline().rstrip()
print >> pdbfp, "REMARK", line
print >> psffp, "PSF"
print >> psffp, "       1 !NTITLE"
print >> psffp, "REMARK", line
print >> psffp, ""
line = fp.readline()

#read numbers
#line = fp.readline().rstrip()
while True:
	line = fp.readline()
	elements = line.split()
	if len(elements)!=0 and elements[0]!="#":
		break

if elements[1]=="atoms": 
	natom = int(elements[0])
else:
	print elements[0] 
	raise StandardError, "wrong atom number"
line = fp.readline().rstrip()
elements = line.split()
if len(elements)!=0 and elements[1]=="bonds": 
	nbond = int(elements[0])
else: 
	raise StandardError, "wrong bond number"
line = fp.readline().rstrip()
elements = line.split()
if len(elements)!=0 and elements[1]=="angles": 
	nangle = int(elements[0])
else: 
	print " no angles in this structure? move on..."

#skip
while True:
	line = fp.readline()
	elements = line.split()
	if len(elements) < 4: continue
	if elements[2] == "xlo": break

#read box
xlo = elements[0]
xhi = elements[1]
line = fp.readline()
elements = line.split()
ylo = elements[0]
yhi = elements[1]
line = fp.readline()
elements = line.split()
zlo = elements[0]
zhi = elements[1]

while True:
	line = fp.readline()
	elements = line.split()
	if len(elements) == 0: continue
	if elements[0] == "Atoms": break

line = fp.readline()
#read atoms
print >> psffp, "%8d !NATOM" % (natom)
for i in range(0, natom):
	ndx = i+1
	line = fp.readline()
	elements = line.split()
	if ndx != int(elements[0]): raise StandardError, "wrong atom index in line: " + line.rstrip()
	nres = int(elements[1])
	typn = int(elements[2])
	x = float(elements[3+shift])
	y = float(elements[4+shift])
	z = float(elements[5+shift])
	#nres = nres-int(nres/10000)*10000
	nres = int(nres)%10000
	ndx = int(ndx)%100000
	#print >> pdbfp, "ATOM  %5d  %s   %3s A%04d    %8.3f%8.3f%8.3f  1.00  0.00" % (ndx, atlst[typn], "LMP", nres, x, y, z)
	print >> pdbfp, "ATOM  %5d%3s   %3s A%04d    %8.3f%8.3f%8.3f  1.00  0.00" % (ndx, typn, "LMP", nres, x, y, z)
	#print >> psffp, "%8d A%03d%6d LMP%4s %4s                   " % (ndx, typn, nres, atlst[typn], atlst[typn])
	print >> psffp, "%8d A%03d%6d LMP%4s %4s                   " % (ndx, typn, typn, typn, typn)

while True:
        line = fp.readline()
        if line:
        	elements = line.split()
        else:
        	break
        if len(elements) == 0: continue
        if elements[0] == "Bonds": break

line = fp.readline()
#read bonds
print >> psffp, ""
print >> psffp, "%8d !NBOND                                      " % nbond
for i in range(0,nbond):
	ndx = i+1
	line = fp.readline()
        elements = line.split()
        if ndx != int(elements[0]): raise StandardError, "wrong bond index in line: " + line.rstrip()
	typn = int(elements[1])-1
	left = int(elements[2])
	right = int(elements[3])
	if i%4 == 3: print >> psffp, "%7d%8d" % (left, right)
	elif i%4 == 0: print >> psffp, "%8d%8d" % (left, right),
	else: print >> psffp, "%7d%8d" % (left, right),
