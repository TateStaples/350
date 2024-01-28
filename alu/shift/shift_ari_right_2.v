module shift_ari_right_2(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[31:30] = control ? {2{in[31]}} : in[31:30];
    assign out[29:0] = control ? in[31:2] : in[29:0];
endmodule