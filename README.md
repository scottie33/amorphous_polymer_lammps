to get the newest version:

 wget https://github.com/scottie33/amorphous_polymer_lammps/archive/master.zip 

pre-run: 
[goto 3]*1*, lmp2pdb.py data.data (generate .psf and .pdb for post-processing)
[goto 3]*2*, makepair will generate a pair_potential file for you, revise it if needed.
[dont use this when system too compressed]#2, after .dcd loaded by vmd: source doit.tcl
3, protocol to initialization of the system:
   a: random-NP.py | cubic-NP.py (revise it mannually)
   b: mc_gen.bash [make_mc_gen.x] [mc_gen] (revise .input whenever needed)
   c: makepair001.py | makepair_expand.py
      mv pairfile pairfile_no_soft (please do not ask why...)

run:
1, runlist.bash

post-run:
you can use the following cli to see your data-fig:
1, readlog.py
2, create_html.bash
   dependencies:
   a, draw_data.gpl 
      please note, tempdata.gpl needed, 
      so actually these 2 are important and portable for any drawing)  
   b, showdata.bash
*, topology of the usage:
               / create_html.bash
   readlog.py {
               \ getstress.py
   rdf.bash -> allpeak.py -> getpdb.bash (.psf needed, using lmp2pdb.py)
   contact.bash (.psf needed, using lmp2pdb.py) 
   allpeak.py 
   getpdb.bash (.psf ... )
  
just hit them in your command line to see 'how to'
e.g.:
 ./readlog.py example.log
 ./create_html.bash example.gnuplot.dat (this file is created by the last command)
or 
 ./readlog.py example.log Step example.inputfornextcmd 
 ./create_html.bash example.inputfornextcmd

./clean.bash will do purge for this command, use it carefully.

*, avevol.py (to see energy-volume and create the volume.in for the next deform.in if needed)
Attention:

5, please be noted: trajectoy_analyze.tcl is great for the analysis of trajectory loaded in VMD, read the source for the example.

*, for the [keyword], we shall set it the 1st keyword of dump keywords in your .log file, normally "Step"
*, nothing more so far...


O(ne) C(lick) S(eries): Lammps .log file.
Dependencies: bash, python, gnuplot;
Comman Line Format : cmd log-filename.
description: you will have a .html (or all figures in .eps) of the information you are able to get from .log from a Lammps production run.

if any problem, improvement made, or any Q, please contact me: leiw@ustc.edu.cn
