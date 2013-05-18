proc analyze_callback { name1 name2 op } {
  global analyze_proc

  upvar $name1 arr
  set frame $arr($name2)
  uplevel #0 $analyze_proc $frame
}

proc analyze { script } {
  global analyze_proc
  #puts "hha"
  set analyze_proc $script
  uplevel #0 trace variable vmd_frame w analyze_callback
}


## code for analysis starts from here#

set inputpsf "noname.psf"
set inputdcd "noname.dcd"
set sresids 0
set sreside 1
source tempinput.tcl
set rofgyrx {}
set rofgyry {}
set rofgyrz {}
set totres [expr $sreside-$sresids+1]
puts " $totres residues will be taken into consideration..."
proc my_analysis { frame } {
  #global inputpsf 
  #global inputdcd
  puts " analyzing the ${frame}-th frame ... " 
  global sresids 
  global sreside
  global rofgyrx
  global rofgyry
  global rofgyrz
  global totres
  set gyrx 0.0
  set gyry 0.0
  set gyrz 0.0
  set listlen 0
  #set temprgyr 0.0 ;#testing
  for { set i $sresids } { $i <= $sreside } { incr i } {
    #puts " $i $sreside"
    set sel [atomselect top "resid $i"]
    #set t [measure rgyr $sel] ;#testing
    #set temprgyr [expr $temprgyr+$t*$t] ;#testing
    
    set comxyz [measure center $sel]
    #puts $comxyz
    set allelements [$sel get x]
    set listlen [llength $allelements]
    set comx [lindex $comxyz 0]
    set temptot 0.0
    foreach element $allelements {
      set temptot [expr $temptot+($element-$comx)*($element-$comx)]
    }
    set gyrx [expr $gyrx+$temptot/$listlen]
    #puts $gyrx
    set allelements [$sel get y]
    set comy [lindex $comxyz 1]
    set temptot 0.0
    foreach element $allelements {
      set temptot [expr $temptot+($element-$comy)*($element-$comy)]
    }
    set gyry [expr $gyry+$temptot/$listlen]

    set allelements [$sel get z]
    set comz [lindex $comxyz 2]
    set temptot 0.0
    foreach element $allelements {
      set temptot [expr $temptot+($element-$comz)*($element-$comz)]
    }
    set gyrz [expr $gyrz+$temptot/$listlen]
    
  }
  #puts [expr sqrt($temprgyr/$totres)] ;#testing
  #puts [expr sqrt(($gyrx+$gyry+$gyrz)/$totres)] ;#testing
  lappend rofgyrx [expr $gyrx/$totres]
  lappend rofgyry [expr $gyry/$totres]
  lappend rofgyrz [expr $gyrz/$totres]
}


#cd /home/justin/vmd/vmd/proteins

analyze my_analysis

mol load psf ${inputpsf} dcd ${inputdcd}

set outputfile "rogyrxyz.dat"
set outfp [open $outputfile w]
set tnum 1
foreach i $rofgyrx j $rofgyry k $rofgyrz {
  #puts $outfp [format "%d\t%.4f\t%.4f\t%.4f" $tnum $i [expr ($j-$i)/$i] [expr ($k-$i)/$i]]
  puts $outfp [format "%d\t%.4f\t%.4f\t%.4f" $tnum $i $j $k]
  incr tnum
}

close $outfp 

quit


# analysis ends here #