!/usr/bin/env tclsh8.6

namespace eval prjInit {
  
  variable synth_targets {
    "ice40"
    "gatemate"
    "artix-7"
    "spartan-7"
    "virtex-7"
  }

  variable langs {
    "vhdl"
    "verilog"
    "systemverilog"
  }

  set project_file "prj.tcl"
  if {[file exists [pwd]/.$project_file] == 0} {
    if {$argc < 1 && $argc > 2} {
      error "invalid number of arguments given! Need at max two!"
      puts  "prjInit <project_name> \[optional\] <lang>"
      exit
    }
    set prj_name [lindex $argv 0]
    if {$argc == 2} {
      foreach {$lang} $langs {
        if {[string compare ?-nocase? ?-length int? $lang [lindex $argv 1]]} {
          set prj_lang $lang
	  break
	} else {
	  set prj_lang "vhdl"
	}
      }
    } else {
      set prj_lang "vhdl"
    }
    set vsim_file vsimCompile.tcl
    if {[file exists [pwd]/$vsim_file] == 0} {
      file copy $::env(HOME)/Templates/$vsim_file [pwd]/$vsim_file
    }
    file copy $::env(HOME)/Templates/$project_file [pwd]/.$project_file
    exec sed -i "s/@prj_name */$prj_name/g" [pwd]/.$project_file
    exec sed -i "s/@prj_lang */$prj_lang/g" [pwd]/.$project_file
  } else {
    puts "project file already exists, nothing to be done"
  }	  
}
