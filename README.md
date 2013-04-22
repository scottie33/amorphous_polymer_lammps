
pre-run:

1, **lmp2pdb.py** data.dat (generate .psf and .pdb for post-processing)

2, **makepair** will generate a pair_potential file for you, revise it if needed.

run:

1, **runlist.bash**

post-run:

1, **readlog.py**

2, **create_html.bash** dependencies:

a, **draw_data.gpl**

b, **showdata.bash**

*, topology of the usage:

                 / create_html.bash

    readlog.py {

                 \ getstress.py
 
**rdf.bash** (.psf needed, using **lmp2pdb.py**)

**contact.bash** (.psf needed, using **lmp2pdb.py**)

./clean.bash will do purge for this command, use it carefully.
