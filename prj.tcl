namespace eval prj {
  set prj_name @prj_name 
  set prj_root [file dirname [file normalize [info script]]]

  set lib_name $prj_name
  set work_dir [pwd]/build
  set synth_dir [pwd]/synth
  set bench_dir [pwd]/bench
  set source_dir [pwd]/src
  set sim_dir [pwd]/sim
  set lib_dir [pwd]/lib
  set sdc_dir [pwd]/constraint
  set formal_dir [pwd]/formal
  set doc_dir [pwd]/documentation

  set design(src) [glob -nocomplain -dir $source_dir/*.vhd]
  set design(testbench) [glob -nocomplain -dir $bench_dir/tb_*.vhd]
  set design(sdc) [glob -nocomplain -dir $sdc_dir/*.sdc]
  set design(pcf) [glob -nocomplain -dir $sdc_dir/*.pcf]
  set design(formal) [glob -nocomplain -dir $formal_dir/*.sby]
  set design(work) $prj_name
  set design(lib) [glob -nocomplain -dir $lib_dir/*.vhd]

# set vhdl standard, default is vhdl-2008
#  set vhdl-std 08
}
