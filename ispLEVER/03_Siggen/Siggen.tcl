
########## Tcl recorder starts at 11/16/06 01:46:49 ##########

set version "6.1"
set proj_dir "P:/Studienarbeit/ispLEVER/03_Siggen"
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
if [runCmd "\"$cpld_bin/vhd2jhd\" \"toplevel.vhd\" -o \"toplevel.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/16/06 01:46:49 ###########


########## Tcl recorder starts at 11/16/06 01:47:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/chatter_suppress.vhd\" -o \"chatter_suppress.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/lpc2jhd\" ../common_files/clockgen.lpc -family ep5g00p"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/lpc2jhd\" ../common_files/clockgen_main.lpc -family ep5g00p"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/16/06 01:47:13 ###########


########## Tcl recorder starts at 11/25/06 17:54:13 ##########

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

########## Tcl recorder end at 11/25/06 17:54:13 ###########


########## Tcl recorder starts at 11/25/06 17:54:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 17:54:39 ###########


########## Tcl recorder starts at 11/25/06 17:54:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 17:54:57 ###########


########## Tcl recorder starts at 11/25/06 17:55:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 17:55:41 ###########


########## Tcl recorder starts at 11/25/06 17:57:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 17:57:18 ###########


########## Tcl recorder starts at 11/25/06 17:57:21 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 17:57:22 ###########


########## Tcl recorder starts at 11/25/06 17:58:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 17:58:01 ###########


########## Tcl recorder starts at 11/25/06 17:58:05 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 17:58:05 ###########


########## Tcl recorder starts at 11/25/06 18:03:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:03:16 ###########


########## Tcl recorder starts at 11/25/06 18:03:19 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:03:19 ###########


########## Tcl recorder starts at 11/25/06 18:04:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:04:32 ###########


########## Tcl recorder starts at 11/25/06 18:04:35 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:04:35 ###########


########## Tcl recorder starts at 11/25/06 18:05:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:05:39 ###########


########## Tcl recorder starts at 11/25/06 18:05:42 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:05:42 ###########


########## Tcl recorder starts at 11/25/06 18:07:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:07:14 ###########


########## Tcl recorder starts at 11/25/06 18:07:16 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:07:16 ###########


########## Tcl recorder starts at 11/25/06 18:09:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:09:43 ###########


########## Tcl recorder starts at 11/25/06 18:09:45 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:09:45 ###########


########## Tcl recorder starts at 11/25/06 18:11:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:11:52 ###########


########## Tcl recorder starts at 11/25/06 18:11:54 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:11:54 ###########


########## Tcl recorder starts at 11/25/06 18:15:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:15:24 ###########


########## Tcl recorder starts at 11/25/06 18:15:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:15:27 ###########


########## Tcl recorder starts at 11/25/06 18:37:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:37:35 ###########


########## Tcl recorder starts at 11/25/06 18:37:39 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:37:39 ###########


########## Tcl recorder starts at 11/25/06 18:45:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:45:39 ###########


########## Tcl recorder starts at 11/25/06 18:45:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:45:41 ###########


########## Tcl recorder starts at 11/25/06 18:47:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:47:23 ###########


########## Tcl recorder starts at 11/25/06 18:47:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:47:27 ###########


########## Tcl recorder starts at 11/25/06 18:50:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:50:13 ###########


########## Tcl recorder starts at 11/25/06 18:50:16 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:50:16 ###########


########## Tcl recorder starts at 11/25/06 18:51:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:51:47 ###########


########## Tcl recorder starts at 11/25/06 18:51:49 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:51:49 ###########


########## Tcl recorder starts at 11/25/06 18:52:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:52:41 ###########


########## Tcl recorder starts at 11/25/06 18:52:44 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:52:44 ###########


########## Tcl recorder starts at 11/25/06 18:56:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:56:50 ###########


########## Tcl recorder starts at 11/25/06 18:56:54 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:56:54 ###########


########## Tcl recorder starts at 11/25/06 18:58:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:58:03 ###########


########## Tcl recorder starts at 11/25/06 18:58:08 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 18:58:08 ###########


########## Tcl recorder starts at 11/25/06 18:59:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 18:59:57 ###########


########## Tcl recorder starts at 11/25/06 19:00:02 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:00:02 ###########


########## Tcl recorder starts at 11/25/06 19:00:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:00:43 ###########


########## Tcl recorder starts at 11/25/06 19:00:48 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:00:48 ###########


########## Tcl recorder starts at 11/25/06 19:33:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:33:55 ###########


########## Tcl recorder starts at 11/25/06 19:34:00 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:34:00 ###########


########## Tcl recorder starts at 11/25/06 19:34:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:34:49 ###########


########## Tcl recorder starts at 11/25/06 19:34:54 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:34:54 ###########


########## Tcl recorder starts at 11/25/06 19:36:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:36:20 ###########


########## Tcl recorder starts at 11/25/06 19:36:25 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:36:25 ###########


########## Tcl recorder starts at 11/25/06 19:37:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:37:37 ###########


########## Tcl recorder starts at 11/25/06 19:37:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:37:41 ###########


########## Tcl recorder starts at 11/25/06 19:41:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:41:37 ###########


########## Tcl recorder starts at 11/25/06 19:41:45 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:41:45 ###########


########## Tcl recorder starts at 11/25/06 19:43:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:43:04 ###########


########## Tcl recorder starts at 11/25/06 19:43:09 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:43:09 ###########


########## Tcl recorder starts at 11/25/06 19:44:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:44:52 ###########


########## Tcl recorder starts at 11/25/06 19:44:57 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:44:57 ###########


########## Tcl recorder starts at 11/25/06 19:45:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:45:45 ###########


########## Tcl recorder starts at 11/25/06 19:45:50 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:45:50 ###########


########## Tcl recorder starts at 11/25/06 19:48:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:48:34 ###########


########## Tcl recorder starts at 11/25/06 19:48:38 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:48:38 ###########


########## Tcl recorder starts at 11/25/06 19:50:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:50:46 ###########


########## Tcl recorder starts at 11/25/06 19:50:51 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:50:51 ###########


########## Tcl recorder starts at 11/25/06 19:57:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 19:57:22 ###########


########## Tcl recorder starts at 11/25/06 19:57:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 19:57:27 ###########


########## Tcl recorder starts at 11/25/06 20:01:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:01:17 ###########


########## Tcl recorder starts at 11/25/06 20:01:22 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 20:01:22 ###########


########## Tcl recorder starts at 11/25/06 20:02:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:02:20 ###########


########## Tcl recorder starts at 11/25/06 20:02:25 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_lut.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_lut.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_lut
working_path: \"$proj_dir\"
module: cordic_lut
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd
output_file_name: cordic_lut
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_lut -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_lut.cmd

########## Tcl recorder end at 11/25/06 20:02:25 ###########


########## Tcl recorder starts at 11/25/06 20:11:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:11:59 ###########


########## Tcl recorder starts at 11/25/06 20:12:07 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:12:07 ###########


########## Tcl recorder starts at 11/25/06 20:12:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:12:48 ###########


########## Tcl recorder starts at 11/25/06 20:12:55 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:12:55 ###########


########## Tcl recorder starts at 11/25/06 20:31:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:31:28 ###########


########## Tcl recorder starts at 11/25/06 20:31:37 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:31:37 ###########


########## Tcl recorder starts at 11/25/06 20:32:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:32:47 ###########


########## Tcl recorder starts at 11/25/06 20:32:54 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:32:54 ###########


########## Tcl recorder starts at 11/25/06 20:33:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../packages/cordic_pkg.vhd\" -o \"cordic_pkg.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:33:57 ###########


########## Tcl recorder starts at 11/25/06 20:34:43 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/cordic_pkg.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:34:43 ###########


########## Tcl recorder starts at 11/25/06 20:37:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:37:03 ###########


########## Tcl recorder starts at 11/25/06 20:37:11 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/cordic_pkg.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:37:12 ###########


########## Tcl recorder starts at 11/25/06 20:38:46 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/cordic_pkg.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:38:47 ###########


########## Tcl recorder starts at 11/25/06 20:39:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:39:14 ###########


########## Tcl recorder starts at 11/25/06 20:39:22 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../packages/cordic_pkg.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:39:23 ###########


########## Tcl recorder starts at 11/25/06 20:42:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:42:47 ###########


########## Tcl recorder starts at 11/25/06 20:44:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
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
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:44:17 ###########


########## Tcl recorder starts at 11/25/06 20:44:26 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:44:26 ###########


########## Tcl recorder starts at 11/25/06 20:45:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:45:48 ###########


########## Tcl recorder starts at 11/25/06 20:45:53 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:45:53 ###########


########## Tcl recorder starts at 11/25/06 20:47:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:47:29 ###########


########## Tcl recorder starts at 11/25/06 20:47:34 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:47:34 ###########


########## Tcl recorder starts at 11/25/06 20:49:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:49:16 ###########


########## Tcl recorder starts at 11/25/06 20:49:21 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:49:21 ###########


########## Tcl recorder starts at 11/25/06 20:57:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:57:32 ###########


########## Tcl recorder starts at 11/25/06 20:57:38 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:57:38 ###########


########## Tcl recorder starts at 11/25/06 20:58:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:58:50 ###########


########## Tcl recorder starts at 11/25/06 20:58:55 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:58:55 ###########


########## Tcl recorder starts at 11/25/06 20:59:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 20:59:52 ###########


########## Tcl recorder starts at 11/25/06 20:59:58 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 20:59:58 ###########


########## Tcl recorder starts at 11/25/06 21:00:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 21:00:48 ###########


########## Tcl recorder starts at 11/25/06 21:00:53 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 21:00:53 ###########


########## Tcl recorder starts at 11/25/06 21:03:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 21:03:36 ###########


########## Tcl recorder starts at 11/25/06 21:03:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 21:03:41 ###########


########## Tcl recorder starts at 11/25/06 21:09:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 21:09:35 ###########


########## Tcl recorder starts at 11/25/06 21:09:38 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/25/06 21:09:38 ###########


########## Tcl recorder starts at 11/25/06 22:12:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 22:12:31 ###########


########## Tcl recorder starts at 11/25/06 22:12:48 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 22:12:48 ###########


########## Tcl recorder starts at 11/25/06 22:13:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 22:13:40 ###########


########## Tcl recorder starts at 11/25/06 22:13:43 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 22:13:43 ###########


########## Tcl recorder starts at 11/25/06 22:31:30 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
suffix_name: edi
write_prf: false
frequency:  50
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 22:31:30 ###########


########## Tcl recorder starts at 11/25/06 22:35:45 ##########

# Commands to make the Process: 
# Generate Schematic Symbol
if [runCmd "\"$cpld_bin/naf2sym\" barrel_shifter"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 22:35:45 ###########


########## Tcl recorder starts at 11/25/06 22:37:35 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 22:37:35 ###########


########## Tcl recorder starts at 11/25/06 22:41:03 ##########

# Commands to make the Process: 
# Place & Route Design
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"barrel_shifter.edi\" \"barrel_shifter.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"siggen.tcy\" -w \"barrel_shifter.ngo\" -m \"barrel_shifter.ngo\" \"siggen.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"barrel_shifter.ngo\" \"siggen.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"siggen.ngd\" -o \"siggen_map.ncd\" -mp \"siggen.mrp\" \"siggen.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open siggen.cm2 w} rspFile] {
	puts stderr "Cannot create response file siggen.cm2: $rspFile"
} else {
	puts $rspFile "-t siggen.mt
-to siggen.tw1
-o siggen.tcm
-log siggen.log
-pr siggen.prf
-rpt siggen.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"siggen.cmm\" -f \"siggen.cm2\" -arch ep5g00p \"siggen_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete siggen.cm2
if [catch {open siggen.p2t w} rspFile] {
	puts stderr "Cannot create response file siggen.p2t: $rspFile"
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
if [catch {open siggen.p3t w} rspFile] {
	puts stderr "Cannot create response file siggen.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log siggen.log
-o siggen_mp.par
-pr siggen.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p siggen.p2t -f \"siggen.p3t\" \"siggen_map.ncd\" \"siggen.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 22:41:03 ###########


########## Tcl recorder starts at 11/25/06 23:13:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:13:52 ###########


########## Tcl recorder starts at 11/25/06 23:14:00 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:14:00 ###########


########## Tcl recorder starts at 11/25/06 23:14:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:14:57 ###########


########## Tcl recorder starts at 11/25/06 23:15:04 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:15:04 ###########


########## Tcl recorder starts at 11/25/06 23:18:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:18:33 ###########


########## Tcl recorder starts at 11/25/06 23:18:36 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:18:36 ###########


########## Tcl recorder starts at 11/25/06 23:19:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:19:53 ###########


########## Tcl recorder starts at 11/25/06 23:19:56 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:19:56 ###########


########## Tcl recorder starts at 11/25/06 23:20:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:20:30 ###########


########## Tcl recorder starts at 11/25/06 23:20:32 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:20:32 ###########


########## Tcl recorder starts at 11/25/06 23:22:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:22:17 ###########


########## Tcl recorder starts at 11/25/06 23:22:21 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:22:21 ###########


########## Tcl recorder starts at 11/25/06 23:23:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:23:13 ###########


########## Tcl recorder starts at 11/25/06 23:23:16 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:23:16 ###########


########## Tcl recorder starts at 11/25/06 23:24:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:24:24 ###########


########## Tcl recorder starts at 11/25/06 23:24:28 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:24:28 ###########


########## Tcl recorder starts at 11/25/06 23:29:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:29:42 ###########


########## Tcl recorder starts at 11/25/06 23:29:45 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:29:45 ###########


########## Tcl recorder starts at 11/25/06 23:31:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:31:13 ###########


########## Tcl recorder starts at 11/25/06 23:31:16 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:31:17 ###########


########## Tcl recorder starts at 11/25/06 23:32:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:32:27 ###########


########## Tcl recorder starts at 11/25/06 23:32:31 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:32:31 ###########


########## Tcl recorder starts at 11/25/06 23:33:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:33:49 ###########


########## Tcl recorder starts at 11/25/06 23:33:52 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:33:52 ###########


########## Tcl recorder starts at 11/25/06 23:34:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:34:41 ###########


########## Tcl recorder starts at 11/25/06 23:34:44 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:34:44 ###########


########## Tcl recorder starts at 11/25/06 23:39:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:39:20 ###########


########## Tcl recorder starts at 11/25/06 23:39:23 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:39:23 ###########


########## Tcl recorder starts at 11/25/06 23:40:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:40:52 ###########


########## Tcl recorder starts at 11/25/06 23:40:55 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:40:55 ###########


########## Tcl recorder starts at 11/25/06 23:42:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:42:54 ###########


########## Tcl recorder starts at 11/25/06 23:42:57 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:42:57 ###########


########## Tcl recorder starts at 11/25/06 23:44:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:44:22 ###########


########## Tcl recorder starts at 11/25/06 23:44:24 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:44:24 ###########


########## Tcl recorder starts at 11/25/06 23:51:10 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:51:10 ###########


########## Tcl recorder starts at 11/25/06 23:52:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/25/06 23:52:56 ###########


########## Tcl recorder starts at 11/25/06 23:53:56 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:53:56 ###########


########## Tcl recorder starts at 11/25/06 23:59:37 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/25/06 23:59:37 ###########


########## Tcl recorder starts at 11/26/06 00:08:43 ##########

# Commands to make the Process: 
# Place & Route Design
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"barrel_shifter.edi\" \"barrel_shifter.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"siggen.tcy\" -w \"barrel_shifter.ngo\" -m \"barrel_shifter.ngo\" \"siggen.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"barrel_shifter.ngo\" \"siggen.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"siggen.ngd\" -o \"siggen_map.ncd\" -mp \"siggen.mrp\" \"siggen.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open siggen.cm2 w} rspFile] {
	puts stderr "Cannot create response file siggen.cm2: $rspFile"
} else {
	puts $rspFile "-t siggen.mt
-to siggen.tw1
-o siggen.tcm
-log siggen.log
-pr siggen.prf
-rpt siggen.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"siggen.cmm\" -f \"siggen.cm2\" -arch ep5g00p \"siggen_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete siggen.cm2
if [catch {open siggen.p2t w} rspFile] {
	puts stderr "Cannot create response file siggen.p2t: $rspFile"
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
if [catch {open siggen.p3t w} rspFile] {
	puts stderr "Cannot create response file siggen.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log siggen.log
-o siggen_mp.par
-pr siggen.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p siggen.p2t -f \"siggen.p3t\" \"siggen_map.ncd\" \"siggen.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:08:43 ###########


########## Tcl recorder starts at 11/26/06 00:40:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:40:50 ###########


########## Tcl recorder starts at 11/26/06 00:40:58 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:40:58 ###########


########## Tcl recorder starts at 11/26/06 00:41:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:41:42 ###########


########## Tcl recorder starts at 11/26/06 00:41:44 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:41:44 ###########


########## Tcl recorder starts at 11/26/06 00:42:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:42:14 ###########


########## Tcl recorder starts at 11/26/06 00:42:16 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:42:16 ###########


########## Tcl recorder starts at 11/26/06 00:46:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:46:05 ###########


########## Tcl recorder starts at 11/26/06 00:46:07 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:46:07 ###########


########## Tcl recorder starts at 11/26/06 00:46:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:46:40 ###########


########## Tcl recorder starts at 11/26/06 00:46:43 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:46:43 ###########


########## Tcl recorder starts at 11/26/06 00:47:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:47:09 ###########


########## Tcl recorder starts at 11/26/06 00:47:12 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:47:12 ###########


########## Tcl recorder starts at 11/26/06 00:56:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/lpc2jhd\" ../common_files/multi_shifter.lpc -family ep5g00p"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:56:35 ###########


########## Tcl recorder starts at 11/26/06 00:57:06 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:57:06 ###########


########## Tcl recorder starts at 11/26/06 00:59:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 00:59:51 ###########


########## Tcl recorder starts at 11/26/06 00:59:54 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 00:59:54 ###########


########## Tcl recorder starts at 11/26/06 01:00:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:00:22 ###########


########## Tcl recorder starts at 11/26/06 01:00:26 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:00:26 ###########


########## Tcl recorder starts at 11/26/06 01:01:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:01:46 ###########


########## Tcl recorder starts at 11/26/06 01:01:48 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:01:48 ###########


########## Tcl recorder starts at 11/26/06 01:02:48 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:02:48 ###########


########## Tcl recorder starts at 11/26/06 01:03:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:03:25 ###########


########## Tcl recorder starts at 11/26/06 01:03:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:03:27 ###########


########## Tcl recorder starts at 11/26/06 01:04:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:04:50 ###########


########## Tcl recorder starts at 11/26/06 01:04:52 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" multi_shifter.vhd ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:04:52 ###########


########## Tcl recorder starts at 11/26/06 01:32:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:32:04 ###########


########## Tcl recorder starts at 11/26/06 01:32:09 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/26/06 01:32:09 ###########


########## Tcl recorder starts at 11/26/06 01:32:36 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:32:36 ###########


########## Tcl recorder starts at 11/26/06 01:33:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:33:48 ###########


########## Tcl recorder starts at 11/26/06 01:33:51 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:33:51 ###########


########## Tcl recorder starts at 11/26/06 01:42:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:42:45 ###########


########## Tcl recorder starts at 11/26/06 01:42:51 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:42:51 ###########


########## Tcl recorder starts at 11/26/06 01:43:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:43:34 ###########


########## Tcl recorder starts at 11/26/06 01:43:37 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:43:37 ###########


########## Tcl recorder starts at 11/26/06 01:44:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:44:13 ###########


########## Tcl recorder starts at 11/26/06 01:44:15 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:44:15 ###########


########## Tcl recorder starts at 11/26/06 01:44:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:44:39 ###########


########## Tcl recorder starts at 11/26/06 01:44:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open barrel_shifter.cmd w} rspFile] {
	puts stderr "Cannot create response file barrel_shifter.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: barrel_shifter
working_path: \"$proj_dir\"
module: barrel_shifter
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd
output_file_name: barrel_shifter
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
if [runCmd "\"$cpld_bin/synpwrap\" -e barrel_shifter -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete barrel_shifter.cmd

########## Tcl recorder end at 11/26/06 01:44:41 ###########


########## Tcl recorder starts at 11/26/06 01:56:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:56:24 ###########


########## Tcl recorder starts at 11/26/06 01:58:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/26/06 01:58:27 ###########


########## Tcl recorder starts at 11/26/06 01:59:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 01:59:37 ###########


########## Tcl recorder starts at 11/26/06 01:59:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/26/06 01:59:41 ###########


########## Tcl recorder starts at 11/26/06 02:00:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 02:00:19 ###########


########## Tcl recorder starts at 11/26/06 02:00:23 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/26/06 02:00:23 ###########


########## Tcl recorder starts at 11/26/06 02:01:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 02:01:18 ###########


########## Tcl recorder starts at 11/26/06 02:01:21 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/26/06 02:01:21 ###########


########## Tcl recorder starts at 11/26/06 02:02:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 02:02:32 ###########


########## Tcl recorder starts at 11/26/06 02:02:35 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/26/06 02:02:35 ###########


########## Tcl recorder starts at 11/26/06 04:35:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_full.vhd\" -o \"cordic_full.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:35:48 ###########


########## Tcl recorder starts at 11/26/06 04:36:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_full.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_full.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_full
working_path: \"$proj_dir\"
module: cordic_full
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd
output_file_name: cordic_full
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_full -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_full.cmd

########## Tcl recorder end at 11/26/06 04:36:41 ###########


########## Tcl recorder starts at 11/26/06 04:39:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_full.vhd\" -o \"cordic_full.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:39:31 ###########


########## Tcl recorder starts at 11/26/06 04:39:34 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic_full.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic_full.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic_full
working_path: \"$proj_dir\"
module: cordic_full
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd
output_file_name: cordic_full
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic_full -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic_full.cmd

########## Tcl recorder end at 11/26/06 04:39:34 ###########


########## Tcl recorder starts at 11/26/06 04:45:52 ##########

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

########## Tcl recorder end at 11/26/06 04:45:52 ###########


########## Tcl recorder starts at 11/26/06 04:46:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_lut.vhd\" -o \"cordic_lut.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
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
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/barrel_shifter.vhd\" -o \"barrel_shifter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
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
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_full.vhd\" -o \"cordic_full.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
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

########## Tcl recorder end at 11/26/06 04:46:48 ###########


########## Tcl recorder starts at 11/26/06 04:47:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/chatter_suppress.vhd\" -o \"chatter_suppress.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:47:14 ###########


########## Tcl recorder starts at 11/26/06 04:47:54 ##########

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

########## Tcl recorder end at 11/26/06 04:47:54 ###########


########## Tcl recorder starts at 11/26/06 04:48:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/clockgen_main.vhd\" -o \"clockgen_main.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:48:29 ###########


########## Tcl recorder starts at 11/26/06 04:48:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:48:59 ###########


########## Tcl recorder starts at 11/26/06 04:49:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/segment_decoder.vhd\" -o \"segment_decoder.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:49:33 ###########


########## Tcl recorder starts at 11/26/06 04:50:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/reset_gen.vhd\" -o \"reset_gen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:50:18 ###########


########## Tcl recorder starts at 11/26/06 04:50:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_transmitter.vhd\" -o \"i2s_transmitter.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:50:48 ###########


########## Tcl recorder starts at 11/26/06 04:51:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/i2s_receiver.vhd\" -o \"i2s_receiver.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 04:51:25 ###########


########## Tcl recorder starts at 11/26/06 04:52:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 04:52:27 ###########


########## Tcl recorder starts at 11/26/06 04:55:00 ##########

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

########## Tcl recorder end at 11/26/06 04:55:00 ###########


########## Tcl recorder starts at 11/26/06 04:55:09 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 04:55:09 ###########


########## Tcl recorder starts at 11/26/06 04:55:57 ##########

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

########## Tcl recorder end at 11/26/06 04:55:57 ###########


########## Tcl recorder starts at 11/26/06 04:56:06 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 04:56:06 ###########


########## Tcl recorder starts at 11/26/06 04:56:50 ##########

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

########## Tcl recorder end at 11/26/06 04:56:50 ###########


########## Tcl recorder starts at 11/26/06 04:56:58 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 04:56:58 ###########


########## Tcl recorder starts at 11/26/06 04:58:40 ##########

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

########## Tcl recorder end at 11/26/06 04:58:40 ###########


########## Tcl recorder starts at 11/26/06 04:58:48 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 04:58:48 ###########


########## Tcl recorder starts at 11/26/06 04:59:19 ##########

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

########## Tcl recorder end at 11/26/06 04:59:19 ###########


########## Tcl recorder starts at 11/26/06 04:59:29 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 04:59:29 ###########


########## Tcl recorder starts at 11/26/06 05:00:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:00:07 ###########


########## Tcl recorder starts at 11/26/06 05:00:16 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:00:16 ###########


########## Tcl recorder starts at 11/26/06 05:01:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:01:51 ###########


########## Tcl recorder starts at 11/26/06 05:02:00 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:02:00 ###########


########## Tcl recorder starts at 11/26/06 05:02:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:02:56 ###########


########## Tcl recorder starts at 11/26/06 05:03:05 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:03:05 ###########


########## Tcl recorder starts at 11/26/06 05:08:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:08:52 ###########


########## Tcl recorder starts at 11/26/06 05:09:00 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:09:00 ###########


########## Tcl recorder starts at 11/26/06 05:09:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:09:41 ###########


########## Tcl recorder starts at 11/26/06 05:09:49 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:09:49 ###########


########## Tcl recorder starts at 11/26/06 05:11:05 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:11:05 ###########


########## Tcl recorder starts at 11/26/06 05:11:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:11:37 ###########


########## Tcl recorder starts at 11/26/06 05:11:46 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:11:46 ###########


########## Tcl recorder starts at 11/26/06 05:12:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:12:30 ###########


########## Tcl recorder starts at 11/26/06 05:12:38 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:12:38 ###########


########## Tcl recorder starts at 11/26/06 05:13:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:13:17 ###########


########## Tcl recorder starts at 11/26/06 05:13:26 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:13:26 ###########


########## Tcl recorder starts at 11/26/06 05:14:17 ##########

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

########## Tcl recorder end at 11/26/06 05:14:17 ###########


########## Tcl recorder starts at 11/26/06 05:14:25 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:14:25 ###########


########## Tcl recorder starts at 11/26/06 05:16:19 ##########

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

########## Tcl recorder end at 11/26/06 05:16:19 ###########


########## Tcl recorder starts at 11/26/06 05:16:27 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:16:27 ###########


########## Tcl recorder starts at 11/26/06 05:19:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"../common_files/gain_control.vhd\" -o \"gain_control.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:19:11 ###########


########## Tcl recorder starts at 11/26/06 05:19:20 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: toplevel
working_path: \"$proj_dir\"
module: toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" ../common_files/barrel_shifter.vhd cordic_lut.vhd cordic.vhd cordic_full.vhd stud_toplevel.vhd ../common_files/segment_decoder.vhd ../common_files/bargraph_decoder.vhd ../common_files/chatter_suppress.vhd ../common_files/gain_control.vhd ../common_files/i2s_transmitter.vhd ../common_files/i2s_receiver.vhd ../common_files/reset_gen.vhd ../common_files/clockgen_main.vhd ../common_files/clockgen.vhd ../common_files/toplevel.vhd
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

########## Tcl recorder end at 11/26/06 05:19:20 ###########


########## Tcl recorder starts at 11/26/06 05:22:10 ##########

# Commands to make the Process: 
# Generate Bitstream Data
if [runCmd "\"$fpga_bin/edif2ngd\" -l ep5g00p -d lfecp20e \"toplevel.edi\" \"toplevel.ngo\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/edfupdate\" -t \"siggen.tcy\" -w \"toplevel.ngo\" -m \"toplevel.ngo\" \"siggen.ngx\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/ngdbuild\" -a ep5g00p -d lfecp20e \"toplevel.ngo\" \"siggen.ngd\" -p \"$fpga_dir/ep5g00p/data\" -p \"$fpga_dir/ep5g00/data\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$fpga_bin/map\" -a ep5g00p -p lfecp20e -t fpbga484 -s 3 \"siggen.ngd\" -o \"siggen_map.ncd\" -mp \"siggen.mrp\" \"siggen.lpf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open siggen.cm2 w} rspFile] {
	puts stderr "Cannot create response file siggen.cm2: $rspFile"
} else {
	puts $rspFile "-t siggen.mt
-to siggen.tw1
-o siggen.tcm
-log siggen.log
-pr siggen.prf
-rpt siggen.mrp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -m -f \"siggen.cmm\" -f \"siggen.cm2\" -arch ep5g00p \"siggen_map.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete siggen.cm2
if [catch {open siggen.p2t w} rspFile] {
	puts stderr "Cannot create response file siggen.p2t: $rspFile"
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
if [catch {open siggen.p3t w} rspFile] {
	puts stderr "Cannot create response file siggen.p3t: $rspFile"
} else {
	puts $rspFile "-rem
-log siggen.log
-o siggen_mp.par
-pr siggen.prf
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/multipar\" -p siggen.p2t -f \"siggen.p3t\" \"siggen_map.ncd\" \"siggen.ncd\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open siggen.cm2 w} rspFile] {
	puts stderr "Cannot create response file siggen.cm2: $rspFile"
} else {
	puts $rspFile "-t siggen.pt
-to siggen.twr
-o siggen.tcp
-log siggen.log
-pr siggen.prf
-rpt siggen.par
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/checkpoint\" -p -f \"siggen.cmp\" -f \"siggen.cm2\" -arch ep5g00p \"siggen.ncd\" -l 60"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete siggen.cm2
if [catch {open siggen.t2b w} rspFile] {
	puts stderr "Cannot create response file siggen.t2b: $rspFile"
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
if [runCmd "\"$fpga_bin/bitgen\" -f \"siggen.t2b\" -w \"siggen.ncd\" \"siggen.prf\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 05:22:10 ###########


########## Tcl recorder starts at 11/26/06 19:29:49 ##########

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

########## Tcl recorder end at 11/26/06 19:29:49 ###########


########## Tcl recorder starts at 11/26/06 19:29:56 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open stud_toplevel.cmd w} rspFile] {
	puts stderr "Cannot create response file stud_toplevel.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: stud_toplevel
working_path: \"$proj_dir\"
module: stud_toplevel
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" stud_toplevel.vhd
output_file_name: stud_toplevel
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
if [runCmd "\"$cpld_bin/synpwrap\" -e stud_toplevel -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete stud_toplevel.cmd

########## Tcl recorder end at 11/26/06 19:29:56 ###########


########## Tcl recorder starts at 11/26/06 19:31:20 ##########

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
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic_siggen.vhd\" -o \"cordic_siggen.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/26/06 19:31:20 ###########


########## Tcl recorder starts at 11/29/06 22:52:33 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/29/06 22:52:33 ###########


########## Tcl recorder starts at 11/29/06 22:56:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/29/06 22:56:49 ###########


########## Tcl recorder starts at 11/29/06 22:56:58 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/29/06 22:56:58 ###########


########## Tcl recorder starts at 11/29/06 22:58:34 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/29/06 22:58:34 ###########


########## Tcl recorder starts at 11/29/06 22:59:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" \"cordic.vhd\" -o \"cordic.jhd\" -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 11/29/06 22:59:01 ###########


########## Tcl recorder starts at 11/29/06 22:59:09 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open cordic.cmd w} rspFile] {
	puts stderr "Cannot create response file cordic.cmd: $rspFile"
} else {
	puts $rspFile "PROJECT: cordic
working_path: \"$proj_dir\"
module: cordic
vhdl_file_list: \"$install_dir/ispcpld/../cae_library/synthesis/vhdl/ecp.vhd\" cordic_lut.vhd cordic.vhd
output_file_name: cordic
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
if [runCmd "\"$cpld_bin/synpwrap\" -e cordic -target lattice-ecp -part lfecp20e"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete cordic.cmd

########## Tcl recorder end at 11/29/06 22:59:09 ###########

