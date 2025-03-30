set wave_file ../bench/waves.tcl
set wave_radices_file ../bench/wave_radices.tcl

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

# If waves are required
if [llength $wave_patterns] {
  noview wave
  foreach pattern $wave_patterns {
    add wave $pattern
  }
  configure wave -signalnamewidth 2
  foreach {radix signals} $wave_radices {
    foreach signal $signals {
      catch {property wave -radix $radix $signal}
    }
  }
}

set PrefMain(font) {Courier 10 roman normal}
run -all
