onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ADS1672_EVM_tb/rst
add wave -noupdate /ADS1672_EVM_tb/measure
add wave -noupdate /ADS1672_EVM_tb/clkx
add wave -noupdate /ADS1672_EVM_tb/drr
add wave -noupdate /ADS1672_EVM_tb/drdy_n
add wave -noupdate /ADS1672_EVM_tb/start
add wave -noupdate -label {Output Data} /ADS1672_EVM_tb/data_out
add wave -noupdate -label {Internal Start} /ADS1672_EVM_tb/ads1672_evm_inst/start
add wave -noupdate -label {Final Data} /ADS1672_EVM_tb/ads1672_evm_inst/data_out
add wave -noupdate -label State /ADS1672_EVM_tb/ads1672_evm_inst/State
add wave -noupdate -label NextState /ADS1672_EVM_tb/ads1672_evm_inst/NextState
add wave -noupdate -label {internal data} /ADS1672_EVM_tb/ads1672_evm_inst/data
add wave -noupdate -label data_ct /ADS1672_EVM_tb/ads1672_evm_inst/data_ct
add wave -noupdate -label data_ct_new /ADS1672_EVM_tb/ads1672_evm_inst/data_ct_new
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {70 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1780 ns}
