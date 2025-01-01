namespace eval prj {
  set prj_name @prj_name 
  set prj_root [file dirname [file normalize [info script]]]

  set lib_name $prj_name
  set work_dir "build"
  set synth_dir "synth"
  set bench_dir "bench"
  set source_dir "src"
  set sim_dir "sim"
  set lib_dir "lib"
  set sdc_dir "constraint"
  set formal_dir "formal"
  set doc_dir "documentation"

  set design(src) [glob $prj_root/$source_dir/*.vhd]
  set design(testbench) [glob $prj_root/$bench_dir/tb_*.vhd]
  set design(sdc) [glob $prj_root/$sdc_dir/*.pcf]
  set design(work) $prj_name
  set design(synth) $prj_root/$synth_dir
  set design(sim) $prj_root/$sim_dir
  set design(lib) [glob $prj_root/$lib_dir/*.vhd]
  set design(build) $prj_root/$work_dir
  set design(formal) $prj_root/$formal_dir
  set design(doc) $prj_root/$doc_dir
}
