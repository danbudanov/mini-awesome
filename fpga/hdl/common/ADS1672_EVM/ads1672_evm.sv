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
        START_END:   begin
            start <= 1'b0;
            drdy  <= 1'b1;
        end
        START_END:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        START_END:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        START_END:   begin
            start <= 1'b0;
            drdy  <= 1'b0;
        end
        START_END:   begin
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
            NextState <= START_END;
        START_END:  
            NextState <= DRDY;
        DRDY:  
            NextState <= DRDY_END;
        DRDY_END:  
            NextState <= SCLOCK_START;
        SCLOCK_START:  
            NextState <= FIRST_BIT;
        FIRST_BIT:  
            NextState <= NEXT_BIT;
        NEXT_BIT:  
            NextState <= NEXT_BIT_2;
        START:  
            NextState <= START_END;


    endcase
end


endmodule
