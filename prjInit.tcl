#!/usr/bin/env tclsh8.6

namespace eval prjInit {
  set project_file "prj.tcl"
  if {[file exists [pwd]/.$project_file] == 0} {
    if {$argc != 1} {
      error "invalid number of arguments given! Need only one!"
      exit
    }
    set prj_name [lindex $argv 0]
    set vsim_file vsimCompile.tcl
    if {[file exists [pwd]/$vsim_file] == 0} {
      file copy $::env(HOME)/Templates/$vsim_file [pwd]/$vsim_file
    }
    file copy $::env(HOME)/Templates/$project_file [pwd]/.$project_file
    exec sed -i "s/@prj_name */$prj_name/g" [pwd]/.$project_file
  } else {
    puts "project file already exists, nothing to be done"
  }
  # generate folder structure 
  file mkdir $prj::source_dir
  file attributes $prj::source_dir -owner system
  file mkdir $prj::bench_dir
  file attributes $pjr::bench_dir -owner system
  file mkdir $prj::lib_dir
  file attributes $pjr::lib_dir -owner system
  file mkdir $prj::formal_dir
  file attributes $prj::formal_dir -owner system
  file mkdir $prj::doc_dir
  file attributes $prj::doc_dir -owner system
}
