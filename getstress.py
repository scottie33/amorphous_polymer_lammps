#!/usr/bin/python
import sys,os
import math
#from scipy import interpolate

#print len(sys.argv)
if len(sys.argv) < 3: 
	#raise StandardError, "Syntax: readlog.py [keyword: to start reading] [outputfilename]"
	print "\n Use this to outputfile of readlog.py"
	#print " after using this, do not forget using [\"showdata.bash\"] to see your data.\n"
	print " [syntax]: getstress.py colname inputfilename [colnamelistfn]"
	print " colnamelistfn is optional, defaultly it's [ itemlist.lst ]"
	print " if any problem, improvement made, or any Q, please contact me: [ leiw@ustc.edu.cn ]\n"
	exit(-1)

strLx="Lx"
strLy="Ly"
strLz="Lz"
strEn="" # actually pxx

#strEn="TotEng"
idcolLx=-1
idcolLy=-1
idcolLz=-1
idcolEn=-1

colname = sys.argv[1]
if colname == "Lx" :
	strEn="Pxx"
elif colname == "Ly" :
	strEn="Pyy"
else:
	strEn="Pzz"

inpfile = sys.argv[2]
if len(sys.argv)>3:
	collist = sys.argv[3]
else:
	collist = "itemlist.lst"

try:
	inpcl=open(collist, 'r')
	print " loading information of column from: [",collist,"]"
except IOError:
	print " can not open file: [",collist,"]"
	exit(-1)
line = inpcl.readline()
elements = line.split()
idcolLx=elements.index(strLx)
idcolLy=elements.index(strLy)
idcolLz=elements.index(strLz)
idcolEn=elements.index(strEn)
inpcl.close()
if idcolLx<0 or idcolLy<0 or idcolLz<0 or idcolEn <0:
	print " idcolLx=%d, idcolLy=%d, idcolLz=%d, idcolEn=%d" % (idcolLx, idcolLy, idcolLz, idcolEn)
 	exit(-1)
else:
	print " idcolLx=%d, idcolLy=%d, idcolLz=%d, idcolEn=%d" % (idcolLx, idcolLy, idcolLz, idcolEn)
	print " information of column loaded successfully. "

try:
	inpfp=open(inpfile, 'r')
	print " loading information from: [",inpfile,"]"
except IOError:
	print " can not open file: [",inpfile,"]"
	exit(-1)

LenZ=[]
Area=[]
Ener=[]

inpfp=open(inpfile,'r')
lastlen=0
while True:
	line = inpfp.readline()
	if line: 
		elements=line.split()
	else:
		print " end of file, loading over. 1"
		break
	print line
	if len(elements) == 0:
		continue # pass this line.
	if len(elements)<lastlen:
		break;
	else:
		lastlen=len(elements)
	if colname == "Lx" :
		LenZ.append(float(elements[idcolLx]))
		Area.append(float(elements[idcolLy])*float(elements[idcolLz]))
	if colname == "Ly" :
		LenZ.append(float(elements[idcolLy]))
		Area.append(float(elements[idcolLz])*float(elements[idcolLx]))
	if colname == "Lz" :
		LenZ.append(float(elements[idcolLz]))
		Area.append(float(elements[idcolLx])*float(elements[idcolLy]))
	Ener.append(float(elements[idcolEn]))

inpfp.close()

lsize=len(Ener)
print " there are",lsize,"data loaded"
entenafp=open("stress-elongation.dat", 'w')
for i in range(0,lsize):
	print >> entenafp, "%f %f %f" % ((LenZ[i]-LenZ[0])/LenZ[0], -Ener[i]*0.101325, -Ener[i]*1.01325/1.60217733/1000000 ) 
	                                                           # mpa, ev/a^-3
entenafp.close()
print " file: [ stress-elongation.dat ] written. "
tempgplfp=open("tempdata.gpl",'w')
print >> tempgplfp, "inp='stress-elongation.dat'"
print >> tempgplfp, "out='Stress-Elongation-MPa'"
print >> tempgplfp, "colx=1"
print >> tempgplfp, "coly=2"
print >> tempgplfp, "xlabeltext='Elongation (%)'"
print >> tempgplfp, "ylabeltext='Stress (MPa)'"
tempgplfp.close()
os.system("gnuplot draw_data.gpl")
print " now you can check file: [ Stress-Elongation-MPa.eps ]."

tempgplfp2=open("tempdata.gpl",'w')
print >> tempgplfp2, "inp='stress-elongation.dat'"
print >> tempgplfp2, "out='Stress-Elongation-eV'"
print >> tempgplfp2, "colx=1"
print >> tempgplfp2, "coly=3"
print >> tempgplfp2, "xlabeltext='Elongation (%)'"
print >> tempgplfp2, "ylabeltext='Stress (eV/A^3)'"
tempgplfp2.close()
os.system("gnuplot draw_data.gpl")
print " now you can check file: [ Stress-Elongation-eV.eps ]."


exit(0)

## the following code not neccessary at this moment.

stressfp=open("stress-strain.dat", 'w')

#print (LenZ[2]-LenZ[0])
#print Area[0]
#recordflag=False
#if recordflag == True or LenZ[2]-LenZ[0] !=0 :
if LenZ[2]-LenZ[0] != 0 :
	print >> stressfp, "%f %f" % (abs(LenZ[0]-LenZ[0]), (-3*Ener[0]+4*Ener[1]-Ener[2])/(LenZ[2]-LenZ[0])/Area[0])
#	if recordflag == False:
#		recordflag = True
#if recordflag == True or LenZ[2]-LenZ[0] !=0 :
if LenZ[3]-LenZ[1] != 0 :
	print >> stressfp, "%f %f" % (abs(LenZ[1]-LenZ[0]), (-3*Ener[1]+4*Ener[2]-Ener[3])/(LenZ[3]-LenZ[1])/Area[1])
#	if recordflag == False:
#		recordflag = True

for i in range(2,lsize-2):
	average=(LenZ[i+2]-LenZ[i-2])/4
	average=12*average
	if average != 0 :
		print >> stressfp, "%f %f" % (abs(LenZ[i]-LenZ[0]), (-Ener[i+2]+8*Ener[i+1]-8*Ener[i-1]+Ener[i-2])/average/Area[i])

if LenZ[lsize-2]-LenZ[lsize-4] != 0 :
	print >> stressfp, "%f %f" % (abs(LenZ[lsize-2]-LenZ[0]), \
		(3*Ener[lsize-2]-4*Ener[lsize-3]+Ener[lsize-4])/(LenZ[lsize-2]-LenZ[lsize-4])/Area[lsize-1])
if LenZ[lsize-1]-LenZ[lsize-3] != 0 :
	print >> stressfp, "%f %f" % (abs(LenZ[lsize-1]-LenZ[0]), \
		(3*Ener[lsize-1]-4*Ener[lsize-2]+Ener[lsize-3])/(LenZ[lsize-1]-LenZ[lsize-3])/Area[lsize-1])
stressfp.close()
print " file: [ stress-strain.dat ] written. "

tempgplfp=open("tempdata.gpl",'w')
print >> tempgplfp, "inp='stress-strain.dat'"
print >> tempgplfp, "out='Stress-Strain'"
print >> tempgplfp, "colx=1"
print >> tempgplfp, "coly=2"
print >> tempgplfp, "xlabeltext='Strain'"
print >> tempgplfp, "ylabeltext='Stress'"
tempgplfp.close()

os.system("gnuplot draw_data.gpl")

print " now you can check file: [ Stress-Strain.eps ]."




