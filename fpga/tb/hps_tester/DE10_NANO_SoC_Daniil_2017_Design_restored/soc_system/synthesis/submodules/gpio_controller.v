//! @file gpio_controller.v
//! @brief Controller providing access to GPIO IO and direction registers
//! @author Daniil Budanov

module gpio_controller
#(
    parameter HEADER_WIDTH = 16, //! Number of GPIOs in header
    parameter REG_WIDTH    = 32, //! Width of data transferred by AVMM
    parameter ADDR_WIDTH   = $clog2(2 * HEADER_WIDTH) //! Width of AVMM address space
)
(
    input clk, rst, 
    input write, //! Write selector
    input read, //! Read selector
    input [REG_WIDTH  - 1  : 0] writedata, //! Write data bus
    output reg [REG_WIDTH  - 1  : 0] readdata, //! Read data bus
    input [ADDR_WIDTH - 1  : 0] addr, //! address of controller register

    output [HEADER_WIDTH - 1 : 0] gpio_dir, //! GPIO direction bus
    input  [HEADER_WIDTH - 1 : 0] gpio_in, //! Inputs into GPIO controller
    output [HEADER_WIDTH - 1 : 0] gpio_out //! Outputs from GPIO controller
);

/*! 
 *  When written, data_outputs[0..HEADER_WIDTH-1] stores directions
 *  whereas data_outputs[HEADER_WIDTH-1 .. 2*HEADER_WIDTH - 1] stores the
 *  actual output values
 */
reg [REG_WIDTH-1 : 0] data_outputs[0 : (2 * HEADER_WIDTH)-1];

//! Memory for storing inputs, if direction set to input
reg [REG_WIDTH-1 : 0] data_inputs [0 : HEADER_WIDTH-1];

/*! 
 * Register to keep track of which regs were written to
 * until then, treat GPIO pins as inputs, high impedance
 */
reg [HEADER_WIDTH-1 : 0] written;

always @(posedge clk) 
begin
    if(rst) begin
        written <= 'b0; // Clear out written reg upon reset

    end else if(write) begin // Writing state
        data_outputs[addr] <= writedata; // Write appropriate register 
                                         // in memory
        // If either direction or output value set, change written to TRUE
        if(addr < HEADER_WIDTH) begin
            written[addr] <= 1;
        end else begin
            written[addr - HEADER_WIDTH] <= 1;
        end
    end

    if (read) begin // Reading state
        if (addr < HEADER_WIDTH) begin
            readdata <= data_inputs[addr];
        end else begin
            readdata <= data_inputs[addr - HEADER_WIDTH];
        end
    end
end

//! @brief Read and write between conduit, depending on direction
genvar k;
generate
for (k=0; k<HEADER_WIDTH; k=k+1) begin : generate_gpio_dir
    // If not written, then treat as input
    assign gpio_dir[k] = written[k] ? data_outputs[k][0] : 1'b1;
    // Data to be output
    assign gpio_out[k] = data_outputs[k + HEADER_WIDTH][0];

    // For every pin that is an input, feed value into register memory
    always @(posedge clk)
    begin
        if (gpio_dir[k]) begin
            data_inputs[k] <= {{(REG_WIDTH-1){1'b0}}, gpio_in[k]};
        end
    end
end
endgenerate

endmodule
