module cla_8(out, Pblock, Gblock, A, B, carry_in);
    input [7:0] A, B;
    input carry_in;
    output [7:0] out;
    output Pblock, Gblock;

    wire [7:0] P, G, carry;
    bitwise_and_8 and1(G, A, B);
    bitwise_or_8 or1(P, A, B);
    propagate_generate_block pgb(P, G, Pblock, Gblock);
    look_ahead la(carry, P, G, carry_in);

    xor xor1(out[0], A[0], B[0], carry[0]);
    xor xor2(out[1], A[1], B[1], carry[1]);
    xor xor3(out[2], A[2], B[2], carry[2]);
    xor xor4(out[3], A[3], B[3], carry[3]);
    xor xor5(out[4], A[4], B[4], carry[4]);
    xor xor6(out[5], A[5], B[5], carry[5]);
    xor xor7(out[6], A[6], B[6], carry[6]);
    xor xor8(out[7], A[7], B[7], carry[7]);
endmodule

module look_ahead(C, P, G, cin);
    input [7:0] P, G;
    input cin;
    output [7:0] C;

    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28;
    assign C[0] = cin;
    and a1(w1, cin, P[0]);
    or o1(C[1], G[0], w1);

    and a2(w2, cin, P[0], P[1]);
    and a3(w3, G[0], P[1]);
    or o2(C[2], G[1], w2, w3);

    and a4(w4, cin, P[0], P[1], P[2]);
    and a5(w5, G[0], P[1], P[2]);
    and a6(w6, G[1], P[2]);
    or o3(C[3], G[2], w4, w5, w6);

    and a7(w7, cin, P[0], P[1], P[2], P[3]);
    and a8(w8, G[0], P[1], P[2], P[3]);
    and a9(w9, G[1], P[2], P[3]);
    and a10(w10, G[2], P[3]);
    or o4(C[4], G[3], w7, w8, w9, w10);

    and a11(w11, cin, P[0], P[1], P[2], P[3], P[4]);
    and a12(w12, G[0], P[1], P[2], P[3], P[4]);
    and a13(w13, G[1], P[2], P[3], P[4]);
    and a14(w14, G[2], P[3], P[4]);
    and a15(w15, G[3], P[4]);
    or o5(C[5], G[4], w11, w12, w13, w14, w15);

    and a16(w16, cin, P[0], P[1], P[2], P[3], P[4], P[5]);
    and a17(w17, G[0], P[1], P[2], P[3], P[4], P[5]);
    and a18(w18, G[1], P[2], P[3], P[4], P[5]);
    and a19(w19, G[2], P[3], P[4], P[5]);
    and a20(w20, G[3], P[4], P[5]);
    and a21(w21, G[4], P[5]);
    or o6(C[6], G[5], w16, w17, w18, w19, w20, w21);

    and a22(w22, cin, P[0], P[1], P[2], P[3], P[4], P[5], P[6]);
    and a23(w23, G[0], P[1], P[2], P[3], P[4], P[5], P[6]);
    and a24(w24, G[1], P[2], P[3], P[4], P[5], P[6]);
    and a25(w25, G[2], P[3], P[4], P[5], P[6]);
    and a26(w26, G[3], P[4], P[5], P[6]);
    and a27(w27, G[4], P[5], P[6]);
    and a28(w28, G[5], P[6]);
    or o7(C[7], G[6], w22, w23, w24, w25, w26, w27, w28);
endmodule

module propagate_generate_block(p, g, P, G);
    input [7:0] p, g;
    output P, G;

    wire w1, w2, w3, w4, w5, w6, w7;
    and a1(P, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);

    and a2(w1, p[7], g[6]);
    and a3(w2, p[7], p[6], g[5]);
    and a4(w3, p[7], p[6], p[5], g[4]);
    and a5(w4, p[7], p[6], p[5], p[4], g[3]);
    and a6(w5, p[7], p[6], p[5], p[4], p[3], g[2]);
    and a7(w6, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and jonas(w7, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);

    or o1(G, w1, w2, w3, w4, w5, w6, w7, g[7]);
endmodule