#mol new $file waitfor all
#-------------------------------------------
#Do not suggest use this command, too slow

#-------------------------------------------
#Get number of frames
set numframes [molinfo top get numframes]	

#-------------------------------------------
#Open dump file
set fp [open $file r]

#-------------------------------------------
#Select the top molecular
set sel [atomselect top all]

#-------------------------------------------
#Loop number of frames
for {set i 0} {$i<$numframes} {incr i} {			
#-----------------------------
#Get line from file but ignore
gets $fp								

#Get line from file and assign it as timestep
gets $fp timestep							
gets $fp

#-----------------------------
#Get number of atoms
gets $fp numatoms	

#-----------------------------
#Display for checking						
puts "$timestep $numatoms"					
gets $fp 
gets $fp 
gets $fp 
gets $fp 
gets $fp

#-----------------------------
#Set four empty lists
set ulist  {}							
set ulist2 {}
set ulist3 {}
set ulist4 {}

#-----------------------------
#Display where we are
puts "setting user values for frame $i."			

#-----------------------------
#Loop numatoms for reading items
for {set j 0} {$j<$numatoms} {incr j} {			
#---------------------
#Activate current $i frame
animate goto $i
		
#---------------------					
#Get current line to $line
gets $fp line		

#---------------------
#Append last(-123) element to ulist(123)
lappend ulist [lindex $line end]				
lappend ulist2 [lindex $line end-1]
lappend ulist3 [lindex $line end-2]
lappend ulist4 [lindex $line end-3]

}

#-----------------------------
#Assign ulist  to user
$sel set user  $ulist						
$sel set user2 $ulist2						
$sel set user3 $ulist3
$sel set user4 $ulist4
}

#-------------------------------------------
#Delete selected molecular
$sel delete								