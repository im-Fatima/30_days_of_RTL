module UART_RX #(
    parameter int DBIT = 8,
    parameter int SB_TICK = 16
)(
    input logic clk,
    input logic rst,
    input logic rx,
    input logic s_tick,
    output logic rx_done,
    output logic [DBIT-1:0] dout
);

typedef enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;

state_t state;

logic [$clog2(SB_TICK)-1:0] s_count; //goes 0-7 for start; 0 to 15 for data bit
logic [$clog2(DBIT)-1:0] b_count; //tracks the number of databits
logic [DBIT-1:0] data_reg;

always_ff @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        s_count <= '0;
        b_count <= '0;
        data_reg <= '0;
        rx_done <= 1'b0;
    end
    else
    begin
        rx_done <= 1'b0;

        case(state)

            IDLE:
            begin
                s_count <= '0;
                b_count <= '0;

                if(!rx)
                begin
                    state <= START;
                end
            end

            START:
            begin
                if(s_tick)
                begin
                    if(s_count == 7)
                    begin
                        s_count <= '0;
                        b_count <= '0;
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
                        data_reg <= {rx,data_reg[DBIT-1:1]};

                        if(b_count == DBIT-1)
                        begin
                            b_count <= '0;
                            state <= STOP;
                        end
                        else
                            b_count <= b_count + 1'b1;
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
                        rx_done <= 1'b1;
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
    dout = data_reg;
end

endmodule
