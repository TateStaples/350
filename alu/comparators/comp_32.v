module comp_32(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [31:0] A, B;
    output EQ0, GT0;

    wire eq, gt;
    comp_16 c1(eq, gt, A[31:16], B[31:16], EQ0, GT0);
    comp_16 c2(EQ1, GT1, A[15:0], B[15:0], eq, gt);
endmodule