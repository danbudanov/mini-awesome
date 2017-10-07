# TCL File Generated by Component Editor 17.0
# Fri Oct 06 22:06:54 EDT 2017
# DO NOT MODIFY


# 
# ads1672_controller "ads1672" v1.0
#  2017.10.06.22:06:54
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module ads1672_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME ads1672_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME ads1672
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL ads1672_avmm
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file ads1672_avmm.sv SYSTEM_VERILOG PATH ../hw/ads1672_avmm.sv TOP_LEVEL_FILE
add_fileset_file ads1672_evm.sv SYSTEM_VERILOG PATH ../../../hdl/adc/ads1672_evm.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL ads1672_avmm
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file ads1672_avmm.sv SYSTEM_VERILOG PATH ../hw/ads1672_avmm.sv
add_fileset_file ads1672_evm.sv SYSTEM_VERILOG PATH ../../../hdl/adc/ads1672_evm.sv


# 
# parameters
# 
add_parameter ADC_DATA_WIDTH INTEGER 24
set_parameter_property ADC_DATA_WIDTH DEFAULT_VALUE 24
set_parameter_property ADC_DATA_WIDTH DISPLAY_NAME ADC_DATA_WIDTH
set_parameter_property ADC_DATA_WIDTH TYPE INTEGER
set_parameter_property ADC_DATA_WIDTH UNITS None
set_parameter_property ADC_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADC_DATA_WIDTH HDL_PARAMETER true
add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point adc_ports
# 
add_interface adc_ports conduit end
set_interface_property adc_ports associatedClock clock
set_interface_property adc_ports associatedReset ""
set_interface_property adc_ports ENABLED true
set_interface_property adc_ports EXPORT_OF ""
set_interface_property adc_ports PORT_NAME_MAP ""
set_interface_property adc_ports CMSIS_SVD_VARIABLES ""
set_interface_property adc_ports SVD_ADDRESS_GROUP ""

add_interface_port adc_ports clkr clkr Input 1
add_interface_port adc_ports clkx clkx Output 1
add_interface_port adc_ports drdy_n drdy_n Input 1
add_interface_port adc_ports drr drr Input 1
add_interface_port adc_ports fsr fsr Input 1
add_interface_port adc_ports fsx fsx Output 1
add_interface_port adc_ports start start Output 1


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave read read Input 1
add_interface_port avalon_slave readdata readdata Output 32
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rst reset Input 1

