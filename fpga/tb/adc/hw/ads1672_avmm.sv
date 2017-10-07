module ads1672_avmm
#(
    parameter ADC_DATA_WIDTH = 24,
    parameter DATA_WIDTH = 32
)
(
    // Avalon MM Signals
    input clk, rst,

    input read, // unless a live read is implemented, extraneous
    output logic [DATA_WIDTH-1 : 0] readdata,

    // Conduits

    output clkx, // Serial transmit clock from processor (jumped to clkr)
    input clkr,  // Serial receive clock from ADC (jumped to clkx)
    output fsx,  // frame sync signal from processor
    input fsr,   // frame sync return to processor, src from drdy_n

    input drr,    // input data into processor
    input drdy_n, // data ready interrupt source to processor
    output logic start // general purpose pin toggles start
);

// Sent out by FPGA
logic measure; // pulse indicating the start of measuring

logic [DATA_WIDTH-1 : 0] data_out; // output data reading

assign readdata = { 8'b0, data_out };

always_ff @(posedge clk)
begin
    if (rst)
        measure <= 1'b0;
    else if (read && !measure)
        measure <= 1'b1;
    else 
        measure <= 1'b0;
end

ads1672_evm #(.DATA_WIDTH(ADC_DATA_WIDTH)) ads1672_evm_inst 
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

endmodule
