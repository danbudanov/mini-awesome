module clk_div
#(
    parameter CLK_DIV_CT = 10,
    parameter CLK_DIV_CT_HALF = CLK_DIV_CT / 2,
    parameter CLK_DIV_CT_WIDTH = $clog2(CLK_DIV_CT)
)
(
    input logic clk, rst, 
    output logic clk_out
);

logic [CLK_DIV_CT_WIDTH-1 : 0] counter = 0;
logic [CLK_DIV_CT_WIDTH-1 : 0] new_counter;

assign new_counter = counter + 1;
assign clk_out = (counter > CLK_DIV_CT_HALF) ? 1'b1 : 1'b0;



always_ff @(posedge clk)
begin
    if (rst) 
        counter <= '0;
    else
        counter <= new_counter;
end

endmodule /* clk_div */
