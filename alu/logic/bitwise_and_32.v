module bitwise_and_32(num1, num2, out);
    input [31:0] num1, num2;
    output [31:0] out;

    // add your code here:
    and a1(out[0], num1[0], num2[0]);
    and a2(out[1], num1[1], num2[1]);
    and a3(out[2], num1[2], num2[2]);
    and a4(out[3], num1[3], num2[3]);
    and a5(out[4], num1[4], num2[4]);
    and a6(out[5], num1[5], num2[5]);
    and a7(out[6], num1[6], num2[6]);
    and a8(out[7], num1[7], num2[7]);
    and a9(out[8], num1[8], num2[8]);
    and a10(out[9], num1[9], num2[9]);
    and a11(out[10], num1[10], num2[10]);
    and a12(out[11], num1[11], num2[11]);
    and a13(out[12], num1[12], num2[12]);
    and a14(out[13], num1[13], num2[13]);
    and a15(out[14], num1[14], num2[14]);
    and a16(out[15], num1[15], num2[15]);
    and a17(out[16], num1[16], num2[16]);
    and a18(out[17], num1[17], num2[17]);
    and a19(out[18], num1[18], num2[18]);
    and a20(out[19], num1[19], num2[19]);
    and a21(out[20], num1[20], num2[20]);
    and a22(out[21], num1[21], num2[21]);
    and a23(out[22], num1[22], num2[22]);
    and a24(out[23], num1[23], num2[23]);
    and a25(out[24], num1[24], num2[24]);
    and a26(out[25], num1[25], num2[25]);
    and a27(out[26], num1[26], num2[26]);
    and a28(out[27], num1[27], num2[27]);
    and a29(out[28], num1[28], num2[28]);
    and a30(out[29], num1[29], num2[29]);
    and a31(out[30], num1[30], num2[30]);
    and a32(out[31], num1[31], num2[31]);
endmodule