module register64(q, d, clk, en, clr);
    input [63:0] d;
    input clk, en, clr;
    output [63:0] q;

    genvar i;
    for (i=0; i<64; i=i+1) begin
        dffe_ref flip_flop(.q(q[i]), .d(d[i]), .clk(clk), .en(en), .clr(clr));
    end
endmodule