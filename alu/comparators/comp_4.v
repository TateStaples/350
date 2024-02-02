module comp_4(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [3:0] A, B;
    output EQ0, GT0;

    wire  eq, gt;
    comp_2 c1(eq, gt, A[3:2], B[3:2], EQ0, GT0);
    comp_2 c2(EQ1, GT1, A[1:0], B[1:0], eq, gt);
endmodule