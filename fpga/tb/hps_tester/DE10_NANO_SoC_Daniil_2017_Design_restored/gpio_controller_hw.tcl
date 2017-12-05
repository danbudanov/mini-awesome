# TCL File Generated by Component Editor 17.0
# Thu Jul 06 16:04:20 PDT 2017
# DO NOT MODIFY


# 
# gpio_controller "gpio_controller" v1.0
# Daniil Budanov 2017.07.06.16:04:20
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module gpio_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME gpio_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Daniil Budanov"
set_module_property DISPLAY_NAME gpio_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL gpio_controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file gpio_controller.v VERILOG PATH ip_src/gpio_controller.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL gpio_controller
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file gpio_controller.v VERILOG PATH ip_src/gpio_controller.v


# 
# parameters
# 
add_parameter HEADER_WIDTH INTEGER 16
set_parameter_property HEADER_WIDTH DEFAULT_VALUE 16
set_parameter_property HEADER_WIDTH DISPLAY_NAME HEADER_WIDTH
set_parameter_property HEADER_WIDTH TYPE INTEGER
set_parameter_property HEADER_WIDTH UNITS None
set_parameter_property HEADER_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property HEADER_WIDTH HDL_PARAMETER true
add_parameter REG_WIDTH INTEGER 32
set_parameter_property REG_WIDTH DEFAULT_VALUE 32
set_parameter_property REG_WIDTH DISPLAY_NAME REG_WIDTH
set_parameter_property REG_WIDTH TYPE INTEGER
set_parameter_property REG_WIDTH UNITS None
set_parameter_property REG_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property REG_WIDTH HDL_PARAMETER true


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
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 read read Input 1
add_interface_port avalon_slave_0 writedata writedata Input REG_WIDTH
add_interface_port avalon_slave_0 readdata readdata Output REG_WIDTH
add_interface_port avalon_slave_0 addr address Input 5
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


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


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock ""
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end gpio_dir gpio_direction Output HEADER_WIDTH
add_interface_port conduit_end gpio_out gpio_output_sig Output HEADER_WIDTH
add_interface_port conduit_end gpio_in gpio_input_sig Input HEADER_WIDTH
