module comp_16(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [15:0] A, B;
    output EQ0, GT0;

    wire eq, gt;
    comp_8 c1(EQ1, GT1, A[15:8], B[15:8], eq, gt);
    comp_8 c2(eq, gt, A[7:0], B[7:0], EQ0, GT0);
endmodule