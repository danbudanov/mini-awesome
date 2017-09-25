onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ADS1672_EVM_tb/clk
add wave -noupdate /ADS1672_EVM_tb/rst
add wave -noupdate /ADS1672_EVM_tb/measure
add wave -noupdate /ADS1672_EVM_tb/clkx
add wave -noupdate /ADS1672_EVM_tb/drr
add wave -noupdate /ADS1672_EVM_tb/drdy_n
add wave -noupdate /ADS1672_EVM_tb/start
add wave -noupdate /ADS1672_EVM_tb/data_out
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/clk
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/rst
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/measure
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/clkx
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/start
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/data_out
add wave -noupdate -label drdy_n /ADS1672_EVM_tb/ads1672_evm_inst/drdy_n
add wave -noupdate -label drr /ADS1672_EVM_tb/ads1672_evm_inst/drr
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/clkr
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/State
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/NextState
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/data
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/data_ct
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/data_ct_new
add wave -noupdate /ADS1672_EVM_tb/ads1672_evm_inst/data_write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
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
WaveRestoreZoom {160 ns} {400 ns}
