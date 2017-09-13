/**
* @file ADS1672_EVM_tb.sv
* @author Daniil Budanov
* @brief Testbench for the ADS1672-EVM ADC
*/
`timescale 10ns/10ns

module ADS1672_EVM_tb;

localparam DATA_WIDTH = 24;

logic clk;
logic rst;

logic measure; // pulse indicating the start of measuring

logic clkx; // Serial transmit clock from processor (jumped to clkr)
logic clkr; // Serial receive clock from ADC (jumped to clkx)
logic fsx;  // frame sync signal from processor
logic fsr;  // frame sync return to processor; src from drdy_n

logic drr;                         // logic data into processor
logic drdy_n;                      // data ready interrupt source to processor
logic start;                       // general purpose pin toggles start
logic [DATA_WIDTH-1 : 0] data_out; // output data reading

initial begin
    clk = 0;
    rst = 1;
    measure = 0;

    // Toggle reset
    #2;
    rst = 0;

    #10 measure = 1;
    #2  measure = 0;

    #100 $finish;


end

always #1 clk = !clk;

ads1672_evm_device ads1672_evm_device_inst
(
    .clkx(clkx), 
    .clkr(clkr),
    .fsx(fsx), 
    .fsr(fsr),
    .start(start),
    .drdy_n(drdy_n),
    .drr(drr)
);


ads1672_evm ads1672_evm_inst
(
    .clk(clk),
    .rst(rst),
    .clkx(clkx), 
    .clkr(clkr),
    .fsx(fsx),
    .fsr(fsr),
    .drr(drr),
    .drdy_n(drdy_n),
    .start(start),
    .data_out(data_out),
    .measure(measure)
);

assign clkx = clk;

endmodule
