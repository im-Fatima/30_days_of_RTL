module full_8(
    input [7:0] a, b,
    input add_sub,
    output [7:0] sum,
    output cout,
    output OF
);
wire [7:0] b_mod;
wire [8:0] carry;
assign carry[0] = add_sub;
assign b_mod = add_sub ? ~b : b;
fulladder FA0(a[0], b_mod[0], carry[0], sum[0], carry[1]);
fulladder FA1(a[1], b_mod[1], carry[1], sum[1], carry[2]);
fulladder FA2(a[2], b_mod[2], carry[2], sum[2], carry[3]);
fulladder FA3(a[3], b_mod[3], carry[3], sum[3], carry[4]);
fulladder FA4(a[4], b_mod[4], carry[4], sum[4], carry[5]);
fulladder FA5(a[5], b_mod[5], carry[5], sum[5], carry[6]);
fulladder FA6(a[6], b_mod[6], carry[6], sum[6], carry[7]);
fulladder FA7(a[7], b_mod[7], carry[7], sum[7], carry[8]);
assign cout = carry[8];
assign OF = (a[7] & b_mod[7] & ~sum[7]) | (~a[7] & ~b_mod[7] & sum[7]);

endmodule
