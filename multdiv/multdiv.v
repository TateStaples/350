module multdiv(
	data_operandA, data_operandB, // inputs
	ctrl_MULT, ctrl_DIV, // Operation control
	clock, 
	data_result, data_exception, data_resultRDY  // outputs
    );

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] absA, absB;
    abs absA1(absA, data_operandA);
    abs absB1(absB, data_operandB);

    // add your code here TODO: FIX the interfaces for mult and div to match, good coding practice
    // Multiplier
    wire[63:0] out64;
    wire multReady, multException;
    wallaceTreeMultiplier mult(.data_operandA(absA), .data_operandB(absB), .clock(clock), .data_result(out64), .data_exception(multException), .data_resultRDY(multReady), .reset(ctrl_DIV | mode));

    // Divider
    wire[31:0] divQuotient, divRemainder;
    wire divReady, divException;
    divider div (.data_operandA(absA), .data_operandB(absB), .clock(clock), .reset(ctrl_MULT), .data_quotient(divQuotient), .data_remainder(divRemainder), .data_exception(divException), .data_resultRDY(divReady));

    // Control
    wire mode, weirdCase;
    dffe_ref setMode(.q(mode), .d(ctrl_DIV), .clk(clock), .en(ctrl_DIV), .clr(ctrl_MULT));  // 0 = multiply, 1 = divide

    wire [31:0] absResult, negResult;
    wire outputSign, operationException; 
    assign absResult = mode ? divQuotient : out64[31:0];                                    
    twos_complement twos_complement1(.out(negResult), .in(absResult));            
    xor outputSign1(outputSign, data_operandA[31], data_operandB[31]);
    assign weirdCase = (data_operandA[31] ^ data_operandB[31]) ^ data_result[31];
    assign data_result = outputSign ? negResult : absResult;                                // OUTPUT: select active result
    assign data_exception = mode ? divException : (multException | weirdCase) & |data_operandA & |data_operandB;                            // OUTPUT: select active exception
    assign data_resultRDY = divReady || multReady;                                    // OUTPUT: select active mode
endmodule