module shift_log_left_8(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[7:0] = control ? 8'b00000000 : in[7:0];
    assign out[31:8] = control ? in[23:0] : in[31:8];
endmodule
