module ads1672_evm_device
#(
    parameter DATA_WIDTH =24;
)
(
    input clkx,    //serial transmit clk from processor
    output clkr,   // serial receive clk from ADC

    input fsx,     // frame sync signal from processor
    output fsr,    // frame sync signal from ADC

    input start,    // toggle start pin
    output drdy_n,  // data ready interrupt to processor
    output drr      // data to processor
);

logic [DATA_WIDTH - 1 : 0] test_reading = 24'b110010101100111100001100;

logic in_operation;

integer i;
always_ff @(posedge clkr)
begin
    // If start is pulsed, then operation starts
    if (start) begin
        in_operation = 1;
        i = 1;
    // If logic is in operation, then clock in data one bit at a time, MSB
    // first
    end else if (in_operation) begin
        if (i <= DATA_WIDTH) begin
            drr = test_reading[DATA_WIDTH - i];
            i++;
        end
    end else begin
        in_operation = 0;
        drr = 1'bx;
    end

end

// Transmit and receive clocks are jumped together
assign clkr = clkx;

// Frame sync return to processor sourced from drdy_n
assign fsr = drdy_n;

endmodule
