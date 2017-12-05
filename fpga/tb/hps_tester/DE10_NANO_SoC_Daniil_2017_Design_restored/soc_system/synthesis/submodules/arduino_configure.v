//! @file arduino_configure.v
//! @brief Configure which Arduino ports are selected
//! @author Daniil Budanov

/*!
 * This module connects multiple enables to the Avalon MM bus, allowing the
 * user to configure various protocol functionality for each pin.
 */

module arduino_configure
#(
    parameter REG_WIDTH = 32, //! Width of data transferred by AVMM
    parameter ADDR_WIDTH = $clog2(NUM_BUS + NUM_PWM), /*! Width of AVMM address
                                                          space */
    parameter NUM_PWM = 8, //! Number of PWM pins
    parameter NUM_BUS = 3 //! Number of protocol busses
)
(
    //! Inputs
    input clk, rst, 
    input write, //! Write selector
    input [REG_WIDTH  - 1 : 0] writedata, //! Data bus
    input read, //! Read selector
    output [REG_WIDTH  - 1 : 0] readdata, //! Data bus
    input [ADDR_WIDTH - 1 : 0] addr, /*! Address of register to be written to
                                         or read from */
    
    //! Outputs
    output i2c_sel, //! I2C enable
    output spi_sel, //! SPI enable
    output uart_sel, //! UART enable
    output [NUM_PWM   - 1 : 0] pwm_sel //! PWM select bus
);

/*!
 * Structure:
 * I2C [1] (addr 0x0)
 * SPI [1] (addr 0x1)
 * UART[1] (addr 0x2)
 * PWM [8] (addr 0x3..0x10)
 */

//! Calculate the total accessible number of registers in program
localparam NUM_REG = NUM_BUS + NUM_PWM;
reg [REG_WIDTH-1 : 0] data_mem [0 :  NUM_REG-1]; /*! Register memory for storing
                                                     data */
reg [REG_WIDTH-1 : 0] readdata_d = 0;

assign readdata = readdata_d;

//! Whenever write is enabled, write to the memory
always @(posedge clk)
begin
    if (write) begin
        data_mem[addr] <= writedata;
    end
end

//! Whenever read is enabled, read from the memory
always @(posedge clk)
begin
    if (read) begin
        readdata_d <= data_mem[addr];
    end
end

//! The first threee words are used to enable busses
assign i2c_sel = data_mem[0][0]; 
assign spi_sel = data_mem[1][0];
assign uart_sel = data_mem[2][0];

// For every word in PWM portion of memory, set PWM selector to LSB
genvar i;
generate
for (i=0; i<NUM_PWM; i=i+1) begin : generate_pwm
    assign pwm_sel[i] = data_mem[i + NUM_BUS][0];
end
endgenerate

endmodule
