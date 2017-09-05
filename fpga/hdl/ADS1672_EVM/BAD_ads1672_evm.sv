module ads1672_evm
(
    input clk, rst,

    output clkx, // Serial transmit clock from processor (jumped to clkr)
    input clkr,  // Serial receive clock from ADC (jumped to clkx)
    output fsx, // frame sync signal from processor
    input fsr, // frame sync return to processor, src from drdy_n

    input drr, // input data into processor
    input drdy_n, // data ready interrupt source to processor
    output logic start, // general purpose pin toggles start

);

localparam DATA_WIDTH = 24;
localparam DATA_WIDTH_WIDTH = $clog2(DATA_WIDTH)

typedef enum logic [2 : 0] {
    START,
    START_END,
    DRDY,
    DRDY_END,
    SCLOCK_START,
    FIRST_BIT,
    NEXT_BIT,
    NEXT_BIT_2,
    } reading_stage;

reading_stage State, NextState;
logic [DATA_WIDTH] data;
logic [DATA_WIDTH_WIDTH] data_ct;

/*
* State sequencer
*/
always_ff (posedge clk)
begin
    if (rst) begin
        State <= START;
    end else begin
        State <= NextState;
    end
end

/*
* Data Counter
*/
always_ff (posedge clk)
begin
    case(State)

        START        : data_ct <= 0;
        START_END    : data_ct <= 0;
        DRDY         : data_ct <= 0;
        DRDY_END     : data_ct <= 0;
        SCLOCK_START : data_ct <= 0;
        default      : data_ct <= data_ct + 1;
end


/**
* Output decoder
*/
always_comb
begin
    case (State)
        START:  begin
            start <= 1'b1;
            drdy  <= 1'b0;
        end
        START_END:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        DRDY:   begin
            start <= 1'b0;
            drdy  <= 1'b1;
        end
        DRDY_END:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        SCLOCK_START: begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        FIRST_BIT:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        NEXT_BIT:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        START_END:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end

    endcase
end 

/**
* Next state logic
*/
always_comb
begin
    case (State) 
        START:
            NextState = START_END;
        START_END:  
            NextState = DRDY;
        DRDY:  
            NextState = DRDY_END;
        DRDY_END:  
            NextState = SCLOCK_START;
        SCLOCK_START:  
            NextState = FIRST_BIT;
        FIRST_BIT:  
            NextState = NEXT_BIT;
        NEXT_BIT:  
            NextState = NEXT_BIT_2;
        START:  
            NextState = START_END;


    endcase
end


endmodule
