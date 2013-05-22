#!/usr/bin/python
import sys,os


if len(sys.argv) < 2: 
  raise StandardError, "Syntax: lmp2pdb.py datafile" # [shift]"

datfile = sys.argv[1]
#if len(sys.argv) == 3: shift=int(sys.argv[2])
#else: shift=0
filename = datfile[0:len(datfile)-4]
psfname = filename+".psf"
print " now creating file: [ ", psfname, " ]."
#atlst = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O']

fp = open(datfile, 'r')
#pdbfp = file(datfile+".pdb",'w')
psffp = file(psfname,'w')

#read title
#line = fp.readline().rstrip()
#print >> pdbfp, "REMARK", line
print >> psffp, "PSF"
print >> psffp, "       1 !NTITLE"
print >> psffp, "REMARK", filename
print >> psffp, ""

#natom = 0;
coorlist=[];
bondlist=[];
while True:
	line = fp.readline().rstrip();
	if line[0:6].rstrip() == "ATOM" or line[0:6] == "HETATM": 
		#natom=natom+1;
		coorlist.append(line);
	if line[0:6] == "CONECT": 
		bondlist.append(line);
	if len(line) == 0:
		break;
	print " "+line;
natom=len(coorlist);
nbond=len(bondlist);
print " there are", natom, "atoms and", nbond,"bonds in this molecule.";
fp.close();

#read atoms
print >> psffp, "%8d !NATOM" % (natom)
for i in range(0, natom):
	ndx = int( coorlist[i][6:11] );
	typn = coorlist[i][13:14];
	resn = coorlist[i][17:20].strip();
	chnn = coorlist[i][21:22];
	nres = int( coorlist[i][22:26] );
   #print >> pdbfp, "ATOM  %5d  %s   %3s A%04d    %8.3f%8.3f%8.3f  1.00  0.00" % (ndx, atlst[typn], "LMP", nres, x, y, z)
	print >> psffp, "%8d %s%03d%6d %3s%4s %4s                   " % (ndx, chnn, int(ord(typn))-int(ord('A')), nres, resn, typn, typn)

#read bonds
print >> psffp, ""
print >> psffp, "%8d !NBOND                                      " % nbond
for i in range(0,nbond):
	left = int(bondlist[i][6:11])
	right = int(bondlist[i][11:16])
	if i%4 == 3: print >> psffp, "%7d%8d" % (left, right)
	elif i%4 == 0: print >> psffp, "%8d%8d" % (left, right),
	else: print >> psffp, "%7d%8d" % (left, right),

psffp.close();
print " psf file [ ", psfname, " ] was created."

coorlist=[];
bondlist=[];