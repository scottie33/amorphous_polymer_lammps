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
set eresids 0
set ereside 1
set distance 1.0
set deltadis 0.1
set withindis 2.0
set pdbdir "."
source tempinput.tcl
set ldis [expr $distance+$deltadis]
set sdis [expr $distance-$deltadis]
puts " searching all pairs of dis \[${ldis}:${sdis}\]"
#set mydata {}

proc my_analysis { frame } {
  #global inputpsf 
  #global inputdcd
  puts " analyzing the ${frame}-th frame ... " 
  global sresids 
  global sreside 
  global eresids 
  global ereside 
  #global distance
  #global deltadis 
  global withindis 
  global ldis
  global sdis
  global pdbdir
  set sel1 [atomselect top "resid ${sresids} to ${sreside}"]
  #set sel2 [atomselect top "resid ${eresids} to ${ereside}"]
  set indices1 [$sel1 get index]
  #puts $indices1
  set num1 [$sel1 num]
  set num1 [format "%.4f" $num1]
  set flag 0
  #set indices2 [$sel2 get index]
  #set num2 [$sel2 num]
  #set num2 [format "%.4f" $num2]
  #puts " there'are $num1 and $num2 items in the 1st and 2nd selections respectively."
  #puts -nonewline " \[$num1 items\] :"
  #lappend mydata [measure center $sel]
  foreach j $indices1 { ;# P
    #puts -nonewline " here I am :"
    #puts " hell : $eresids $ereside $ldis $sdis $j"
    # (resid 1 to 64) and (within 10 of index 65) and not (within 8 of index 65)
    set tempsel [atomselect top "(resid $eresids to $ereside) and (within $ldis of index $j) and not (within $sdis of index $j)"]
    #if { $tempsel } {
    set tempnum [${tempsel} num]
  
    if { $tempnum > 0 } {
      #puts " fr-${frame} : \[ ${tempnum} aps \] in \[${ldis}:${sdis}\]"
      set anotherid [lindex [$tempsel get index] 0]
      puts " $j and $anotherid "
      set ttsel [atomselect top "within ${withindis} of (index $j or index $anotherid)"]
      $ttsel writepdb ${pdbdir}/${frame}-${j}.pdb
      $ttsel delete
      set flag 1
    }
    $tempsel delete
    $tempnum delete
    if { $flag != 0 } {
      break
    }
    #}
  } 
  #puts " end # "
  $sel1 delete
  #$sel2 delete
  $indices1 delete
  #$indices2 delete
}


#cd /home/justin/vmd/vmd/proteins

analyze my_analysis

mol load psf ${inputpsf} dcd ${inputdcd}

quit


# analysis ends here #