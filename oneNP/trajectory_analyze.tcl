
# The analyze command defined in this script lets you analyze DCD files on
# the fly.  To use it, source this file, then call analyze with the name
# of the script you want to be called each frame.  The script will be called
# with the current frame as its only argument.



proc analyze_callback { name1 name2 op } {
  global analyze_proc

  upvar $name1 arr
  set frame $arr($name2)
  uplevel #0 $analyze_proc $frame
}

proc analyze { script } {
  global analyze_proc

  set analyze_proc $script
  uplevel #0 trace variable vmd_frame w analyze_callback
}

####################
set test 0

if { $test == 1 } {
# this is a simple example script that shows how to use the analyze command
# to analyze DCD files on the fly.  I create a global data structure called
# mydata to hold the results for the whole trajectory.  The proc my_analysis
# is called each time a frame is loaded and appends data for that frame to
# mydata.

  #source trajectory_analyze.tcl

  set mydata {}

  proc my_analysis { frame } {
    global mydata
    puts "The current frame is $frame"
    set sel [atomselect top "within 3 of resid 5"]
    lappend mydata [measure center $sel]
  }
   
  analyze my_analysis

  cd /home/justin/vmd/vmd/proteins
  mol load psf alanin.psf dcd alanin.dcd
}
