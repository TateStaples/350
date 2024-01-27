module carry_look_ahead_adder(num1, num2, carry_in, carry_out, sum);
    input [31:0] num1, num2;
    input carry_in;
    output carry_out;
    output [31:0] sum;

    wire P0, G0, P1, G1, P2, G2, P3, G3, P4, G4;
    wire c8, c16, c24;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
    cla_8 block1(sum[7:0], P0, G0, num1[7:0], num2[7:0], carry_in);
    and a1(w1, carry_in, P0);
    or o1(c8, G0, w1);
    cla_8 block2(sum[15:8], P1, G1, num1[15:8], num2[15:8], c8);
    and a2(w2, carry_in, P0, P1);
    and a3(w3, G0, P1);
    or o2(c16, G1, w2, w3);
    cla_8 block3(sum[23:16], P2, G2, num1[23:16], num2[23:16], c16);
    and a4(w4, carry_in, P0, P1, P2);
    and a5(w5, G0, P1, P2);
    and a6(w6, G1, P2);
    or o3(c24, G2, w4, w5, w6);
    cla_8 block4(sum[31:24], P3, G3, num1[31:24], num2[31:24], c24);
    and a7(w7, carry_in, P0, P1, P2, P3);
    and a8(w8, G0, P1, P2, P3);
    and a9(w9, G1, P2, P3);
    and a10(w10, G2, P3);
    or o4(carry_out, G3, w7, w8, w9, w10);
endmodule