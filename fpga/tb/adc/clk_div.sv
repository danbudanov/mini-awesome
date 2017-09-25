module clk_div
#(
    parameter CLK_DIV_CT = 5,
    parameter CLK_DIV_CT_WIDTH = $clog2(CLK_DIV_CT)
)
(
    input logic clk, rst, 
    output logic clk_out
);

localparam CLK_DIV_TOGGLE = CLK_DIV_CT - 1;

logic [CLK_DIV_CT_WIDTH-1 : 0] counter = 0;
logic [CLK_DIV_CT_WIDTH-1 : 0] new_counter;

assign new_counter = (counter < CLK_DIV_TOGGLE) ? counter + 1 : '0;

always_ff @(posedge clk)
begin
    if (rst) begin
        counter <= '0;
        clk_out <= 0;
    end else begin
        if (counter == CLK_DIV_TOGGLE)
            clk_out <= !clk_out;
        counter <= new_counter;
    end
end

endmodule /* clk_div */
