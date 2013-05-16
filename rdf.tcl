
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
set radiimax 50.0
source "tempinput.tcl"
set range [expr 1.1*[expr pow(2.0,1.0/6.0)]]
set r11ranged [expr $r1*$range]
set r12ranged [expr [expr ($r1+$r2)/2.0]*$range]
set r22ranged [expr $r2*$range]
set r21ranged $r12ranged
puts " loading from $inputdcd using structure information $inputpsf."
puts " sel1=\[$sresids:$sreside\]"
puts " sel1=\[$eresids:$ereside\]"
puts " sigma1=$r1, will calculate in distance (0:$r11ranged]"
puts " sigma2=$r2, will calculate in distance (0:$r22ranged]"
puts " 1<->2, will calculate in distance (0:$r12ranged]"
puts " 2<->1, will calculate in distance (0:$r21ranged]"

mol load psf $inputpsf dcd $inputdcd

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

puts " resid: $sresids to $sreside"
puts " versus "
puts " resid: $eresids to $ereside" 
puts " now RDF calculation start, please wait ..."
set outfp1 [open $outputfile1 w]
set gr0 [measure gofr $sel1 $sel2 delta 0.025 rmax $radiimax usepbc 1 selupdate 1 first 0 last -1 step 1]
set r [lindex $gr0 0]
set gr [lindex $gr0 1]
set igr [lindex $gr0 2]
set isto [lindex $gr0 3]
foreach j $r k $gr l $igr m $isto {
  puts $outfp1 [format "%.4f\t%.4f\t%.4f\t%.4f" $j $k $l $m]
}
close $outfp1
puts " you have your RDF \[$outputfile1\] now, we then shall do the contacting number parts."


exit

