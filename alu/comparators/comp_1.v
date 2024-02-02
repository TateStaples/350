module comp_1(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input A, B;
    output EQ0, GT0;

    wire w1, w2, w3, w4;

    xnor x1(w1, A, B);
    and a1(EQ1, w1, EQ0);

    assign w2 = B ? b'0 : A;
    or o1(GT1, GT0, w2);
endmodule
