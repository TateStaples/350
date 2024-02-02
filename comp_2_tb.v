`timescale 1 ns / 100 ps
module two_bit_adder_tb;
    reg [1:0] A, B;
    reg EQ0, GT0;
    wire EQ1, GT1;

    comp_2 c1(.EQ1(EQ1), .GT1(GT1), .A(A), .B(B), .EQ0(EQ0), .GT0(GT0));

    initial begin
        A = 0; B = 0; EQ0 = 0; GT0 = 0;
        #320; $finish;
    end

    always 
        #10 A[0] = ~A[0];
    always 
        #20 A[1] = ~A[1];
    always
        #40 B[0] = ~B[0];
    always
        #80 B[1] = ~B[1];
    always
        #160 EQ0 = ~EQ0;
    always
        #320 GT0 = ~GT0;

    always @(A, B, Cin) begin
        #1;
        $display("A = %b, B = %b, EQ0 = %b, GT0 = %b, EQ1 = %b, GT1 = %b", A, B, EQ0, GT0, EQ1, GT1);
    end

    initial begin
        $dumpfile("comp_2_tb.vcd");
        $dumpvars(0, comp_2_tb);
    end
endmodule