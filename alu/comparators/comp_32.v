module comp_32(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [31:0] A, B;
    output EQ0, GT0;

    wire eq, gt;
    comp_16 c1(EQ1, GT1, A[31:16], B[31:16], eq, gt);
    comp_16 c2(eq, gt, A[15:0], B[15:0], EQ0, GT0);
endmodule