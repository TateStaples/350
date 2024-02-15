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
    wallaceTreeMultiplier mult(.data_operandA(absA), .data_operandB(absB), .clock(clock), .data_result(out64), .data_exception(multException), .data_resultRDY(multReady));

    // Divider
    wire[31:0] divQuotient, divRemainder;
    wire divReady, divException;
    // divider div (.data_operandA(absA), .data_operandB(absB), .clock(clock), .ctrl_DIV(ctrl_DIV), .data_quotient(divQuotient), .data_remainder(divRemainder), .data_exception(divException), .data_resultRDY(divReady));

    // Control
    wire mode; //0 = multiply, 1 = divide
    dffe_ref setMode(.q(mode), .d(ctrl_DIV), .clk(clock), .en(ctrl_DIV), .clr(ctrl_MULT)); //register is 0 if mult, 1 if divide

    assign data_resultRDY = mode ? divReady : multReady;                                    // OUTPUT: select active mode

    wire [31:0] absResult, negResult;
    wire outputSign, operationException;
    mux_2 setOut(.out(absResult), .select(mode), .in0(out64[31:0]), .in1(divQuotient));   
    twos_complement twos_complement1(.out(negResult), .in(absResult));            
    xor outputSign1(outputSign, data_operandA[31], data_operandB[31]);
    assign data_result = outputSign ? negResult : absResult;                                // OUTPUT: select active result
    assign operationException = mode ? divException : multException;                         
    or operationException1(data_exception, operationException);                             // OUTPUT: select active exception
endmodule