module shift_ari_right_16(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[31:16] = control ? 16'b1111111111111111 : in[31:16];
    assign out[15:0] = control ? in[31:16] : in[15:0];
endmodule