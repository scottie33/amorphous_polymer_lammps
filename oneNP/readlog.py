#!/usr/bin/python
import sys,os

#print len(sys.argv)
if len(sys.argv) < 2: 
	#raise StandardError, "Syntax: readlog.py [keyword: to start reading] [outputfilename]"
	print "\n This command is used to load log file from lammps production run to create figures."
	#print " after using this, do not forget using [\"showdata.bash\"] to see your data.\n"
	print " [syntax]: readlog.py logfilename [keyword: 1st KeyWord to dump] [outputfilename]\n"
	print " example: readlog.py example.log Step example.inputfornextcmd "
	print "\n keyword is set defaultly to \"Step\", which is normally the first col of your dump..."
	print " uh... again, for keyword, maybe you need2 have a look at your .log file...\n"
	print " if any problem, improvement made, or any Q, please contact me: [ leiw@ustc.edu.cn ]\n"
	exit(-1)

inpfile = sys.argv[1]

if len(sys.argv) >= 3:
	keyword = sys.argv[2]
else:
	keyword = "Step"

if len(sys.argv) >= 4: 
	outfile = sys.argv[3] 
else:
	outfile = inpfile[0:len(inpfile)-4]+".gnuplot.dat"

print ""
print " 1, loading [",inpfile,"],\n 2, started from: \"",keyword,"\"\n 3, output: [",outfile,"].";

inpfp = open(inpfile, 'r')
outfp = open(outfile, 'w')

flagkeyword=0
runsteps=0
logsteps=0
while True:
	line=inpfp.readline()
	if line: 
		elements=line.split()
	else:
		print " end of file, loading over. 1"
		break
	#print " ",elements," ... "
	if len(elements)!=0 and elements[0] == "run" and elements[1][0:1] != '$' :
		runsteps=int(elements[1])
	if len(elements)!=0 and elements[0] == "thermo" :
		logsteps=int(elements[1])
	if len(elements)!=0 and elements[0] == keyword :
		flagkeyword=1;
		tempstr="echo \""
		tempstr2=""
		flag=0
		for i in range(0,len(elements)):
			for j in range(0,len(elements[i])):
				if elements[i][j]== "_":
					tempstr2=elements[i][0:j]+elements[i][j+1:len(elements[i])]
					flag=1
					break
			if flag==0:
				tempstr2=elements[i]
			else:
				flag=0			
			tempstr=tempstr+tempstr2+" "
		tempstr=tempstr+"\" > itemlist.lst"
		print " 4,",tempstr;
		os.system(tempstr);
		
		print "\n   id",
		for i in range(0,len(elements)):
			tempnum=i+1
			print "%7d" % tempnum,
		print ""
		print "   nm",
		for i in range(0,len(elements)):
			print "%7s" % elements[i],
		print ""
		print "\n check [ itemlist.lst ] for column name."
	if flagkeyword==1:# and runsteps!=0 :
		break;
if flagkeyword==0:
	print " no records in [",inpfile,"]."
	exit(-1)
else :
	if runsteps!=0:
		print "\n there are",runsteps,"(or divided by a num) data, here we go~"
	else:
		print "\n start reading data without runsteps, but will end at \"Loop\""
	if logsteps!=0:
		print " every",logsteps,"steps a log row added~"
	else:
		print " we don't notice any \"thermo\" there." 
		#exit(-1)


numrows=0
numerator=0
if runsteps!=0 and logsteps!=0:
	numerator=0
	numrows=runsteps/logsteps
	print " there should be",numrows,"rows in each run (if many, possible) this .log file.\n"

tempflag=0 #for end of file or not;
tempindex=0 #for records;

while True:
	line=inpfp.readline()
	if line: 
		elements=line.split()
	else:
		print " end of file, loading over. 1"
		break
	if len(elements) == 0:
		continue # pass this line.
	if elements[0]=="Loop":
		print " Confronting \"Loop\", found next entry @TS =",
		while True:
			line=inpfp.readline()
			if line:
				#print line
				elements=line.split()
				if len(elements)!=0 and elements[0] == keyword :
				#if len(elements)!=0 and elements[0]==str(tempindex+logsteps):
					#print elements[0],"=",str(tempindex+logsteps)
					while True:
						line=inpfp.readline()
						elements=line.split()
						if len(elements)!=0:
							break # skip this line cuz this is the same line of the last output.
					while True:
						line=inpfp.readline()
						elements=line.split()
						if len(elements)!=0:
							break # the real entry loaded.
					print elements[0]
					break
			else:
				#print " end of file, loading over."
				tempflag=1
				break;
	if tempflag==1:
		print " end of file, loading over. 2"
		break
	for i in range(0,len(elements)-1):
		print >> outfp, elements[i],
	print >> outfp, elements[-1]
	tempindex=int(elements[0])
	#if numrows!=0:
	#	numerator=numerator+1
	#	#print numerator
	#	if numerator>numrows:
	#		break;

inpfp.close()
outfp.close()
print " all data loaded, now you can dwuw with 'em cheers. :-) "



