
########## Tcl recorder starts at 11/26/06 23:30:46 ##########

set version "6.0"
set proj_dir "P:/studienarbeit/isplever/07_banpass"
cd $proj_dir

# Get directory paths
set pver $version
regsub -all {\.} $pver {_} pver
set lscfile "lsc_"
append lscfile $pver ".ini"
set lsvini_dir [lindex [array get env LSC_INI_PATH] 1]
set lsvini_path [file join $lsvini_dir $lscfile]
if {[catch {set fid [open $lsvini_path]} msg]} {
	 puts "File Open Error: $lsvini_path"
	 return false
} else {set data [read $fid]; close $fid }
foreach line [split $data '\n'] { 
	set lline [string tolower $line]
	set lline [string trim $lline]
	if {[string compare $lline "\[paths\]"] == 0} { set path 1; continue}
	if {$path && [regexp {^\[} $lline]} {set path 0; break}
	if {$path && [regexp {^bin} $lline]} {set cpld_bin $line; continue}
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line; continue}
	if {$path && [regexp {^fpgabinpath} $lline]} {set fpga_bin $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]
set fpga_bin [string range $fpga_bin [expr [string first "=" $fpga_bin]+1] end]
regsub -all "\"" $fpga_bin "" fpga_bin
set fpga_bin [file join $fpga_bin]

if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$fpga_bin;$env(PATH)" } }

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/toplevel.vhd\" -o \"toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_transmitter.vhd\" -o \"i2s_transmitter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/segment_decoder.vhd\" -o \"segment_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen.vhd\" -o \"clockgen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_receiver.vhd\" -o \"i2s_receiver.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/chatter_suppress.vhd\" -o \"chatter_suppress.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/bargraph_decoder.vhd\" -o \"bargraph_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/reset_gen.vhd\" -o \"reset_gen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen_main.vhd\" -o \"clockgen_main.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:30:46 ###########


########## Tcl recorder starts at 11/26/06 23:31:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:31:20 ###########


########## Tcl recorder starts at 11/26/06 23:39:23 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:39:23 ###########


########## Tcl recorder starts at 11/26/06 23:40:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:40:25 ###########


########## Tcl recorder starts at 11/26/06 23:40:31 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:40:31 ###########


########## Tcl recorder starts at 11/26/06 23:41:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:41:18 ###########


########## Tcl recorder starts at 11/26/06 23:41:25 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:41:25 ###########


########## Tcl recorder starts at 11/26/06 23:42:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:42:21 ###########


########## Tcl recorder starts at 11/26/06 23:42:26 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:42:26 ###########


########## Tcl recorder starts at 11/26/06 23:43:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:43:11 ###########


########## Tcl recorder starts at 11/26/06 23:43:17 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:43:17 ###########


########## Tcl recorder starts at 11/26/06 23:43:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:43:48 ###########


########## Tcl recorder starts at 11/26/06 23:43:53 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:43:54 ###########


########## Tcl recorder starts at 11/26/06 23:44:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:44:28 ###########


########## Tcl recorder starts at 11/26/06 23:44:34 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:44:34 ###########


########## Tcl recorder starts at 11/26/06 23:47:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:47:56 ###########


########## Tcl recorder starts at 11/26/06 23:48:02 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:48:02 ###########


########## Tcl recorder starts at 11/26/06 23:50:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:50:01 ###########


########## Tcl recorder starts at 11/26/06 23:50:07 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:50:07 ###########


########## Tcl recorder starts at 11/26/06 23:51:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:51:03 ###########


########## Tcl recorder starts at 11/26/06 23:51:08 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:51:08 ###########


########## Tcl recorder starts at 11/26/06 23:54:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:54:49 ###########


########## Tcl recorder starts at 11/26/06 23:54:54 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:54:54 ###########


########## Tcl recorder starts at 11/26/06 23:55:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:55:56 ###########


########## Tcl recorder starts at 11/26/06 23:56:03 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:56:03 ###########


########## Tcl recorder starts at 11/26/06 23:59:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 23:59:16 ###########


########## Tcl recorder starts at 11/26/06 23:59:22 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/26/06 23:59:22 ###########


########## Tcl recorder starts at 11/27/06 00:07:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 00:07:22 ###########


########## Tcl recorder starts at 11/27/06 00:07:28 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 00:07:28 ###########


########## Tcl recorder starts at 11/27/06 01:57:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 01:57:58 ###########


########## Tcl recorder starts at 11/27/06 01:58:06 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 01:58:06 ###########


########## Tcl recorder starts at 11/27/06 01:59:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../packages/my_funcs.vhd\" -o \"my_funcs.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 01:59:07 ###########


########## Tcl recorder starts at 11/27/06 02:00:01 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:00:01 ###########


########## Tcl recorder starts at 11/27/06 02:00:53 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:00:54 ###########


########## Tcl recorder starts at 11/27/06 02:07:31 ##########

# Commands to make the Process: 
# Build Database
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:07:31 ###########


########## Tcl recorder starts at 11/27/06 02:08:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../packages/my_funcs.vhd\" -o \"my_funcs.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:08:18 ###########


########## Tcl recorder starts at 11/27/06 02:09:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen.vhd\" -o \"clockgen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"my_funcs.vhd\" -o \"my_funcs.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/reset_gen.vhd\" -o \"reset_gen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen_main.vhd\" -o \"clockgen_main.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/toplevel.vhd\" -o \"toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_transmitter.vhd\" -o \"i2s_transmitter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/segment_decoder.vhd\" -o \"segment_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_receiver.vhd\" -o \"i2s_receiver.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/chatter_suppress.vhd\" -o \"chatter_suppress.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/bargraph_decoder.vhd\" -o \"bargraph_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:09:14 ###########


########## Tcl recorder starts at 11/27/06 02:10:11 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:10:11 ###########


########## Tcl recorder starts at 11/27/06 02:15:10 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen.vhd\" -o \"clockgen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../packages/my_funcs.vhd\" -o \"my_funcs.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/reset_gen.vhd\" -o \"reset_gen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen_main.vhd\" -o \"clockgen_main.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/toplevel.vhd\" -o \"toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_transmitter.vhd\" -o \"i2s_transmitter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/segment_decoder.vhd\" -o \"segment_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_receiver.vhd\" -o \"i2s_receiver.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/chatter_suppress.vhd\" -o \"chatter_suppress.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/bargraph_decoder.vhd\" -o \"bargraph_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:15:10 ###########


########## Tcl recorder starts at 11/27/06 02:16:00 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:16:00 ###########


########## Tcl recorder starts at 11/27/06 02:17:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:17:47 ###########


########## Tcl recorder starts at 11/27/06 02:17:53 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:17:53 ###########


########## Tcl recorder starts at 11/27/06 02:27:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:27:42 ###########


########## Tcl recorder starts at 11/27/06 02:27:51 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:27:51 ###########


########## Tcl recorder starts at 11/27/06 02:31:33 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:31:33 ###########


########## Tcl recorder starts at 11/27/06 02:36:42 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:36:42 ###########


########## Tcl recorder starts at 11/27/06 02:38:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:38:34 ###########


########## Tcl recorder starts at 11/27/06 02:38:45 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:38:45 ###########


########## Tcl recorder starts at 11/27/06 02:42:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:42:22 ###########


########## Tcl recorder starts at 11/27/06 02:42:31 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:42:31 ###########


########## Tcl recorder starts at 11/27/06 02:43:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"bandpass.vhd\" -o \"bandpass.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:43:12 ###########


########## Tcl recorder starts at 11/27/06 02:43:18 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open bandpass.cmd w} rspFile] {
	puts stderr "Cannot create response file bandpass.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: bandpass
working_path: \"$proj_dir\"
module: bandpass
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd
output_file_name: bandpass
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e bandpass -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass.cmd

########## Tcl recorder end at 11/27/06 02:43:18 ###########


########## Tcl recorder starts at 11/27/06 02:46:19 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"bandpass_filter.ngd\" -o \"bandpass_filter_map.ncd\" -mp \"bandpass_filter.mrp\" \"bandpass_filter.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.mt
-to bandpass_filter.tw1
-o bandpass_filter.tcm
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"bandpass_filter.cmm\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.p2t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p2t: $rspFile"
} else {
	puts $rspFile "-w
-i 6
-l 5
-n 1
-t 1
-s 1
-c 0
-e 0
-exp parplcinlimit=0
-exp parplcinneighborsize=1
-exp parpathbased=off
-exp parhold=off
"
	close $rspFile
}
if [catch {open bandpass_filter.p3t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log bandpass_filter.log
-o bandpass_filter_mp.par
-pr bandpass_filter.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p bandpass_filter.p2t -f \"bandpass_filter.p3t\" \"bandpass_filter_map.ncd\" \"bandpass_filter.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.pt
-to bandpass_filter.twr
-o bandpass_filter.tcp
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"bandpass_filter.cmp\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.t2b w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.t2b: $rspFile"
} else {
	puts $rspFile "-g CfgMode:Disable
-g readback:sram
-g ramcfg:reset
-g synsrc:no
-g pllset:none
-g es:no
"
	close $rspFile
}
if [runCmd "\"$fpga_bin/bitgen\" -f \"bandpass_filter.t2b\" -w \"bandpass_filter.ncd\" \"bandpass_filter.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:46:19 ###########


########## Tcl recorder starts at 11/27/06 02:47:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:47:21 ###########


########## Tcl recorder starts at 11/27/06 02:47:32 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"bandpass_filter.ngd\" -o \"bandpass_filter_map.ncd\" -mp \"bandpass_filter.mrp\" \"bandpass_filter.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.mt
-to bandpass_filter.tw1
-o bandpass_filter.tcm
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"bandpass_filter.cmm\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.p2t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p2t: $rspFile"
} else {
	puts $rspFile "-w
-i 6
-l 5
-n 1
-t 1
-s 1
-c 0
-e 0
-exp parplcinlimit=0
-exp parplcinneighborsize=1
-exp parpathbased=off
-exp parhold=off
"
	close $rspFile
}
if [catch {open bandpass_filter.p3t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log bandpass_filter.log
-o bandpass_filter_mp.par
-pr bandpass_filter.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p bandpass_filter.p2t -f \"bandpass_filter.p3t\" \"bandpass_filter_map.ncd\" \"bandpass_filter.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.pt
-to bandpass_filter.twr
-o bandpass_filter.tcp
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"bandpass_filter.cmp\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.t2b w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.t2b: $rspFile"
} else {
	puts $rspFile "-g CfgMode:Disable
-g readback:sram
-g ramcfg:reset
-g synsrc:no
-g pllset:none
-g es:no
"
	close $rspFile
}
if [runCmd "\"$fpga_bin/bitgen\" -f \"bandpass_filter.t2b\" -w \"bandpass_filter.ncd\" \"bandpass_filter.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:47:32 ###########


########## Tcl recorder starts at 11/27/06 02:48:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:48:06 ###########


########## Tcl recorder starts at 11/27/06 02:48:18 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"bandpass_filter.ngd\" -o \"bandpass_filter_map.ncd\" -mp \"bandpass_filter.mrp\" \"bandpass_filter.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.mt
-to bandpass_filter.tw1
-o bandpass_filter.tcm
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"bandpass_filter.cmm\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.p2t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p2t: $rspFile"
} else {
	puts $rspFile "-w
-i 6
-l 5
-n 1
-t 1
-s 1
-c 0
-e 0
-exp parplcinlimit=0
-exp parplcinneighborsize=1
-exp parpathbased=off
-exp parhold=off
"
	close $rspFile
}
if [catch {open bandpass_filter.p3t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log bandpass_filter.log
-o bandpass_filter_mp.par
-pr bandpass_filter.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p bandpass_filter.p2t -f \"bandpass_filter.p3t\" \"bandpass_filter_map.ncd\" \"bandpass_filter.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.pt
-to bandpass_filter.twr
-o bandpass_filter.tcp
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"bandpass_filter.cmp\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.t2b w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.t2b: $rspFile"
} else {
	puts $rspFile "-g CfgMode:Disable
-g readback:sram
-g ramcfg:reset
-g synsrc:no
-g pllset:none
-g es:no
"
	close $rspFile
}
if [runCmd "\"$fpga_bin/bitgen\" -f \"bandpass_filter.t2b\" -w \"bandpass_filter.ncd\" \"bandpass_filter.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:48:18 ###########


########## Tcl recorder starts at 11/27/06 02:48:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:48:48 ###########


########## Tcl recorder starts at 11/27/06 02:48:58 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"bandpass_filter.ngd\" -o \"bandpass_filter_map.ncd\" -mp \"bandpass_filter.mrp\" \"bandpass_filter.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.mt
-to bandpass_filter.tw1
-o bandpass_filter.tcm
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"bandpass_filter.cmm\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.p2t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p2t: $rspFile"
} else {
	puts $rspFile "-w
-i 6
-l 5
-n 1
-t 1
-s 1
-c 0
-e 0
-exp parplcinlimit=0
-exp parplcinneighborsize=1
-exp parpathbased=off
-exp parhold=off
"
	close $rspFile
}
if [catch {open bandpass_filter.p3t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log bandpass_filter.log
-o bandpass_filter_mp.par
-pr bandpass_filter.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p bandpass_filter.p2t -f \"bandpass_filter.p3t\" \"bandpass_filter_map.ncd\" \"bandpass_filter.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.pt
-to bandpass_filter.twr
-o bandpass_filter.tcp
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"bandpass_filter.cmp\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.t2b w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.t2b: $rspFile"
} else {
	puts $rspFile "-g CfgMode:Disable
-g readback:sram
-g ramcfg:reset
-g synsrc:no
-g pllset:none
-g es:no
"
	close $rspFile
}
if [runCmd "\"$fpga_bin/bitgen\" -f \"bandpass_filter.t2b\" -w \"bandpass_filter.ncd\" \"bandpass_filter.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:48:58 ###########


########## Tcl recorder starts at 11/27/06 02:56:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:56:00 ###########


########## Tcl recorder starts at 11/27/06 02:56:11 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"bandpass_filter.ngd\" -o \"bandpass_filter_map.ncd\" -mp \"bandpass_filter.mrp\" \"bandpass_filter.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.mt
-to bandpass_filter.tw1
-o bandpass_filter.tcm
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"bandpass_filter.cmm\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.p2t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p2t: $rspFile"
} else {
	puts $rspFile "-w
-i 6
-l 5
-n 1
-t 1
-s 1
-c 0
-e 0
-exp parplcinlimit=0
-exp parplcinneighborsize=1
-exp parpathbased=off
-exp parhold=off
"
	close $rspFile
}
if [catch {open bandpass_filter.p3t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log bandpass_filter.log
-o bandpass_filter_mp.par
-pr bandpass_filter.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p bandpass_filter.p2t -f \"bandpass_filter.p3t\" \"bandpass_filter_map.ncd\" \"bandpass_filter.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.pt
-to bandpass_filter.twr
-o bandpass_filter.tcp
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"bandpass_filter.cmp\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.t2b w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.t2b: $rspFile"
} else {
	puts $rspFile "-g CfgMode:Disable
-g readback:sram
-g ramcfg:reset
-g synsrc:no
-g pllset:none
-g es:no
"
	close $rspFile
}
if [runCmd "\"$fpga_bin/bitgen\" -f \"bandpass_filter.t2b\" -w \"bandpass_filter.ncd\" \"bandpass_filter.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:56:11 ###########


########## Tcl recorder starts at 11/27/06 02:56:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"stud_toplevel.vhd\" -o \"stud_toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:56:52 ###########


########## Tcl recorder starts at 11/27/06 02:57:03 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/my_funcs.vhd bandpass.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
output_file_name: toplevel
suffix_name: edi
write_prf: false
frequency:  200
fanout_limit:  100
disable_io_insertion: false
force_gsr: auto
package: fpbga484
speed_grade: 3
symbolic_fsm_compiler: true
num_critical_paths:   3
auto_constrain_io: true
num_startend_points:   0
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/synpwrap\" -e toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete toplevel.cmd
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"bandpass_filter.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"bandpass_filter.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"bandpass_filter.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"bandpass_filter.ngd\" -o \"bandpass_filter_map.ncd\" -mp \"bandpass_filter.mrp\" \"bandpass_filter.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.mt
-to bandpass_filter.tw1
-o bandpass_filter.tcm
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"bandpass_filter.cmm\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.p2t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p2t: $rspFile"
} else {
	puts $rspFile "-w
-i 6
-l 5
-n 1
-t 1
-s 1
-c 0
-e 0
-exp parplcinlimit=0
-exp parplcinneighborsize=1
-exp parpathbased=off
-exp parhold=off
"
	close $rspFile
}
if [catch {open bandpass_filter.p3t w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log bandpass_filter.log
-o bandpass_filter_mp.par
-pr bandpass_filter.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p bandpass_filter.p2t -f \"bandpass_filter.p3t\" \"bandpass_filter_map.ncd\" \"bandpass_filter.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open bandpass_filter.cm2 w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.cm2: $rspFile"
} else {
	puts $rspFile "-t bandpass_filter.pt
-to bandpass_filter.twr
-o bandpass_filter.tcp
-log bandpass_filter.log
-pr bandpass_filter.prf
-rpt bandpass_filter.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"bandpass_filter.cmp\" -f \"bandpass_filter.cm2\" -arch ep5g00p \"bandpass_filter.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete bandpass_filter.cm2
if [catch {open bandpass_filter.t2b w} rspFile] {
	puts stderr "Cannot create response file bandpass_filter.t2b: $rspFile"
} else {
	puts $rspFile "-g CfgMode:Disable
-g readback:sram
-g ramcfg:reset
-g synsrc:no
-g pllset:none
-g es:no
"
	close $rspFile
}
if [runCmd "\"$fpga_bin/bitgen\" -f \"bandpass_filter.t2b\" -w \"bandpass_filter.ncd\" \"bandpass_filter.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/27/06 02:57:03 ###########

