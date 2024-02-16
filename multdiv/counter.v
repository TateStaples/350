module counter(clock, reset, count);
    input clock, reset;
    output[5:0] count;

    wire[5:0] binit;

    T_flip_flop numberOne(.T(1'b1), .clock(clock), .reset(reset), .Q(count[0]), .notQ(binit[0]));
    T_flip_flop numberTwo(.T(count[0]), .clock(clock), .reset(reset), .Q(count[1]), .notQ(binit[1]));
    T_flip_flop numberThree (.T(count[0] & count[1]), .clock(clock), .reset(reset), .Q(count[2]), .notQ(binit[2]));
    T_flip_flop numberFour (.T(count[0] & count[1] & count[2]), .clock(clock), .reset(reset), .Q(count[3]), .notQ(binit[3]));
    T_flip_flop numberFive (.T(count[0] & count[1] & count[2] & count[3]), .clock(clock), .reset(reset), .Q(count[4]), .notQ(binit[4]));
    T_flip_flop numberSix (.T(count[0] & count[1] & count[2] & count[3] & count[4]), .clock(clock), .reset(reset), .Q(count[5]), .notQ(binit[5]));
endmodule