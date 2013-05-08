#!/usr/bin/python
import sys,os

import math

vlpi=math.acos(-1.0)

if len(sys.argv) < 2: 
  raise StandardError, "Syntax: calcrho.py datafile" 

datfile = sys.argv[1]
#if len(sys.argv) == 3: shift=int(sys.argv[2])
#else: shift=0
filename = "rhodata.dat"
print " now creating file: [ ", filename, " ]."
#atlst = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O']

fp = open(datfile, 'r')
#pdbfp = file(datfile+".pdb",'w')
rhofp = open(filename,'w')

#natom = 0;
distlist=[]
datalist=[];
while True:
	line = fp.readline().rstrip();
	if line:
		elements=line.split()
	else :
		break
	if len(elements) != 0:
		distlist.append(float(elements[0]))
		datalist.append(float(elements[1]))
natom=len(datalist);
print " there are", natom, "data loaded.";
fp.close();

#read atoms
integral1=0.0
integral2=0.0
i = 0
print >> rhofp, "%.6f\t%.6f" % (distlist[i], datalist[i])
for i in range(1, natom):
	temp=4*vlpi*distlist[i]*distlist[i]*(distlist[i]-distlist[i-1])
	integral1+=temp
	integral2+=temp*datalist[i]
   #print >> pdbfp, "ATOM  %5d  %s   %3s A%04d    %8.3f%8.3f%8.3f  1.00  0.00" % (ndx, atlst[typn], "LMP", nres, x, y, z)
	print >> rhofp, "%.6f\t%.6f" % (distlist[i], integral2/integral1)


rhofp.close();
print " rho-data file [ ", filename, " ] was created."

datalist=[];
distlist=[];


tempgplfp=open("tempdata.gpl",'w')
print >> tempgplfp, "inp='rhodata.dat'"
print >> tempgplfp, "out='Rho-Distance'"
print >> tempgplfp, "colx=1"
print >> tempgplfp, "coly=2"
print >> tempgplfp, "xlabeltext='Distance (Angstrom)'"
print >> tempgplfp, "ylabeltext='Rho'"
tempgplfp.close()

os.system("gnuplot draw_data_rho.gpl")

print " now you can check file: [ Rho-Distance.eps ]."