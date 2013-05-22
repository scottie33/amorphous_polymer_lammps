
set sel [atomselect top "resid 17"]
set dimension [lindex [pbc get -now] 0]
set centercoor {}
for { set i 0 } { $i < 3 } { incr i } {
	lappend centercoor [expr [lindex $dimension $i]/2.0]
}
puts $centercoor
puts [lindex [$sel get {x y z}] 0]
puts [vecsub [lindex [$sel get {x y z}] 0] $centercoor]
pbc wrap -shiftcenter [vecsub $centercoor [lindex [$sel get {x y z}] 0]] -all
#pbc wrap -centersel $sel -all
