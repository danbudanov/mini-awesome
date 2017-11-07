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
    //output error,
    //output channel
);

/*
 * State machine to control AVST transfer
 */

localparam STATES_NUM = 3;
localparam STATES_NUM_WIDTH = $clog2(STATES_NUM);

typedef enum logic [STATES_NUM_WIDTH-1 : 0] {
    WAIT_READY,
    WRITE,
    STALL
} avst_state_t;

avst_state_t State = WAIT_READY;

always_comb
begin
    case (State)
        WAIT:READY:
            //
    


endmodule
