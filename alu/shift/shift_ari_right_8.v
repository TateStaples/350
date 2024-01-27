module shift_ari_right_8(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[31:24] = control ? 8'b11111111 : in[31:24];
    assign out[23:0] = control ? in[31:8] : in[23:0];
endmodule