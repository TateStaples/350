module shift_ari_right_4(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[31:28] = control ? {4{in[31]}} : in[31:28];
    assign out[27:0] = control ? in[31:4] : in[27:0];
endmodule