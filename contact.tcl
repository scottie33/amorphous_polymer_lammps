
set inputpsf "temp.psf"
set inputdcd "temp.dcd"

set outputfile "contacts.dat"
set sresids 1
set sreside 64
set eresids 65
set ereside 65
set r1 4.7
set r2 4.7
set range 2.0
source "tempinput.tcl"
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

set indices1 [$sel1 get {index}]
set numP [$sel1 num]
puts " there's $numP items in the 1st choice."

if { $eresids < $ereside } {
	set sel2 [atomselect top "resid $eresids to $ereside"]
} elseif { $eresids == $ereside } {
	set sel2 [atomselect top "resid $eresids"]
} else {
	puts " you can not specify resid like this: $eresids > $ereside"
	exit
}

set indices2 [$sel2 get {index}]
set numN [$sel2 num]
puts " there's $numN items in the 2nd choice."

puts " resid: $sresids to $sreside"
puts " versus "
puts " resid: $eresids to $ereside" 
set outfile1 [open $outputfile w]
set CPP {}
set CPN {}
set CNP {}
set CNN {}
set mol [molinfo top] 
set nf [molinfo $mol get numframes] 
for { set i 0 } { $i < $nf } { incr i } {
	molinfo $mol set frame $i
	set numPP 0
	set numPN 0
	set numNP 0
	set numNN 0
	foreach j $indices1 { ;# P
		set tempPP [atomselect $mol "resid $sresids to $sreside and within [expr $r1*$range] of index $j"]
		set tempPN [atomselect $mol "resid $eresids to $ereside and within [expr $r1*$range] of index $j"]
		set numPP [expr $numPP+[$tempPP num]]
		set numPN [expr $numPN+[$tempPN num]]
		$tempPP delete
		$tempPN delete
	}
	foreach j $indices2 { ;# N
		set tempNP [atomselect $mol "resid $sresids to $sreside and within [expr $r2*$range] of index $j"]
		set tempNN [atomselect $mol "resid $eresids to $ereside and within [expr $r2*$range] of index $j"]
		set numNP [expr $numNP+[$tempNP num]]
		set numNN [expr $numNN+[$tempNN num]]
		$tempNP delete
		$tempNN delete
	}
	lappend CPP [expr $numPP/$numP]
	lappend CPN [expr $numPN/$numP]
	lappend CNP [expr $numNP/$numN]
	lappend CNN [expr $numNN/$numN]
}

for { set i 0 } { $i < $nf } { incr i } {
  puts $outfile1 [format "$8d\t%.4f\t%.4f\t%.4f\t%.4f" $i [lindex $CPP $i] [lindex $CPN $i] [lindex $CNP $i] [lindex $CNN $i]]
}

close $outfile1
#exit 
