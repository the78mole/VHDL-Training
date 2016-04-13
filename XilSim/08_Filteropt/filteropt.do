onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Red -format Logic -label CLK /filteropt_tb/clk_in
add wave -noupdate -color Red -format Logic -label nRESET /filteropt_tb/nreset
add wave -noupdate -color BLue -format Logic -label DVAL_IN /filteropt_tb/dval_in
add wave -noupdate -color Blue -format Analog-Step -height 100 -label DATA_IN -offset 127.0 -radix decimal -scale 0.38 /filteropt_tb/data_in
add wave -noupdate -color Green -format Literal -label FREQ_kHz /filteropt_tb/sr_sine_var
add wave -noupdate -color Gold -format Analog-Step -height 100 -label DATA_OUT -offset 127.0 -radix decimal -scale 0.38 /filteropt_tb/data_out
add wave -noupdate -color Gold -format Logic -label DVAL_OUT /filteropt_tb/dval_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95191120000 ps} 0}
configure wave -namecolwidth 109
configure wave -valuecolwidth 63
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
WaveRestoreZoom {0 ps} {105 ms}
