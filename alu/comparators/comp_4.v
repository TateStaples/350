module comp_4(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [3:0] A, B;
    output EQ0, GT0;

    wire  eq, gt;
    comp_2 c1(EQ1, GT1. A[3:2], B[3:2], eq, gt);
    comp_2 c2(eq, gt, A[1:0], B[1:0], EQ0, GT0);
endmodule