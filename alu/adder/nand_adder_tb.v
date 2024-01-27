`timescale 1 ns / 100 ps
module nand_adder_tb;
    reg A, B, Cin;
    wire S, Cout;

    nand_adder adder(.S(S), .Cout(Cout), .A(A), .B(B), .Cin(Cin));

    initial begin
        A = 0; B = 0; Cin = 0;
        #80; $finish;
    end

    always 
        #10 A = ~A;
    always 
        #20 B = ~B;
    always
        #40 Cin = ~Cin;

    always @(A, B, Cin) begin
        #1;
        $display("A = %b, B = %b, Cin = %b, S = %b, Cout = %b", A, B, Cin, S, Cout);
    end

    initial begin
        $dumpfile("nand_adder_tb.vcd");
        $dumpvars(0, nand_adder_tb);
    end

endmodule
