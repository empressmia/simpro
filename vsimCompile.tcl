set prj_file ../.prj.tcl
set wave_file ../waves.tcl
set wave_radices_file ../wave_radices.tcl

if {[file exists $prj_file] == 1} {
  source $prj_file 
  parray prj::design
} else {
  error "Project config file does not exist!"
}

set design_library [list {*}$prj::design(lib) {*}$prj::design(src) {*}$prj::design(testbench)]

set top_level              $prj::design(work).tb_$prj::prj_name

if {[file exists $wave_file]} {
  source $wave_file
  set wave_patterns [lrange $signal_list 0 end] 
} else {
  puts "wave pattern file does not exist!"
  set wave_patterns {
                           /tb
  }
}

if {[file exists $wave_radices_file]} {
  source $wave_radices_file
  set wave_radices [lrange $radices 0 end]
} else {
  puts "wave radices file does not exist!"
  set wave_radices {
                           hexadecimal {TB} 
  }
}

#
# the following is taken from doulos modelsim script
# https://www.doulos.com/knowhow/tcltk/example-tcl-and-tcltk-scripts-for-eda/modelsim-compile-script/
#
proc r  {} {uplevel #0 source $::prj::prj_root/vsimCompile.tcl}
proc rr {} {global last_compile_time
            set last_compile_time 0
            r                            }
proc q  {} {quit -force                  }

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

# Prefer a fixed point font for the transcript
set PrefMain(font) {Courier 10 roman normal}

# Compile out of date files
set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}
vlib $prj::design(build)
vmap $prj::prj_name $prj::design(build)
foreach file $design_library {
  puts "analyzing $file"
  if { $last_compile_time < [file mtime $file] } {
     if [regexp {.vhdl?$} $file] {
         vcom -quiet -64 -work $prj::prj_name -2008 $file
     } else {
       vlog -quiet -64 -work $prj::prj_name -sv09compat $file
     }
     set last_compile_time 0
   }
}
set last_compile_time $time_now

# Load the simulation
eval vsim $top_level

# If waves are required
if [llength $wave_patterns] {
  noview wave
  foreach pattern $wave_patterns {
    add wave $pattern
  }
  configure wave -signalnamewidth 1
  foreach {radix signals} $wave_radices {
    foreach signal $signals {
      catch {property wave -radix $radix $signal}
    }
  }
}

# Run the simulation
run -all

# If waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  Script commands are:

  r = Recompile changed and dependent files
 rr = Recompile everything
  q = Quit without confirmation
}

# How long since project began?
if {[file isfile start_time.txt] == 0} {
  set f [open start_time.txt w]
  puts $f "Start time was [clock seconds]"
  close $f
} else {
  set f [open start_time.txt r]
  set line [gets $f]
  close $f
  regexp {\d+} $line start_time
  set total_time [expr ([clock seconds]-$start_time)/60]
  puts "Project time is $total_time minutes"
}

puts {
  ModelSim general compile script version 1.2
  Copyright (c) Doulos June 2017, SD
}
