module comp_2(EQ1, GT1, A, B, EQ0, GT0);
    input EQ0, GT0;
    input [1:0] A, B;
    output EQ1, GT1;


    wire notB0, notGT, w1, w2;
    not n1(notB0, B[0]);
    not n2(notGT, GT0);
    mux_8bit m1(w1, {A, B[1]}, 'b0, 'b0, notB0, 'b0, 'b1, 'b0, 'b1, notB0);
    or o1(GT1, w1, GT0);

    // AND(EQ(i+1), NXOR(A0, B0), NXOR(A1, B1))
    mux_8bit m2(w2, {A[1], A[0], B[1]}, notB0, 'b0, B[0], 'b0, 'b0, notB0, 'b0, B[0]);
    and a1(EQ1, w2, EQ0, notGT);
endmodule