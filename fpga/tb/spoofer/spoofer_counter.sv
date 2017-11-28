/**
 * @file spoofer_counter.sv
 * @author Daniil Budanov
 * @brief counter implementing the logic behind the spoofer AVST core
 */

module spoofer_counter
#(
    parameter WIDTH = 24,
    parameter MAX_NUM = (1 << WIDTH) - 1,
    parameter ZEROS_WIDTH = 32 - WIDTH
)
(
    input rst, clk,

    input read_signal,

    output [WIDTH + ZEROS_WIDTH - 1 : 0] count_out
);

logic [WIDTH-1 : 0] count, next_count;
logic read_enable;

assign count_out = count; //{ZEROS_WIDTH'h0, count};

logic read_monitor, prev_read_monitor;

always_ff @(posedge clk)
begin
    prev_read_monitor <= read_monitor;
    read_monitor <= read_signal;
end

assign read_enable = (!prev_read_monitor) && (read_monitor);

always_comb
begin : GET_NEXT_COUNT
    if (count == MAX_NUM)
        next_count = 0;
    else
        next_count = count + 1;
end

always_ff @(posedge clk)
begin : UPDATE_COUNTER
    if (rst) 
        count <= 0;
    else if (read_enable)
        count <= next_count;
    else
        count <= count;
end

endmodule
