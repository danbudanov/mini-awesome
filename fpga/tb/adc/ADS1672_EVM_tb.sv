/**
* @file ADS1672_EVM_tb.sv
* @author Daniil Budanov
* @brief Testbench for the ADS1672-EVM ADC
*/
`timescale 10ns/10ns

module ADS1672_EVM_tb;

logic clk;
logic rst;

logic measure; // pulse indicating the start of measuring

logic clkx; // Serial transmit clock from processor (jumped to clkr)
logic clkr;  // Serial receive clock from ADC (jumped to clkx)
logic fsx; // frame sync signal from processor
logic fsr; // frame sync return to processor; src from drdy_n

logic drr; // logic data into processor
logic drdy_n; // data ready interrupt source to processor
logic start; // general purpose pin toggles start
logic [DATA_WIDTH-1 : 0] data_out; // output data reading

localparam DATA_WIDTH = 24;

logic [DATA_WIDTH - 1 : 0] test_reading = 
    24'b110010101100111100001100;

initial begin
    clk = 0;
    rst = 1;

    // Toggle reset
    #2;
    rst = 0;

    #10;


    #2;


end

always #1 clk = !clk;

assign clkx = clk;
assign clkr =clkx;

assign fsr = drdy_n;

ads1672_evm ads1672_evm_inst
(
    .clk, rst,

    input measure, // pulse indicating the start of measuring

    output clkx, // Serial transmit clock from processor (jumped to clkr)
    input clkr,  // Serial receive clock from ADC (jumped to clkx)
    output fsx, // frame sync signal from processor
    input fsr, // frame sync return to processor, src from drdy_n

    input drr, // input data into processor
    input drdy_n, // data ready interrupt source to processor
    output logic start, // general purpose pin toggles start
    output logic [DATA_WIDTH-1 : 0] data_out // output data reading
)

endmodule
