module abs(out, in);
    input [31:0] in;
    output [31:0] out;

    wire [31:0] complement;
    twos_complement twos_complement(.out(complement), .in(in));
    assign out = in[31] ? complement : in;
endmodule