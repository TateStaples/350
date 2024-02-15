module twos_complement(out, in);
    input [31:0] in;
    output [31:0] out;
    wire overflow;

    // 2s complement
    carry_look_ahead_adder add(.num1(32'b0), .num2(~in), .carry_in(1'b1), .carry_out(overflow), .sum(out));
endmodule