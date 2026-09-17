`timescale 1ns / 1ps
module tb_full_8;
    reg [7:0] a;
    reg [7:0] b;
    reg       add_sub;
    wire [7:0] sum;
    wire       cout;
    wire       OF;
    integer error_count = 0;
    full_8 dut (
        .a(a),
        .b(b),
        .add_sub(add_sub),
        .sum(sum),
        .cout(cout),
        .OF(OF)
    );

    // Self-checking k liye
    task check_result;
        input [7:0] in_a;
        input [7:0] in_b;
        input       in_mode; // 0 = add, 1 = sub
        
        reg [8:0] expected_extended;
        reg [7:0] expected_sum;
        reg       expected_cout;
        reg       expected_of;
        reg [7:0] b_operand;

        begin
            a = in_a;
            b = in_b;
            add_sub = in_mode;
            #10;
            b_operand = in_mode ? ~in_b : in_b;
            expected_extended = in_a + b_operand + in_mode;
            expected_sum = expected_extended[7:0];
            expected_cout = expected_extended[8];
            expected_of = (in_a[7] & b_operand[7] & ~expected_sum[7]) |
                          (~in_a[7] & ~b_operand[7] & expected_sum[7]);
            if ((sum !== expected_sum) || (cout !== expected_cout) || (OF !== expected_of)) begin
                $display("[FAIL] Mode: %s | A = %0d (0x%0h), B = %0d (0x%0h)", 
                         in_mode ? "SUB" : "ADD", in_a, in_a, in_b, in_b);
                $display("       Expected: sum = 0x%0h, cout = %b, OF = %b", 
                         expected_sum, expected_cout, expected_of);
                $display("       Got:      sum = 0x%0h, cout = %b, OF = %b", 
                         sum, cout, OF);
                error_count = error_count + 1;
            end
        end
    endtask
    initial begin
        $display("Starting Tests ");
        check_result(8'd127, 8'd1,   1'b0); 
        check_result(8'd255, 8'd1,   1'b0); 
        check_result(8'h05,  8'h03,  1'b0); // Test checks from manual
        check_result(8'h0A,  8'h04,   1'b1); 
        check_result(8'hFF,   8'h01,  1'b0); 
        check_result(8'h80,  8'h01,   1'b1); 	
        check_result(8'd127, 8'hFF,  1'b1); 
        if (error_count == 0) begin
            $display("--- ALL TESTS PASSED SUCCESSFULLY ---");
        end else begin
            $display("COMPLETED WITH %0d ERRORS", error_count);
        end
      $finish;
    end
endmodule
