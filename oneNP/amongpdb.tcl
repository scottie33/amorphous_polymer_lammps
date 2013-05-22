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
set iresids 0
set ireside 1
set distance 1.0
set deltadis 0.1
set withindis 2.0
#set pdbdir "."
source tempinput.tcl
set ldis [expr $distance+$deltadis]
set sdis [expr $distance-$deltadis]
puts " searching all pairs of dis \[${ldis}:${sdis}\]"

set mydata {}

proc my_analysis { frame } {
  #global inputpsf 
  #global inputdcd
  puts " analyzing the ${frame}-th frame ... " 
  global mydata
  global sresids 
  global sreside 
  global eresids 
  global ereside 
  global iresids 
  global ireside 
  #global distance
  #global deltadis 
  global withindis 
  global ldis
  global sdis
  #global pdbdir
  set sel1 [atomselect top "resid ${sresids} to ${sreside}"]
  set sel2 [atomselect top "resid ${eresids} to ${ereside}"]
  set indices1 [$sel1 get index]
  #puts $indices1
  #set num1 [$sel1 num]
  #set num1 [format "%.4f" $num1]

  set indices2 [$sel2 get index]
  #set num2 [$sel2 num]
  #set num2 [format "%.4f" $num2]
  #puts " there'are $num1 and $num2 items in the 1st and 3rd selections respectively."
  #puts -nonewline " \[$num1 items\] :"
  #lappend mydata [measure center $sel]
  set flag 0
  #puts "0dsfsdf"
  set fnum 0
  set ftot 0
  foreach j $indices1 { ;# P
    #puts -nonewline " here I am :"
    #puts " hell : $eresids $ereside $ldis $sdis $j"
    # (resid 1 to 64) and (within 10 of index 65) and not (within 8 of index 65)
    #puts "good"
    set tempsel [atomselect top "(index $indices2) and (within $ldis of index $j) and not (within $sdis of index $j)"]
    #puts "here"
    #if { $tempsel } {
    #set "1..."
    set tempnum [${tempsel} num]
    #puts $tempnum
    if { $tempnum > 0 } {
      set coora [[atomselect top "index $j"] get {x y z}]
      set coora [lindex $coora 0]
      #puts "miao miao"
      #puts " fr-${frame} : \[ ${tempnum} aps \] in \[${ldis}:${sdis}\]"
      set idlist [$tempsel get index]
      #puts $idlist
      foreach anotherid $idlist {
        incr fnum
        
        set coorb [[atomselect top "index $anotherid"] get {x y z}]
        set coorb [lindex $coorb 0]
        #puts "here"
        set insel [atomselect top "(resid $iresids to $ireside) and not (index $j $anotherid) and within $ldis of (index $j $anotherid)"]
        set idlist2 [$insel get index]
        #puts " now the amonglist: $idlist2"
        set tempnumber 0
        if { $flag == 0 } {
          set listindex {}
        }
        foreach thirdid $idlist2 {
          set coorc [[atomselect top "index $thirdid"] get {x y z}]
          set coorc [lindex $coorc 0]

          set dis1 [vecsub $coorb $coora]
          set dis2 [vecsub $coora $coorc]
          set dis3 [vecsub $coorc $coorb]
          set area [veclength [veccross $dis1 $dis2]]
          set tempdis [expr $area/[veclength $dis1]]
          if { $tempdis < $withindis } {
            if { [vecdot $dis1 $dis2] < 0.0 } {
              if { [vecdot $dis1 $dis3] < 0.0 } {
                incr tempnumber
                if { $flag == 0 } {
                  lappend listindex $thirdid
                }
              }
            }
          }
        }
        if { $tempnumber > 0 } {
          set ftot [expr $ftot+$tempnumber]
        }
        if { $tempnumber > [expr $ftot/$fnum] } {
          if { $flag == 0 } { 
            lappend listindex $j
            lappend listindex $anotherid
            [atomselect top "index [lindex $listindex {}]"] writepdb CLD$frame.pdb
            set flag 1
          }
        }
      }
    }
    #$tempsel delete
    #$tempnum delete
    #}
    set tempindex2 [lsearch $indices2 $j]
    if { $tempindex2 >= 0 } {
      set indices2 [lreplace $indices2 $tempindex2 $tempindex2]
      #puts " [lindex $indices2 $tempindex2]"
      #puts " $tempindex2 deleted"
      #puts " [lindex $indices2 $tempindex2]"
    }
  } 
  puts "[list $ftot $fnum [expr [format "%.4f" $ftot]/[format "%.4f" $fnum]]]"
  lappend mydata [list $ftot $fnum [expr [format "%.4f" $ftot]/[format "%.4f" $fnum]]]
  #puts " $indices2"
  $sel1 delete
  $sel2 delete
  $indices1 delete
  $indices2 delete
}


#cd /home/justin/vmd/vmd/proteins

analyze my_analysis

mol load psf ${inputpsf} dcd ${inputdcd}

set fp [open "cylinder.dat" "w"]

foreach tdata $mydata {
  puts $tdata
  foreach {a b c} $tdata {
    #puts "$a $b $c"
    puts $fp "$a $b $c"
  }
}
close $fp

quit


# analysis ends here #