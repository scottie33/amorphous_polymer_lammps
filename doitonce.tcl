proc make_whole {mol sel frame num chn rad boxlen} { 
	molinfo $mol set frame $frame
	$sel frame $frame
	set allcoord [$sel get {x y z}]
	set num1 [expr {$num - 1}]
	set boxhalf [] ;#box dimension half;
	lappend boxhalf [expr $boxlen/2.0]
	lappend boxhalf [expr $boxlen/2.0]
	lappend boxhalf [expr $boxlen/2.0]
	#puts "$boxhalf"
	#set la [lindex boxhalf 0]
	#set lb [lindex boxhalf 1]
	#set lc [lindex boxhalf 2]
	#set boxhalf {}
	#if { [expr $num*$rad] } {
	#}
	set newcoord {}
	set firstlen [expr $num*$chn]
	set lastcoord [lrange $allcoord $firstlen end]
	set lenlastcoord [llength $lastcoord]
	puts " [format "%8d" $frame]: length of lastcoord: $lenlastcoord"
	set allcoord [lrange $allcoord 0 [expr $firstlen-1]]
	while {[llength $allcoord] > 0} { ;# every num coor;
		set coord [lrange $allcoord 0 $num1] ;# [0,num-1] coors;
		set allcoord [lrange $allcoord $num end] ;# [num, end] coors for the next round;
		set ref [lindex $coord 0] ;
		lappend newcoord $ref 
		#set num 1
		foreach atom [lrange $coord 1 end] {
			#set num [expr $num+1]
			#puts $num

			set newatom {} 
			set dist [vecsub $atom $ref]
			foreach d $dist b $boxhalf r $atom {
				
				if { $d < -$b } { 
					puts "$ref v.s. $atom"
					set r [expr $r+2.0*$b]
					set d [expr $d+2.0*$b]
					if { $d < -$b } {
						set r [expr $r+2.0*$b]
						set d [expr $d+2.0*$b]
					}
				} 
				if { $d > $b } { 
					puts "$ref v.s. $atom"
					set r [expr $r-2.0*$b]
					set d [expr $d-2.0*$b]
					if { $d > $b } {
						set r [expr $r-2.0*$b]
						set d [expr $d-2.0*$b]
					}
				} 
				lappend newatom $r 
			}
			lappend newcoord $newatom 
			set ref $newatom  ;#current ref. virtually 1st atom coor.
		}
	}
	if { $lenlastcoord > 0 } {	
		foreach atom [lrange $lastcoord 0 $lenlastcoord] {
			lappend newcoord $atom 
		}
		#puts "happend, and the size is: [llength $newcoord]"
		#lappend newcoord $atom 
	}
	$sel set {x y z} $newcoord
	return 0
}
set mol [molinfo top] 
set ring [atomselect $mol {all}] 
#sreturn 0

set nf [molinfo $mol get numframes] 
for {set i 0} {$i < $nf} {incr i} {
	make_whole $mol $ring $i 64 1 4.7 100.0;#if 100, the total number has to be 100N;
	puts "$i"
}
