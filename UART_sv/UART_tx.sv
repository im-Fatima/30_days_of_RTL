module UART_TX #(
    parameter int DBIT = 8,
    parameter int SB_TICK = 16
)(
    input logic clk,
    input logic rst,
    input logic tx_start,
    input logic s_tick,
    input logic [DBIT-1:0] din,
    output logic tx_done,
    output logic tx
);

typedef enum logic [1:0] { ///enum assigns binary values by itself
    IDLE,
    START,
    DATA,
    STOP
} state_t;

state_t state;

logic [$clog2(SB_TICK)-1:0] s_count; //internal counter for (0-7: start), (0-15: databits)
logic [$clog2(DBIT)-1:0] b_count; //no of databits 
logic [DBIT-1:0] data_reg; //input data from testbench

always_ff @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        s_count <= '0;
        b_count <= '0;
        data_reg <= '0;
        tx_done <= 1'b0;
    end
    else
    begin
        tx_done <= 1'b0;

        case(state)

            IDLE:
            begin
                s_count <= '0;
                b_count <= '0;

                if(tx_start)
                begin
                    data_reg <= din;
                    state <= START;
                end
            end

            START:
            begin
                if(s_tick)
                begin
                    if(s_count == SB_TICK-1)
                    begin
                        s_count <= '0;
                        state <= DATA;
                    end
                    else
                        s_count <= s_count + 1'b1;
                end
            end

            DATA:
            begin
                if(s_tick)
                begin
                    if(s_count == SB_TICK-1)
                    begin
                        s_count <= '0;

                        if(b_count == DBIT-1)
                        begin
                            b_count <= '0;
                            state <= STOP;
                        end
                        else
                        begin
                            b_count <= b_count + 1'b1;
                            data_reg <= data_reg >> 1;
                        end
                    end
                    else
                        s_count <= s_count + 1'b1;
                end
            end

            STOP:
            begin
                if(s_tick)
                begin
                    if(s_count == SB_TICK-1)
                    begin
                        s_count <= '0;
                        tx_done <= 1'b1;
                        state <= IDLE;
                    end
                    else
                        s_count <= s_count + 1'b1;
                end
            end

            default:
                state <= IDLE;
        endcase
    end
end

always_comb
begin
    case(state)
        IDLE:  tx = 1'b1;
        START: tx = 1'b0;
        DATA:  tx = data_reg[0];
        STOP:  tx = 1'b1;
        default: tx = 1'b1;
    endcase
end

endmodule
