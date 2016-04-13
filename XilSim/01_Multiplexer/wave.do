onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Red -format Logic -label sel_s1 /my_multiplexer_tb/sel_s1
add wave -noupdate -color Red -format Logic -label sel_s2 /my_multiplexer_tb/sel_s2
add wave -noupdate -format Analog-Step -height 80 -label sine_5kHz -offset 127.0 -scale 0.20000000000000001 /my_multiplexer_tb/sine_5khz
add wave -noupdate -format Analog-Step -height 80 -label sine_7kHz -offset 127.0 -scale 0.20000000000000001 /my_multiplexer_tb/sine_7khz
add wave -noupdate -format Analog-Step -height 80 -label adc_data -offset 127.0 -scale 0.20000000000000001 /my_multiplexer_tb/adc_data
add wave -noupdate -color Yellow -format Analog-Step -height 80 -label dac_data -offset 127.0 -scale 0.20000000000000001 /my_multiplexer_tb/dac_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141000 ps} 0}
configure wave -namecolwidth 106
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
