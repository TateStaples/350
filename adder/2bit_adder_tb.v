`timescale 1 ns / 100 ps
module two_bit_adder_tb;
    reg [1:0] A, B;
    reg Cin;
    wire [1:0] S;
    wire Cout;

    two_bit_adder adder(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

    initial begin
        A = 0; B = 0; Cin = 0;
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
        #160 Cin = ~Cin;

    always @(A, B, Cin) begin
        #1;
        $display("A = %b, B = %b, Cin = %b, S = %b, Cout = %b", A, B, Cin, S, Cout);
    end

    initial begin
        $dumpfile("2bit_adder_tb.vcd");
        $dumpvars(0, two_bit_adder_tb);
    end
endmodule
