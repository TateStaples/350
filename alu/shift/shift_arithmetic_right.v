module shift_arithmetic_right(out, in, shift);
    // arith shift pad with ones
    input [31:0] in;
    input [4:0] shift;
    output [31:0] out;

    wire [31:0] shift_1, shift_2, shift_4, shift_8;

    shift_ari_right_1 s1(shift_1, in, shift[0]);
    shift_ari_right_2 s2(shift_2, shift_1, shift[1]);
    shift_ari_right_4 s3(shift_4, shift_2, shift[2]);
    shift_ari_right_8 s4(shift_8, shift_4, shift[3]);
    shift_ari_right_16 s5(out, shift_8, shift[4]);
endmodule