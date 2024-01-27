module bitwise_or_8(out, num1, num2);
    input [7:0] num1, num2;
    output [7:0] out;

    or or1(out[0], num1[0], num2[0]);
    or or2(out[1], num1[1], num2[1]);
    or or3(out[2], num1[2], num2[2]);
    or or4(out[3], num1[3], num2[3]);
    or or5(out[4], num1[4], num2[4]);
    or or6(out[5], num1[5], num2[5]);
    or or7(out[6], num1[6], num2[6]);
    or or8(out[7], num1[7], num2[7]);
endmodule