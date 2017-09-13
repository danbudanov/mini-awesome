module ads1672_evm_device
#(
    parameter DATA_WIDTH =24
)
(
    input clkx,    //serial transmit clk from processor
    output logic clkr,   // serial receive clk from ADC

    input fsx,     // frame sync signal from processor
    output logic fsr,    // frame sync signal from ADC

    input start,    // toggle start pin
    output logic drdy_n,  // data ready interrupt to processor
    output logic drr      // data to processor
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
        drdy_n = 1;
    // If logic is in operation, then clock in data one bit at a time, MSB first
    end else if (in_operation) begin
        // Toggle drdy_n if first bit
        if (i == 1) 
            drdy_n = 0;
        else 
            drdy_n = 1;

        // Clock in the proper data
        if (i <= DATA_WIDTH) begin
            drr = test_reading[DATA_WIDTH - i];
            i++;
        end
    end else begin
        in_operation = 0;
        drr = 1'bx;
        drdy_n = 1;
    end

end

// Transmit and receive clocks are jumped together
assign clkr = clkx;

// Frame sync return to processor sourced from drdy_n
assign fsr = drdy_n;

endmodule
