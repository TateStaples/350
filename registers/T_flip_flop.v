module T_flip_flop (toggle, clk, clr, Q);
    input toggle; // input
    input clk, clr; // control
    output Q; // output

    wire D;
    assign D = toggle ? ~Q : Q;

    dffe_ref myFavoriteStorageFridge(.q(Q), .d(D), .clk(clk), .en(1'b1), .clr(clr));
endmodule