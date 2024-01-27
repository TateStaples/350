module or_32(out, in);
    input [31:0] in;
    output out;
    wire w1, w2, w3, w4;
    
    or or1(w1, in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]);
    or or2(w2, in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15]);
    or or3(w3, in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23]);
    or or4(w4, in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]);

    or or5(out, w1, w2, w3, w4);
endmodule