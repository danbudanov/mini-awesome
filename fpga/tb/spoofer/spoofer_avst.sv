/**
 * @file spoofer_avst.sv
 * @author Daniil Budanov
 * @brief an AVST wrapper for the spoofer module
 * */

module spoofer_avst
#(
    parameter DATA_WIDTH = 32;
)
(
    input clk, rst,

    input ready,

    output valid,
    output logic [DATA_WIDTH-1 : 0] data
);

logic read_signal;
logic [DATA_WIDTH-1 : 0] data_signal;


/*
 * State machine to control AVST transfer
 */

localparam STATES_NUM = 2;
localparam STATES_NUM_WIDTH = $clog2(STATES_NUM);

typedef enum logic [STATES_NUM_WIDTH-1 : 0] {
    WAIT_READY,
    WRITE
    //STALL
} avst_state_t;

avst_state_t State = WAIT_READY;
avst_state_t NextState = WAIT_READY;

always_ff @(posedge clk)
begin
    if (rst) begin
        State <= WAIT_READY;
    end else begin
        State <= NextState;
    end

    // Get counter data
    data <= data_signal;

end


always_comb
begin
    case (State)
        WAIT_READY: begin
            read_signal = 1'b1;
            NextState = (ready) ? WRITE : WAIT_READY;
            valid = 1'b0;
        end
        WRITE: begin
            read_signal = 1'b0;
            NextState = WAIT_READY; // Can later implement continuous streaming
            valid = 1'b1;
        end
        /*
        STALL: begin
            read_signal = 1'b0;
        end
        */
    endcase
end
            
spoofer_counter spoofer_counter_inst
(
    .rst(rst),
    .clk(clk),
    .read_signal(read_signal),
    .count_out(data_signal)
);
    
endmodule
