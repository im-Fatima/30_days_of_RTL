module UART_TB;

logic clk;
logic rst;
logic tx_start;
logic rx;
logic [7:0] tx_data;
logic tx;
logic [7:0] rx_data;
logic tx_done;
logic rx_done;

UART #(
    .CLK_FREQ(100),
    .BAUD_RATE(10),
    .OVERSAMPLE(2),
    .DBIT(8),
    .SB_TICK(16)
) dut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .rx(rx),
    .tx_data(tx_data),
    .tx(tx),
    .rx_data(rx_data),
    .tx_done(tx_done),
    .rx_done(rx_done)
);

assign rx = tx;

always #10 clk = ~clk;

initial
begin
    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'b0;

    #100;
    rst = 0;

    #100;
    tx_data = 8'b10101010;
    tx_start = 1;

    #20;
    tx_start = 0;

    wait(rx_done);

    #20;

    if(rx_data == tx_data)
        $display("UART TEST PASSED");
    else
        $display("UART TEST FAILED");

    #100;
    $finish;
end

endmodule
