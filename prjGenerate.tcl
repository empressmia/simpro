#!/usr/bin/env tclsh8.6

namespace eval prjGenerate {
  set prj_file [pwd]/.prj.tcl
  if {[file exists $prj_file] == 1} {
    source $prj_file 
    parray prj::design
  } else {
    error "Project config file does not exist!"
  }

set ghdl_options [list --std=08 --workdir=$prj::prj_root/build --work=$prj::design(work)]
set yosys_synth_options [list synth_ice40 -json $prj::prj_root/build/build.json]

set analyse_src [list ghdl -a]
lappend analyse_src $ghdl_options 
lappend analyse_src $prj::design(lib)
lappend analyse_src $prj::design(src)

set analyse_bench [list ghdl -a]
lappend analyse_bench [list --std=08 --workdir=$prj::prj_root/build]
lappend analyse_bench $prj::design(testbench)

set elaborate_synth [list ghdl -e] 
lappend elaborate_synth $ghdl_options 
lappend elaborate_synth ${prj::prj_name}_top

set elaborate_bench [list ghdl -e]
lappend elaborate_bench $ghdl_options
lappend elaborate_bench tb_$prj::prj_name

set filename "Makefile"
set fileHandle [open $filename "w"]

puts $fileHandle "clean:"
puts $fileHandle "\t rm -rf $prj::design(synth)"
puts $fileHandle "\t rm -rf $prj::design(build)\n"

puts $fileHandle "analyse_src:"
puts $fileHandle "\t mkdir -p $prj::design(build)"
puts $fileHandle "\t [join $analyse_src]\n"

puts $fileHandle "elaborate_synth:"
puts $fileHandle "\t [join $elaborate_synth]\n"

puts $fileHandle "analyse_bench:"
puts $fileHandle "\t make analyse_src"
puts $fileHandle "\t [join $analyse_bench]\n"

puts $fileHandle "elaborate_bench:"
puts $fileHandle "\t [join $elaborate_bench]\n"

puts $fileHandle "sim:"
puts $fileHandle "\t make analyse_bench"
puts $fileHandle "\t make elaborate_bench"
puts $fileHandle "\t ghdl -r $ghdl_options tb_$prj::prj_name"

puts $fileHandle "vsim:"
puts $fileHandle "\t cd build && vsim -do ../vsimCompile.tcl"

puts $fileHandle "synthesis_single:"
puts $fileHandle "\t mkdir -p $prj::design(synth)"
puts $fileHandle "\t yosys -m ghdl -p\"ghdl $ghdl_options ${prj::prj_name}_top; \
[join $yosys_synth_options]\"\n"

puts $fileHandle "synthesis:"
puts $fileHandle "\t make analyse_src"
puts $fileHandle "\t make elaborate_synth"
puts $fileHandle "\t make synthesis_single\n"

puts $fileHandle "pnr:"
puts $fileHandle "\t nextpnr-ice40 --hx1k --package tq144 --pcf-allow-unconstrained --json $prj::prj_root/build/build.json --pcf $prj::design(sdc) --asc $prj::design(synth)/$prj::prj_name.asc\n"

puts $fileHandle "pack:"
puts $fileHandle "\t icepack $prj::design(synth)/$prj::prj_name.asc $prj::design(synth)/$prj::prj_name.bin\n"

puts $fileHandle "prog:"
puts $fileHandle "\t iceprog $prj::design(synth)/prj_name.bin\n"

puts $fileHandle "all_synthesis:"
puts $fileHandle "\t make synthesis"
puts $fileHandle "\t make pnr"
puts $fileHandle "\t make pack\n"

puts $fileHandle "all:"
puts $fileHandle "\t make clean"
puts $fileHandle "\t make all_synthesis\n"

puts $fileHandle "timing:"
#puts $fileHandle "\t if \[ ! -e $design(synth)/$prj_name.asc \] then; echo \"run synthesis and pnr first!\"; exit 1; fi"
puts $fileHandle "\t icetime -p $prj::design(sdc) -P tq144 -d hx1k -mt $prj::design(synth)/$prj::prj_name.asc\n"

puts $fileHandle ".PHONY : clean analyse_src elaborate_synth synthesis single synthesis pnr pack prog all_synthesis all timing"

close $fileHandle
}
