module UART_TB_FINAL;

logic clk, rst;
logic rx, tx;
logic rx_done, tx_done;
logic [7:0] tx_data, rx_data;
logic tx_start;


UART #(
.CLK_FREQ(100),
.BAUD_RATE(10),
.OVERSAMPLE(2),
.DBIT(8),
.SB_TICK(16) //for 1, 1.5, 2 stopbit, we have 16,24 and 32
) DUT (
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

initial begin
clk = 0;
rst = 1;
tx_start = 0;
tx_data = 0;

#100;
rst = 0;

#100;
tx_start = 1;
tx_data = 8'b 10101101;

#20;
tx_start = 0;

wait(rx_done);

if (rx_data == tx_data)
 $display("TEST PASSED");
else
 $display("TEST FAILED");

#100;
$finish;

end
endmodule

