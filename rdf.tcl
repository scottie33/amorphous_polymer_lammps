
set inputpsf "temp.psf"
set inputdcd "temp.dcd"

set outputfile1 "grdf.dat"
set outputfile2 "contacts.dat"
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
set outfp1 [open $outputfile1 w]
set gr0 [measure gofr $sel1 $sel2 delta 0.05 rmax 20.0 usepbc 1 selupdate 1 first 0 last -1 step 1]
set r [lindex $gr0 0]
set gr [lindex $gr0 1]
set igr [lindex $gr0 2]
set isto [lindex $gr0 3]
foreach j $r k $gr l $igr m $isto {
  puts $outfp1 [format "%.4f\t%.4f\t%.4f\t%.4f" $j $k $l $m]
}
close $outfp1


exit 
