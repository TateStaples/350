module T_flip_flop (toggle, clk, clr, Q);
    input toggle; // input
    input clock, clr; // control
    output Q; // output

    wire D;
    assign D_in = T ? ~Q : Q;

    dffe_ref myFavoriteStorageFridge(.q(Q), .d(D_in), .clk(clock), .en(1'b1), .clr(clr));
endmodule