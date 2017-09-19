/**
* @file ADS1672_EVM.sv
* @author Daniil Budanov
* @brief Controller for the TI ADS1672-EVM ADC Breakout Board
*
* NOTE: Assume the Internal SCLK configuration (SCLK_SEL=0) is used
*/
module ads1672_evm
#(
    parameter DATA_WIDTH = 24
)
(
    input clk, rst,

    input measure, // pulse indicating the start of measuring

    output clkx, // Serial transmit clock from processor (jumped to clkr)
    input clkr,  // Serial receive clock from ADC (jumped to clkx)
    output fsx,  // frame sync signal from processor
    input fsr,   // frame sync return to processor, src from drdy_n

    input drr,    // input data into processor
    input drdy_n, // data ready interrupt source to processor
    output logic start, // general purpose pin toggles start
    output logic [DATA_WIDTH-1 : 0] data_out // output data reading
);

localparam DATA_WIDTH_WIDTH = $clog2(DATA_WIDTH);
localparam STATES_NUM = 6;
localparam STATES_NUM_WIDTH = $clog2(STATES_NUM);

typedef enum logic [STATES_NUM_WIDTH-1 : 0] {
    WAIT, // Wait for the read to be requested
    START, // Emit the start output signal
    START_END, // End the start output signal
    FIRST_BIT, // Read in the first bit
    NEXT_BIT, // Read in proceeding bits
    DONE // Output the data value read in from ADC
} reading_state_t;

reading_state_t State = WAIT;
reading_state_t NextState = WAIT;
logic [DATA_WIDTH-1 : 0] data; // Buffer that the bits are clocked into
logic [DATA_WIDTH_WIDTH-1 : 0] data_ct, data_ct_new; // Track the bits read in

/**
* Clock being output to ADC
*/
assign clkx = clk;

/**
* State sequencer
*/
always_ff @(posedge clk)
begin : STATE_SEQUENCER
    if (rst) begin
        State   <= WAIT;
        data_ct <= '0;
    end else begin
        State   <= NextState;
        data_ct <= data_ct_new;
    end
end

/**
* Data Counter
*/
always_comb
begin : DATA_COUNTER
    case(State)
        FIRST_BIT : data_ct_new = data_ct + 1;
        NEXT_BIT  : data_ct_new = data_ct + 1;
        default   : data_ct_new = 0;
    endcase
end


/**
* Output decoder
*/
always_comb
begin : START_DECODER
    case (State)
        START   : start <= 1'b1;
        default : start <= 1'b0;
    endcase
end 

/**
* Next state logic
*/
always_comb
begin : NEXT_STATE
    case (State) 
        WAIT :
            NextState = (measure) ? START : WAIT;
        START :
            NextState = START_END;
        START_END :  
            NextState = (drdy_n) ? START_END : FIRST_BIT;
        FIRST_BIT : // Continue on to the next bit 
            NextState = NEXT_BIT;
        NEXT_BIT : // if bits are full, go to done state
            NextState = (data_ct_new == DATA_WIDTH) ? DONE : NEXT_BIT;
        DONE :  
            NextState = WAIT;
        default:
            NextState = WAIT;
    endcase
end

/**
* If read is complete, output the calculated value
*/
always_ff @(posedge clk)
begin : OUTPUT_DATA
    if (State == DONE)
        data_out <= data;
    else
        data_out <= data_out;
end

/**
* If in a writing state, set the bit of data corresponding to the count
*/
always_ff @(posedge clk)
begin : WRITE_DATA
    //if ( (State == FIRST_BIT) || (State == NEXT_BIT) ) begin
    if ( (NextState == DONE) || (State == NEXT_BIT) ) begin
        // Note: data is clocked in MSB first
        data[DATA_WIDTH - 1 - data_ct] <= drr;
    //end else begin 
        //data[DATA_WIDTH - 1 - data_ct] <= data[DATA_WIDTH - 1 - data_ct];
    end
end

endmodule
