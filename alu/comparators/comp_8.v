module comp_8(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [7:0] A, B;
    output EQ0, GT0;

    wire eq, gt;
    comp_4 c1(eq, gt, A[7:4], B[7:4], EQ0, GT0);
    comp_4 c2(EQ1, GT1, A[3:0], B[3:0], eq, gt);
endmodule