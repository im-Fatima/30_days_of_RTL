module UART #(
    parameter int CLK_FREQ = 50_000_000,
    parameter int BAUD_RATE = 19200,
    parameter int OVERSAMPLE = 16,
    parameter int DBIT = 8,
    parameter int SB_TICK = 16
)(
    input logic clk,
    input logic rst,
    input logic tx_start,
    input logic rx,
    input logic [DBIT-1:0] tx_data,
    output logic tx,
    output logic [DBIT-1:0] rx_data,
    output logic tx_done,
    output logic rx_done
);

logic s_tick;

baud_rate_generator #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE),
    .OVERSAMPLE(OVERSAMPLE)
) baud_gen (
    .clk(clk),
    .reset(rst),
    .s_tick(s_tick)
);

UART_TX #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK)
) transmitter (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .s_tick(s_tick),
    .din(tx_data),
    .tx_done(tx_done),
    .tx(tx)
);

UART_RX #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK)
) receiver (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .s_tick(s_tick),
    .rx_done(rx_done),
    .dout(rx_data)
);

endmodule
