module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;  // extra ADD/SUB outputs TODO: implement isNotEqual

    wire [31:0] sum, AND, OR, SLL, SRA, updated_operandB;
    wire carry_in, carry_out, w1, w2, w3, w4, w5;
    // sections of the ALU
    cnot sub_flip(updated_operandB, data_operandB, ctrl_ALUopcode[0]);
    assign carry_in = ctrl_ALUopcode[0];
    carry_look_ahead_adder adder(data_operandA, updated_operandB, carry_in, carry_out, sum);
    bitwise_and_32 and1(data_operandA, data_operandB, AND);
    bitwise_or_32 or1(data_operandA, data_operandB, OR);
    shift_logical_right srl(SLL, data_operandA, ctrl_shiftamt);
    shift_arithmetic_right sra(SRA, data_operandA, ctrl_shiftamt);

    // mux to select the output
    mux_8 mux1(data_result, ctrl_ALUopcode[2:0], sum, sum, AND, OR, SLL, SRA, data_operandA, data_operandB);

    // overflow detection - same signs of operands and change in sum sign
    xor xor1(w1, data_operandA[31], updated_operandB[31]);
    xor xor2(w2, sum[31], data_operandA[31]);
    assign overflow = w1 ? 1'b0 : w2;

    // extra info for ADD/SUB
    xor diff(w3, data_operandA[31], data_operandB[31]);
    assign isLessThan = diff ? data_operandA[31] : sum[31];
    or_32 or2(w3, sum);
    or ne(isNotEqual, w3, overflow);
endmodule