`timescale 1ns/1ps

module seq_det_tb;

reg clk, rst, data;
wire y;

reg [3:0] history;
reg expected_y;

seq_det_no dut(
.clk(clk),
.rst(rst),
.data(data),
.y(y)
);

//timeperiod 10ns
always #5 clk = ~clk;

task send_bit;
input bit;
begin
@(negedge clk);
data = bit;
@(posedge clk);
history = {history[2:0], bit};
if (history == 4'b1001)
expected_y = 1'b1;
else
expected_y = 1'b0;

if(y == expected_y)
$display("TEST PASSED data = %b | expected output = %b | output = %b", history, expected_y, y);
else
$display("TEST FAILED data = %b | expected output = %b | output = %b", history, expected_y, y);
end
endtask

//give inputs
initial begin

clk = 0;
rst = 1;
data = 0;
history = 4'b0000;

#10;
rst = 0;
#10;

//1000
send_bit(1);
send_bit(0);
send_bit(0);
send_bit(1);

//1101
send_bit(1);
send_bit(1);
send_bit(0);
send_bit(1);

//1001
send_bit(1);
send_bit(0);
send_bit(0);
send_bit(1);

//0111
send_bit(1);
send_bit(0);
send_bit(0);
send_bit(1);

$stop;
end
endmodule 


