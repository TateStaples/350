module shift_log_left_2(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[1:0] = control ? 2'b00 : in[1:0];
    assign out[31:2] = control ? in[29:0] : in[31:2];
endmodule