module shift_ari_right_1(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[31] = control ? 1'b1 : in[31];
    assign out[30:0] = control ? in[31:1] : in[30:0];
endmodule