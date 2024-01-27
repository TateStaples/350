module shift_log_left_1(out, in, control);
    input [31:0] in;
    input control;
    output [31:0] out;

    assign out[0] = control ? 'b0 : in[0];
    assign out[31:1] = control ? in[30:0] : in[31:1];
endmodule