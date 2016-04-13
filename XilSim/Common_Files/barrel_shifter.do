onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -label SIGNED_SHIFT /barrel_shifter_tb/signed_shift
add wave -noupdate -format Literal -label SHIFT_AMOUNT -radix decimal /barrel_shifter_tb/shift_amount
add wave -noupdate -format Literal -label DATA_IN /barrel_shifter_tb/data_in
add wave -noupdate -format Literal -label DATA_OUT /barrel_shifter_tb/data_out
add wave -noupdate -format Logic -label CLK /barrel_shifter_tb/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999671 ps} 0}
configure wave -namecolwidth 136
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
WaveRestoreZoom {0 ps} {1050 ns}
