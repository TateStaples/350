module shift_log_left_4(out, in, shift);
    // logical shift pad with zeros
    input [31:0] in;
    input shift;
    output [31:0] out;

    assign out[3:0] = shift ? 4'b0000 : in[3:0];
    assign out[31:4] = shift ? in[27:0] : in[31:4];
endmodule
