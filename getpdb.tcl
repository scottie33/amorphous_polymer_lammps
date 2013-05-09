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
set posflag 0
set pos_xmin 0.0
set pos_xmax 0.0
set pos_ymin 0.0
set pos_ymax 0.0
set pos_zmin 0.0
set pos_zmax 0.0
set fraction 0.2
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
  global posflag
 
  global pos_xmin
  global pos_xmax
  global pos_ymin
  global pos_ymax
  global pos_zmin
  global pos_zmax
  global fraction

  if { $posflag == 0 } {
    #puts "1"
    set posall [atomselect top "all"]
    #set pos_x [lindex [$posall get x] 0]
    #set pos_y [lindex [$posall get y] 1]
    #set pos_z [lindex [$posall get z] 2]
    set pos_minmax [measure minmax $posall]
    $posall delete
    set pos_min [lindex $pos_minmax 0]
    set pos_max [lindex $pos_minmax 1]
    #puts " $pos_min"
    #puts " $pos_max"

    set pos_xmin [lindex $pos_min 0]
    set pos_xmax [lindex $pos_max 0]
    set pos_ymin [lindex $pos_min 1]
    set pos_ymax [lindex $pos_max 1]
    set pos_zmin [lindex $pos_min 2]
    set pos_zmax [lindex $pos_max 2]

    puts " < $pos_xmin : $pos_xmax >"
    puts " < $pos_ymin : $pos_ymax >"
    puts " < $pos_zmin : $pos_zmax >"

    set xrange [expr ($pos_xmax-$pos_xmin)*${fraction}]
    set yrange [expr ($pos_ymax-$pos_ymin)*${fraction}]
    set zrange [expr ($pos_zmax-$pos_zmin)*${fraction}]

    set xpos [expr ($pos_xmax-$pos_xmin)/2.0]
    set ypos [expr ($pos_ymax-$pos_ymin)/2.0]
    set zpos [expr ($pos_zmax-$pos_zmin)/2.0]

    set pos_xmin [expr $xpos-$xrange]
    set pos_xmax [expr $xpos+$xrange]
    set pos_ymin [expr $ypos-$yrange]
    set pos_ymax [expr $ypos+$yrange]
    set pos_zmin [expr $zpos-$zrange]
    set pos_zmax [expr $zpos+$zrange]

    #set pos_y [measure minmax $pos_y]
    #set pos_z [measure minmax $pos_z]
    puts " < $pos_xmin : $pos_xmax >"
    puts " < $pos_ymin : $pos_ymax >"
    puts " < $pos_zmin : $pos_zmax >"
    set posflag 1
    #exit -1
  } 

  #puts "0dsfsdf"
  foreach j $indices1 { ;# P
    #puts -nonewline " here I am :"
    #puts " hell : $eresids $ereside $ldis $sdis $j"
    # (resid 1 to 64) and (within 10 of index 65) and not (within 8 of index 65)
    #puts "here"
    set tempfirsel [atomselect top "(x>$pos_xmin and x<$pos_xmax and y>$pos_ymin and y<$pos_ymax and z>$pos_zmin and z<${pos_zmax}) and (index $j)"]
    set tempfirnum [$tempfirsel num]
    set coortemp [$tempfirsel get {x y z}]
    $tempfirsel delete
    #puts "what?"
    if { $tempfirnum != 1 } {
      #puts " $j : $coortemp not in this range"
      continue
    }
    set tempsel [atomselect top "(resid $eresids to $ereside) and (within $ldis of index $j) and not (within $sdis of index $j)"]
    #puts "here"
    #if { $tempsel } {
    #set "1..."
    set tempnum [${tempsel} num]
  
    if { $tempnum > 0 } {
      #puts "miao miao"
      #puts " fr-${frame} : \[ ${tempnum} aps \] in \[${ldis}:${sdis}\]"
      set anotherid [lindex [$tempsel get index] 0]
      
      set ttsel [atomselect top "within ${withindis} of (index $j or index $anotherid)"]
      set tempdis 0.0
      #
      set coora [[atomselect top "index $j"] get {x y z}]
      set coora [lindex $coora 0]
      set coorb [[atomselect top "index $anotherid"] get {x y z}]
      set coorb [lindex $coorb 0]
      #puts "$coora $coorb"
      #for {set i 0} { $i < 3 } { incr i }  {
        #set tempa [lindex $coora $i]
        #puts $tempa
        #set tempb [lindex $coorb $i]
        #puts $tempb
        #pust "$tempa $tempb"
        #set tempdis [expr $tempdis+($tempa-$tempb)*($tempa-$tempb)]
      #}
      #set tempdis [expr sqrt($tempdis)]
      #set tempdis [format "%.3f" $tempdis]
      set tempdis [format "%.3f" [veclength [vecsub $coora $coorb]]]
      #puts $tempdis
      set tname ${pdbdir}/${frame}-${j}-${anotherid}-${tempdis}.pdb
      $ttsel writepdb $tname
      
      set templist [$ttsel get {resid index}]
      set tnum [$ttsel num]
      puts " there are $tnum atoms in this pdb file."
      set tfp [open $tname a]
      #CONECT    1    2
      for { set k 1 } { $k < $tnum } { incr k } {
        #puts "$k"
        set alist [lindex $templist [expr $k-1]] 
        set blist [lindex $templist $k]
        foreach {aresid aindex} $alist {bresid bindex} $blist {
          #puts " $aresid $bresid"
          #puts " $aindex $bindex"
          if { $aresid == $bresid } {
            if { [expr $bindex-$aindex] == 1 } { 
              #puts "..."
              puts $tfp [format "CONECT%5d%5d" $k [expr $k+1]]
              #puts "???"
            }
          }
        }
        #$alist delete
        #$blist delete
      }
      #$templist delete
      close $tfp
      puts " file: \[ $tname \] closed"
      #$ttsel delete
      exec ./pdb2psf.py $tname
      set flag 1
    }
    $tempsel delete
    $tempnum delete
    if { $flag != 0 } {
      puts " Triggered, never happen again."
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