onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Red -format Logic -label CLK /cordic_base_tb/clk_in
add wave -noupdate -color Red -format Logic -label nRESET /cordic_base_tb/nreset
add wave -noupdate -color Green -format Literal -label X_IN_REAL /cordic_base_tb/x_in_real
add wave -noupdate -color Green -format Literal -label Y_IN_REAL /cordic_base_tb/y_in_real
add wave -noupdate -color Green -format Literal -label Z_IN_REAL /cordic_base_tb/z_in_real
add wave -noupdate -color Green -format Literal -label Z_IN_DEGREE /cordic_base_tb/z_in_degree
add wave -noupdate -color Blue -format Logic -label DVAL_IN /cordic_base_tb/dval_in
add wave -noupdate -color Blue -format Literal -label X_IN -radix decimal /cordic_base_tb/x_in
add wave -noupdate -color Blue -format Literal -label Y_IN -radix decimal /cordic_base_tb/y_in
add wave -noupdate -color Blue -format Literal -label Z_IN -radix decimal /cordic_base_tb/z_in
add wave -noupdate -color Gold -format Logic -label DVAL_OUT /cordic_base_tb/dval_out
add wave -noupdate -color Gold -format Literal -label X_OUT -radix decimal /cordic_base_tb/x_out
add wave -noupdate -color Gold -format Literal -label Y_OUT -radix decimal /cordic_base_tb/y_out
add wave -noupdate -color Gold -format Literal -label Z_OUT -radix decimal /cordic_base_tb/z_out
add wave -noupdate -color Green -format Literal -label X_OUT_REAL /cordic_base_tb/x_out_real
add wave -noupdate -color Green -format Literal -label Y_OUT_REAL /cordic_base_tb/y_out_real
add wave -noupdate -color Green -format Literal -label Z_OUT_REAL /cordic_base_tb/z_out_real
add wave -noupdate -color Green -format Literal -label Z_OUT_DEGREE /cordic_base_tb/z_out_degree
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {740000 ps} 0} {{Cursor 2} {500000 ps} 0}
configure wave -namecolwidth 131
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {2100 ns}
