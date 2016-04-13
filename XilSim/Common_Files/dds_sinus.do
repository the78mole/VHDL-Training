onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Red -format Logic -label CLK /dds_sinus_tb/clk
add wave -noupdate -format Logic -label nRESET /dds_sinus_tb/nreset
add wave -noupdate -color Blue -format Literal -label PHASE_INC -radix unsigned /dds_sinus_tb/phase_inc
add wave -noupdate -color Gold -format Analog-Step -height 100 -label OUTPUT -radix unsigned -scale 0.25 /dds_sinus_tb/output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9160100000 ps} 0}
configure wave -namecolwidth 117
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
WaveRestoreZoom {0 ps} {30403481013 ps}
