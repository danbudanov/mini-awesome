module trigger_counter
#(
    parameter COUNT = 8,
)
(
    input rst, clk,
    input start,

    output logic ready
);

localparam CT_WIDTH = $clog2(COUNT)

logic [CT_WIDTH-1 : 0] count = 0;

always_comb begin
    count_new = count + 1;
end

always_latch begin
    if (rst)
        ready = 1'b0;
    else if (count == COUNT)
        ready = 1'b1;
    else
        ready = 1'b0;
end


always_ff(posedge clk) begin
    if (rst)
        count <= 0;

    else
        count <= count_new;
end

endmodule
