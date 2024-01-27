module shift_logical_right(out, in, shift);
    // arith shift pad with ones
    input [31:0] in;
    input [4:0] shift;
    output [31:0] out;

    wire [31:0] w1, w2, w3, w4;

    shift_log_left_1 s1(w1, in, shift[0]);
    shift_log_left_2 s2(w2, w1, shift[1]);
    shift_log_left_4 s3(w3, w2, shift[2]);
    shift_log_left_8 s4(w4, w3, shift[3]);
    shift_log_left_16 s5(out, w4, shift[4]);
endmodule