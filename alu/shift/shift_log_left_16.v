module shift_log_left_16(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[15:0] = control ? 16'b0000000000000000 : in[15:0];
    assign out[31:16] = control ? in[15:0] : in[31:16];
endmodule