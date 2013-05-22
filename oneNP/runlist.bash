#!/bin/bash

PNUM=16
EXEC=lmp_g++

#echo " running premin now..."
#lammps < premin.in &> premin.log
#echo " premin ended."

for i in `echo minimization nvthightemp deformation annealing npt2zero be4nvtlow nvtlowtemp stretching`; do 
	#echo "$i.in"
	echo " running $i now..." 
	mpirun -np ${PNUM} ${EXEC} < $i.in  
	if [ $i == "npt2zero" ]; then
		echo " creating volume dimension ... "
		python < avevol.py
	fi
	echo " $i ended."
done

exit 0 


echo " running equilibration001 now..."
mpirun -np ${PNUM} ${EXEC} < equilibration001.in  
echo " equilibration001 ended."
echo " running equilibration002 now..."
mpirun -np ${PNUM} ${EXEC} < equilibration002.in  
echo " equilibration002 ended."
echo " running equilibration003 now..."
mpirun -np ${PNUM} ${EXEC} < equilibration003.in  
echo " equilibration003 ended."


