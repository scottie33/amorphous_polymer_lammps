
set inputpsf "temp.psf"
set inputdcd "temp.dcd"

set outputfile2 "contacts.dat"
set sresids 1
set sreside 64
set eresids 65
set ereside 65
set r1 1.0
set r2 1.0
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
$sel1 delete
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
$sel2 delete
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
set chainlen []
set resilist []
foreach j $indices1 { ;# 
	set tempre [atomselect $mol "index $j"]
	set tresid [$tempre get resid]
	lappend resilist $tresid
	$tempre delete
	set tempcn [atomselect $mol "resid $tresid"]
	set tempcl  [format "%.4f" [$tempcn num]]
	lappend chainlen $tempcl
	$tempcn delete
}
puts " now loading $nf into memory..."
for { set i 0 } { $i < $nf } { incr i } {
	molinfo $mol set frame $i
	puts " the $i - th frame "
	set numPP 0
	#set numPN 0
	set numNP 0
	set numNN 0
	foreach j $indices1 tempcl $chainlen tresid $resilist { ;# P
		#puts " $j $tempcl "
		set tempPP [atomselect $mol "(resid $sresids to $sreside) and (not resid $tresid) and (within $r11ranged of index $j)"]
		#set numPP [expr $numPP+[$tempPP num]-1-2*($tempcl-1)/$tempcl] # with intra-contacts calculated
		set numPP [expr $numPP+[$tempPP num]]
		$tempPP delete
		#$tempPN delete
		set tempNP [atomselect $mol "(within $r12ranged of index $j) and (resid $eresids to $ereside)"]
	#	set tempNN [atomselect $mol "(resid $eresids to $ereside) and within $r22ranged of index $j"]
		set numNP [expr $numNP+[$tempNP num]]
	#	set numNN [expr $numNN+[$tempNN num]-1]
		$tempNP delete
	#	$tempNN delete
	}
	foreach j $indices2 { ;# N
		set tempNN [atomselect $mol "(within $r22ranged of index $j) and (resid $eresids to $ereside)"]
		set numNN [expr $numNN+[$tempNN num]-1]
		$tempNN delete
	}
	#puts $numNP
	#lappend CPP [expr $numPP/$numP]
	#lappend CPN [expr $numPN/$numP]
	#lappend CNP [expr $numNP/$numN]
	#lappend CNN [expr $numNN/$numN]
	puts $outfile2 [format "%d %.4f %.4f %.4f" [expr $i+1] [expr $numPP] [expr $numNP] [expr $numNN]];# [expr $numNP/$numN] [expr $numNN/$numN]]
}

#for { set i 0 } { $i < $nf } { incr i } {
#  puts $outfile2 [format "$8d\t%.4f\t%.4f\t%.4f\t%.4f" $i [lindex $CPP $i] [lindex $CPN $i] [lindex $CNP $i] [lindex $CNN $i]]
#}
puts " you have your contacts [$outputfile2] now, we are done."
close $outfile2
exit 
