//! @file pwm_controller.v
//! @brief Allows user to control PWM cores 
//! @author Daniil Budanov

module pwm_controller
#(
    parameter NUM_PWM = 8, //! Total number of PWMs
    parameter DATA_WIDTH = 8, //! PWM resolution
    parameter ADDR_WIDTH = $clog2(NUM_PWM), //! Address width of AVMM bus
    parameter REG_WIDTH = 32 //! Data width of AVMM bus
)
(
    input clk, //! Input clock
    input rst, //! Reset

    input pwm_clk, //! Clock for PWM controller, attached to PLL

    input write, //! Write selector
    input [REG_WIDTH  - 1 : 0] writedata, //! Write data bus
    input [ADDR_WIDTH - 1 : 0] addr, //! Address of controller regs

    output [NUM_PWM - 1 : 0] pwm_sig //! Output PWM signals
);

//! Controller registers containing PWM duty cycles
reg [REG_WIDTH - 1 : 0] data_mem [0 : NUM_PWM - 1];

//! @brief Register write operation
always @(posedge clk)
begin
    if (rst) begin
    end else if (write) begin
        data_mem[addr] = writedata;
    end
end

//! @brief generate the pwm cores
genvar i;
generate
for (i=0; i<NUM_PWM; i=i+1) begin : pwm_logic
    pwm #(.DATA_WIDTH(DATA_WIDTH)) pwm_instance (
        .clk(pwm_clk),
        .rst(rst),
        .sig(pwm_sig[i]),
        .duty(data_mem[i][DATA_WIDTH - 1 : 0])
    );
end
endgenerate

endmodule
