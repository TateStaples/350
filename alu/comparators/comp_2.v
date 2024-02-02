module comp_2(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [1:0] A, B;
    output EQ0, GT0;


    //notA and notB
    wire[1:0] notA, notB;

    not n1(notA[1], A[1]);
    not n2(notA[0], A[0]);
    not n3(notB[1], B[1]);
    not n4(notB[0], B[0]);

    wire [2:0] selectBits;

    assign selectBits = {A, B[1]};
    // assign selectBits[2] = A[1];
    // assign selectBits[1] = A[0];
    // assign selectBits[0] = B[1];


    wire eqmux, gtmux;
    
    mux_8bit EQout(eqmux, selectBits, notB[0], 1'b0, B[0], 1'b0, 1'b0, notB[0], 1'b0, B[0]);

    mux_8bit GTout(gtmux, selectBits, 1'b0, 1'b0, notB[0], 1'b0, 1'b1, 1'b0, 1'b1, notB[0]);


    //evaluating EQ_out
    wire EQandnotGTin, notGT1, notEQ1;

    not notGTinand(notGT1, GT1);
    not notEQinand(notEQ1, EQ1);

    wire EQ1andnotGT1forEQ0;


    and jeronimo(EQ0, eqmux, EQ1, notGT1);

    wire justin, smith;

    and jj(justin, gtmux, EQ1, notGT1);
    and ss(smith, notEQ1, GT1);

    or suckItBozo(GT0, justin, smith);

endmodule