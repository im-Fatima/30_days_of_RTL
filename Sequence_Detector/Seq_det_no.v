//1001 Non-overlapping Sequence Detector Moore
// S0(start) -> S1(1) ->S2(10) ->S3(100) ->S4(1001)
module seq_det_no(
input clk, rst, data,
output reg y);

//states
parameter [2:0] S0 = 3'b000;
parameter [2:0] S1 = 3'b001;
parameter [2:0] S2 = 3'b010;
parameter [2:0] S3 = 3'b011;
parameter [2:0] S4 = 3'b100;

reg [2:0] state, next_state;

always @(posedge clk or posedge rst) begin
if(rst) 
state <= S0;
else
state <= next_state;
end

//next_logic
always @(state or data) begin

case(state)

S0: begin
if(data==1)
next_state = S1;
else 
next_state = S0;
end

S1: begin
if(data==0)
next_state = S2;
else 
next_state = S1;
end

S2: begin
if(data==0)
next_state = S3;
else 
next_state = S0;
end

S3: begin
if(data==1)
next_state = S4;
else 
next_state = S0;
end

S4: begin
next_state = S0;
end

default: 
next_state = S0;
endcase
end

//output logic
always @(state) begin
if(state == S4)
 y = 1'b1;
else
 y = 1'b0;
end
endmodule









 