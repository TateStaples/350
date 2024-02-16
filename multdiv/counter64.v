module counter64(clock, reset, count);
    input clock, reset;
    output[5:0] count;

    T_flip_flop flop1(.toggle(1'b1), .clk(clock), .clr(reset), .Q(count[0]));
    T_flip_flop flop2(.toggle(count[0]), .clk(clock), .clr(reset), .Q(count[1]));
    T_flip_flop flop3(.toggle(count[0] & count[1]), .clk(clock), .clr(reset), .Q(count[2]));
    T_flip_flop flop4(.toggle(count[0] & count[1] & count[2]), .clk(clock), .clr(reset), .Q(count[3]));
    T_flip_flop flop5(.toggle(count[0] & count[1] & count[2] & count[3]), .clk(clock), .clr(reset), .Q(count[4]));
    T_flip_flop flop6(.toggle(count[0] & count[1] & count[2] & count[3] & count[4]), .clk(clock), .clr(reset), .Q(count[5]));
endmodule