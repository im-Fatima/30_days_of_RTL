module baud_rate_generator #(
    parameter int CLK_FREQ = 50000000,
    parameter int BAUD_RATE = 19200,
    parameter int OVERSAMPLE = 16
)(
    input  logic clk,
    input  logic reset,
    output logic s_tick
);

    localparam int DIVISOR = CLK_FREQ / (BAUD_RATE * OVERSAMPLE); //clk freq/sampling freq

    localparam int COUNT_WIDTH = $clog2(DIVISOR); //clog2 finds the no of bits to represent a number

    logic [COUNT_WIDTH-1:0] count;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            count <= 0;
            s_tick  <= 1'b0;
        end

        else begin

            if (count == DIVISOR-1) begin
                count <= 0;
                s_tick  <= 1'b1;
            end

            else begin
                count <= count + 1'b1;
                s_tick  <= 1'b0;
            end

        end
    end

endmodule