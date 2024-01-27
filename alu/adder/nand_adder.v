module nand_adder(S, Cout, A, B, Cin);
    input A, B, Cin;
    output S, Cout;

    wire w1, w2, w3, w4, w5, w6, w7;
    
    nand n1(w1, A, B);  // L1
    nand n2(w2, w1, A); // L2
    nand n3(w3, w1, B);
    nand n4(w4, w2, w3); // L3
    nand n5(w5, w4, Cin); // L4
    nand n6(w6, w4, w5); // L5
    nand n7(w7, w5, Cin);
    nand n8(S, w6, w7); // L6
    nand n9(Cout, w5, w1);
endmodule