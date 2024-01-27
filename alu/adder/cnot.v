module cnot(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    // Flip the bits with XOR gate
    xor xor0(out[0], in[0], control);
    xor xor1(out[1], in[1], control);
    xor xor2(out[2], in[2], control);
    xor xor3(out[3], in[3], control);
    xor xor4(out[4], in[4], control);
    xor xor5(out[5], in[5], control);
    xor xor6(out[6], in[6], control);
    xor xor7(out[7], in[7], control);
    xor xor8(out[8], in[8], control);
    xor xor9(out[9], in[9], control);
    xor xor10(out[10], in[10], control);
    xor xor11(out[11], in[11], control);
    xor xor12(out[12], in[12], control);
    xor xor13(out[13], in[13], control);
    xor xor14(out[14], in[14], control);
    xor xor15(out[15], in[15], control);
    xor xor16(out[16], in[16], control);
    xor xor17(out[17], in[17], control);
    xor xor18(out[18], in[18], control);
    xor xor19(out[19], in[19], control);
    xor xor20(out[20], in[20], control);
    xor xor21(out[21], in[21], control);
    xor xor22(out[22], in[22], control);
    xor xor23(out[23], in[23], control);
    xor xor24(out[24], in[24], control);
    xor xor25(out[25], in[25], control);
    xor xor26(out[26], in[26], control);
    xor xor27(out[27], in[27], control);
    xor xor28(out[28], in[28], control);
    xor xor29(out[29], in[29], control);
    xor xor30(out[30], in[30], control);
    xor xor31(out[31], in[31], control);
endmodule