
set inputpsf "temp.psf"
set inputdcd "temp.dcd"

set outputfile2 "contacts.dat"
set sresids 1
set sreside 64
set eresids 65
set ereside 65
set r1 4.7
set r2 4.7
source "tempinput.tcl"
set range [expr 1.1*[expr pow(2.0,1.0/6.0)]]
set r1ranged [expr $r1*$range]
set r2ranged [expr $r2*$range]
puts " loading from $inputdcd using structure information $inputpsf."
puts " sel1=\[$sresids:$sreside\]"
puts " sel1=\[$eresids:$ereside\]"
puts " sigma1=$r1, will calculate in distance (0:$r1ranged]"
puts " sigma2=$r2, will calculate in distance (0:$r2ranged]"

mol load psf $inputpsf dcd $inputdcd

if { $sreside > $eresids } {
	puts " you can not specify resid like this: $sreside > $eresids"
	exit
}

if { $sresids < $sreside } {
	set sel1 [atomselect top "resid $sresids to $sreside"]
} elseif { $sresids == $sreside } {
	set sel1 [atomselect top "resid $sresids"]
} else {
	puts " you can not specify resid like this: $sresids > $sreside"
	exit
}

set indices1 [$sel1 get index]
set numP [$sel1 num]
set numP [format "%.4f" $numP]
puts " there's $numP items in the 1st choice."

if { $eresids < $ereside } {
	set sel2 [atomselect top "resid $eresids to $ereside"]
} elseif { $eresids == $ereside } {
	set sel2 [atomselect top "resid $eresids"]
} else {
	puts " you can not specify resid like this: $eresids > $ereside"
	exit
}

set indices2 [$sel2 get index]
set numN [$sel2 num]
set numN [format "%.4f" $numN]
puts " there's $numN items in the 2nd choice."

puts " we will then do the contacting number parts."
puts " it's a little bit slow, please wait several minutes, or seconds, well, it depends..."
puts " resid: $sresids to $sreside"
puts " versus "
puts " resid: $eresids to $ereside" 
set outfile2 [open $outputfile2 w]
;#set CPP {}
;#set CPN {}
;#set CNP {}
;#set CNN {}
set mol [molinfo top] 
set nf [molinfo $mol get numframes] 
puts " now loading $nf into memory..."
for { set i 0 } { $i < $nf } { incr i } {
	molinfo $mol set frame $i
	puts " the $i - th frame "
	set numPP 0
	set numPN 0
	set numNP 0
	set numNN 0
	foreach j $indices1 { ;# P
		set tempPP [atomselect $mol "(resid $sresids to $sreside) and within $r1ranged of index $j"]
		set tempPN [atomselect $mol "(resid $eresids to $ereside) and within $r1ranged of index $j"]
		set numPP [expr $numPP+[$tempPP num]]
		set numPN [expr $numPN+[$tempPN num]]
		$tempPP delete
		$tempPN delete
	}
	#puts $numPN
	foreach j $indices2 { ;# N
		set tempNP [atomselect $mol "(resid $sresids to $sreside) and within $r2ranged of index $j"]
		set tempNN [atomselect $mol "(resid $eresids to $ereside) and within $r2ranged of index $j"]
		set numNP [expr $numNP+[$tempNP num]]
		set numNN [expr $numNN+[$tempNN num]]
		$tempNP delete
		$tempNN delete
	}
	#puts $numNP
	;#lappend CPP [expr $numPP/$numP]
	;#lappend CPN [expr $numPN/$numP]
	;#lappend CNP [expr $numNP/$numN]
	;#lappend CNN [expr $numNN/$numN]
	puts $outfile2 [format "%d %.4f %.4f %.4f %.4f" [expr $i+1] [expr $numPP/$numP] [expr $numPN/$numP] [expr $numNP/$numN] [expr $numNN/$numN]]
}

#for { set i 0 } { $i < $nf } { incr i } {
#  puts $outfile2 [format "$8d\t%.4f\t%.4f\t%.4f\t%.4f" $i [lindex $CPP $i] [lindex $CPN $i] [lindex $CNP $i] [lindex $CNN $i]]
#}
puts " you have your contacts [$outputfile2] now, we are done."
close $outfile2
exit 
