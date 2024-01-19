module two_bit_adder(S, Cout, A, B, Cin);
    input [1:0] A, B;
    input Cin;
    output [1:0] S;
    output Cout;
    
    wire w1;
    
    bit_adder fa1(S[0], w1, A[0], B[0], Cin);
    bit_adder fa2(S[1], Cout, A[1], B[1], w1);
endmodule