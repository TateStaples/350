module divider(
    data_operandA, data_operandB, // inputs: (positive numbers)
    clock, reset, // control
    data_quotient, data_remainder, data_exception, data_resultRDY);  // outputs
    
    parameter DIV_SIZE = 32;
    input [DIV_SIZE-1:0] data_operandA, data_operandB;
    input clock;
    input reset; 

    output [DIV_SIZE-1:0] data_quotient, data_remainder;
    output data_exception, data_resultRDY;
    wire [$clog2(DIV_SIZE):0] count;
    wire[2*DIV_SIZE-1:0] R, R_out, R_init, R_in, result; 


    counter64 counter1(.clock(clock), .reset(reset), .count(count));
    
    // always @(posedge clock) begin
        // if (reset) $display("Reset activated at time %t\n", $time);
        // $display("A = %d, B = %d, Q = %d, rdy? = %b, mod = %d, c = %d,\nR \t= %b, \ninit \t= %b, \nin \t= %b, \nshft\t= %b,\nout \t= %b, \nres \t= %b\n",
                // data_operandA, data_operandB, data_quotient, data_resultRDY, data_remainder, count, R, R_init, R_in, shifted, R_out, result);
        // $display("A = %d, B = %d, Q = %d, rdy? = %b, mod = %d, c = %d,\nR \t= %b, \ninit \t= %b, \nin \t= %b, \nshft\t= %b,\nout \t= %b, \nres \t= %b\n",
                // data_operandA, data_operandB, data_quotient, data_resultRDY, data_remainder, count, R, R_init, R_in, shifted, R_out, result);
    // end
    assign R_init[2*DIV_SIZE-1:DIV_SIZE] = 32'b0; 
    assign R_init[DIV_SIZE-1:0] = data_operandA[DIV_SIZE-1:0];   // Quotient
    assign R_in = reset ? R_init : R_out;
    register64 reg1(.q(R), .d(R_in), .clk(clock), .en(1'b1)); // takes 1 cycle to set out.
    // Key: R = remainder, Q = quotient, D = divisor
    wire [31:0] D, negD, activeD;
    assign D = data_operandB;
    twos_complement twos_complement1(.out(negD), .in(D));

    // set MSB and choose divisor
    wire MSB;
    assign MSB = R[2*DIV_SIZE-1];
    assign activeD = MSB ? D : negD;
    // left-shift 1
    wire[2*DIV_SIZE-1:0] shifted;
    assign shifted = R << 1;
    // add shifted to chosen divisor
    carry_look_ahead_adder adder1(.num1(shifted[2*DIV_SIZE-1:DIV_SIZE]), .num2(activeD), .carry_in(1'b0), .carry_out(), .sum(R_out[2*DIV_SIZE-1:DIV_SIZE]));
    // assign bottom 32 bits + set last bit
    assign R_out[DIV_SIZE-1:1] = shifted[DIV_SIZE-1:1];
    assign R_out[0] = ~R_out[2*DIV_SIZE-1];
    
    // outputs
    wire t33;
    assign t33 = count[5] & ~count[4] & ~count[3] & ~count[2] & ~count[1] & ~count[0];
    assign data_resultRDY = t33;
    register64 reg2(.q(result), .d(R_in), .clk(clock), .en(1'b1), .clr(reset));

    wire[DIV_SIZE-1:0] restore, unrestore;
    assign unrestore = result[2*DIV_SIZE-1:DIV_SIZE];
    carry_look_ahead_adder adder2(.sum(restore), .num1(result[2*DIV_SIZE-1:DIV_SIZE]), .num2(D), .carry_in(1'b0), .carry_out());
    assign data_quotient = (data_exception) ? 32'b0 : result[DIV_SIZE-1:0];
    assign data_remainder = result[63] ? restore : unrestore;
    assign data_exception = ~(|data_operandB); 
endmodule