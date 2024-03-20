/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
 // Bypass (overwrite latches) XM/MW -> ALU_A (ALU, addi, lw), XM/MW -> ALU_B (ALU_A + jr), MW -> MEM (sw)
 // Sometimes add nop to avoid hazards. Special case for $r0
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem (instruction)

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem (data)
    wren,                           // O: Write enable for dmem (data)
    q_dmem,                         // I: The data from dmem (data)

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    wire [31:0] new_instruction, D_PC, D_PC_in, X_PC, M_PC, W_PC, D_instr, D_instr_in, F_instr, X_instr_in, X_instr_out, M_instr, W_instr, D_A, D_B, X_A, X_B, M_D, M_B, W_D, W_out, ALU_out, multdiv_out, X_out;
    // Latch holds: A, B, instruction
    // ------ latches ------ //
    // PC latch 
    wire [31:0] PC, PC_init, next_instr, increment, set_PC, active_PC;
    wire w1;
    assign PC_init = 32'd0;
    assign increment = conditional_branch ? conditional_increment : 32'd0;  // Allow for relative branching
    assign active_PC = conditional_branch ? X_PC : address_imem;
    carry_look_ahead_adder PCadder(.num1(active_PC), .num2(increment), .sum(next_instr), .carry_in(1'b1), .carry_out(w1));
    assign set_PC = jumping ? jump_destination : next_instr;
    register PC_reg(.clk(~clock), .d(set_PC), .q(PC), .en(~stall), .clr(reset)); 
    // PC latch
    register FD_PC(.clk(~clock), .d(PC), .q(D_PC_in), .en(~stall), .clr(reset));  // TODO: add nop here sometimes (bubbles)
    assign D_PC = (hazard | flush) ? 32'b0 : D_PC_in;
    register DX_PC(.clk(~clock), .d(D_PC), .q(X_PC), .en(~stall), .clr(reset));
    register XM_PC(.clk(~clock), .d(X_PC), .q(M_PC), .en(~stall), .clr(reset)); 
    register MW_PC(.clk(~clock), .d(M_PC), .q(W_PC), .en(~stall), .clr(reset));
    // Instruction latch
    assign F_instr = (hazard | flush) ? 32'b0 : q_imem;
    register FD_instr(.clk(~clock), .d(F_instr), .q(D_instr_in), .en(~stall), .clr(reset));
    assign D_instr = (hazard | flush) ? 32'b0 : D_instr_in;
    register DX_instr(.clk(~clock), .d(D_instr), .q(X_instr_in), .en(~stall), .clr(reset));
    register XM_instr(.clk(~clock), .d(X_instr_out), .q(M_instr), .en(~stall), .clr(reset));
    register MW_instr(.clk(~clock), .d(M_instr), .q(W_instr), .en(~stall), .clr(reset));

    // Data latch
    register DX_A(.clk(~clock), .d(D_A), .q(X_A), .en(~stall), .clr(reset));
    register DX_B(.clk(~clock), .d(D_B), .q(X_B), .en(~stall), .clr(reset));
    register XM_data(.clk(~clock), .d(X_out), .q(M_D), .en(~stall), .clr(reset));
    register XM_B(.clk(~clock), .d(BypassedX_B), .q(M_B), .en(~stall), .clr(reset));
    register MW_Res(.clk(~clock), .d(W_D), .q(W_out), .en(~stall), .clr(reset));
    // ------ fetch (F) ------ //
    assign address_imem = reset ? PC_init : PC;
    assign new_instruction = q_imem;
    // ------ decode (D) ------ //
    // R type: Opcode [31:27], Dest [26:22], A [21:17], B [16:12], shiftamt [11:7], ALUop [6:2], Zeros [1:0]
    // I type: Opcode [31:27], Dest [26:22], A [21:17], Immediate [16:0]
    // J1 type: Opcode [31:27], Target [26:0]
    // J2 type: Opcode [31:27], RD [26:22]
    wire isJalD, isSwD, isDivD, hazard;
    get_instr get_instrD(.opcode(D_instr[31:27]), .ALU_opcode(D_instr[6:2]), .isJal(isJalD), .isSw(isSwD), .isDiv(isDivD));
    instruction_registers instr_regs(.instr(D_instr), .regA(ctrl_readRegA), .regB(ctrl_readRegB));  // O: Register to read from ports A&B of RegFile
    assign D_A = isJalD ? D_PC  : data_readRegA;                                                    // I: Data from port A of RegFile
    assign D_B = isJalD ? 32'd1 : data_readRegB;                                                    // I: Data from port B of RegFile
    // hazard = LOAD && (overwrite directory)
    assign hazard = (X_instr_in[31:27] === 5'b01000) && ((ctrl_readRegA === X_writeback_reg && X_writeback_reg != 5'b0 && X_will_writeback) || (ctrl_readRegB === X_writeback_reg && ~isSwD && X_writeback_reg != 5'b0 && X_will_writeback));
    // ------ execute (X) ------ //
    // add  00000 (00000)  R add $rd, $rs, $rt    $rd = $rs + $rt
    // addi 00101          I addi $rd, $rs, N     $rd = $rs + N
    // sub  00000 (00001)  R sub $rd, $rs, $rt    $rd = $rs - $rt
    // and  00000 (00010)  R and $rd, $rs, $rt    $rd = $rs AND $rt
    // or   00000 (00011)  R or $rd, $rs, $rt     $rd = $rs OR $rt
    // sll  00000 (00100)  R sll $rd, $rs, shamt  $rd = $rs << shamt
    // sra  00000 (00101)  R sra $rd, $rs, shamt  $rd = $rs / 2^shamt
    wire isLessThan, isNotEqual, overflow, R_typeX;  // Used for branch instructions and overflow detection
    wire isAddX, isAddiX, isSubX, isAndX, IsOrX, isSllX, isSraX, isMulX, isDivX, isSwX, isLwX, isJX, isBneX, isJalX, isJrX, isBltX, isBexX, isSetxX;
    wire [31:0] target_J1, immediate_I;
    get_instr get_instrX(.opcode(X_instr_in[31:27]), .ALU_opcode(X_instr_in[6:2]), .isAdd(isAddX), .isAddi(isAddiX), .isSub(isSubX), .isAnd(isAndX), .IsOr(IsOrX), .isSll(isSllX), .isSra(isSraX), .isMul(isMulX), .isDiv(isDivX), .isSw(isSwX), .isLw(isLwX), .isJ(isJX), .isBne(isBneX), .isJal(isJalX), .isJr(isJrX), .isBlt(isBltX), .isBex(isBexX), .isSetx(isSetxX));
    get_type get_typeX(.opcode(X_instr_in[31:27]), .isR(R_typeX));
    
    assign immediate_I = {{15{X_instr_in[16]}}, X_instr_in[16:0]};
    assign target_J1 = {{5'b0}, X_instr_in[26:0]};

    wire [31:0] ALU_A, ALU_B, BypassedX_A, BypassedX_B;
    wire [4:0] ALU_opcode, regA_X, regB_X, regB_M, M_writeback_reg, X_writeback_reg;
    wire bypassMX_A, bypassMX_B, bypassWX_A, bypassWX_B, M_will_writeback, X_will_writeback;
    instruction_registers instr_regsM(.instr(M_instr), .regB(regB_M), .writeback_reg(M_writeback_reg), .will_writeback(M_will_writeback));
    instruction_registers instr_regsX(.instr(X_instr_in), .regA(regA_X), .regB(regB_X), .writeback_reg(X_writeback_reg), .will_writeback(X_will_writeback)); 
    // TODO: add the bypasses here [MX, WX], I think this should only be registers, TODO: hazard if isLW_M
    assign bypassWX_A = (ctrl_writeEnable & regA_X === ctrl_writeReg & regA_X != 5'b0);
    assign bypassWX_B = (ctrl_writeEnable & regB_X === ctrl_writeReg & regB_X != 5'b0);
    assign bypassMX_A = (M_will_writeback & regA_X === M_writeback_reg & regA_X != 5'b0);
    assign bypassMX_B = (M_will_writeback & regB_X === M_writeback_reg & regB_X != 5'b0);
    assign BypassedX_A = bypassMX_A ? M_D : (bypassWX_A ? data_writeReg: X_A);
    assign BypassedX_B = bypassMX_B ? M_D : (bypassWX_B ? data_writeReg: X_B);
    assign ALU_A = BypassedX_A;  
    assign ALU_B = (isSwX | isLwX | isAddiX) ? immediate_I : BypassedX_B;  // MUX with immediate selection
    assign ALU_opcode = R_typeX ? X_instr_in[6:2] : 5'b0;
    alu ALU(.data_operandA(ALU_A), .data_operandB(ALU_B), .ctrl_ALUopcode(ALU_opcode), .ctrl_shiftamt(X_instr_in[11:7]), .data_result(ALU_out), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(overflow));

    // multdiv
    // mul  00000 (00110)  R mul $rd, W_$rs, $rt    $rd = $rs * $rt (32b X 32b);
    // div  00000 (00111)  R div $rd, $rs, $rt    $rd = $rs / $rt (32b ÷ 32b);
    wire multdiv_exception, mult, div, is_multdiv, multdiv_RDY, stall;
    wire [31:0] m_A, m_B;
    pulse_generator mult_pulse(.clk(clock), .in_signal(isMulX), .out_pulse(mult));
    pulse_generator div_pulse(.clk(clock), .in_signal(isDivX), .out_pulse(div));
    assign is_multdiv = isMulX | isDivX;
    multdiv multdivUnit(.data_operandA(BypassedX_A), .data_operandB(BypassedX_B), .ctrl_MULT(mult), .ctrl_DIV(div), .data_result(multdiv_out), .data_exception(multdiv_exception), .data_resultRDY(multdiv_RDY), .clock(clock));
    assign stall = isDivX & !multdiv_RDY & !multdiv_exception; 

    wire [31:0] X_out_math, X_out_branch, X_out_exception, X_instr_branch, X_instr_exception;
    assign X_out_math = is_multdiv ? multdiv_out : ALU_out;

    // Branching! - flush to previous
    wire flush, conditional_branch, jump_to_target, jump_to_register, jumping;
    wire [31:0] conditional_increment, jump_target_destination, jump_register_destination, jump_destination, jal_instr;

    assign flush = conditional_branch | jump_to_target | jump_to_register;
    assign jumping = jump_to_target | jump_to_register;
    assign jump_destination = jump_to_target ? jump_target_destination : jump_register_destination;
    // bne  00010          I bne $rd, $rs,        N if($rd != $rs) PC = PC+1+N
    // blt  00110          I blt $rd, $rs,        N if($rd < $rs) PC=PC+1+N
    assign conditional_branch = (isBneX && isNotEqual) | (isBltX && isLessThan);
    assign conditional_increment = immediate_I;

    // j    00001          J1 j N                 PC = N
    // jal  00011          J1 jal N               $r31 = PC+1; PC=N 
    assign jump_to_target = isJX | isJalX | (isBexX && isNotEqual);
    assign jump_target_destination = target_J1;
    // Write current PC to $r31
    assign jal_instr = {5'b0, 5'b11111, 22'd0};  // The PC+1 is in the ALU_out
    assign X_instr_branch = isJalX ? jal_instr : X_instr_in;

    // jr   00100          J2 jr $rd              PC = $rd
    assign jump_to_register = isJrX;
    assign jump_register_destination = X_A; 


    // Exception! - replace with write error to $r30 (error ALU and Multdiv)
    wire exception;
    wire [31:0] exception_instruction, exception_data;  // exception_instruction should be something with writeback (R type-add), set RD to 30, set X_out
    assign exception = (multdiv_exception && is_multdiv) | (overflow && (X_instr_in[31:27] == 5'b0 | isAddiX)); 
    assign exception_instruction = {5'b0, 5'b11110, 22'd0}; // setX instruction addi $r30, 0, 0
    assign X_instr_exception = (isSetxX | exception) ? exception_instruction : X_instr_branch;
    // add overflow = 1, addi overflow = 2, sub overflow = 3, mult overflow = 4, div exception = 5
    assign X_out_exception = exception ? (isAddX ? 32'd1 : (isAddiX ? 32'd2 : (isSubX ? 32'd3 : (isMulX ? 32'd4 : 32'd5)))) : target_J1;

    // final output details (setx 10101, rstatus = target)
    wire [31:0] setx_instr;
    assign setx_instr = {5'b0, 5'b11110, 22'd0};
    assign X_out = (exception | isSetxX) ? X_out_exception : X_out_math;
    assign X_instr_out = X_instr_exception;
    // ------ memory (M) ------ //
    // sw OPCODE=00111 TYPE=I USAGE="sw $rd, N($rs)" RESULT="MEM[$rs + N] = $rd" 
    // lw OPCODE=01000 TYPE=I USAGE="lw $rd, N($rs)" RESULT="$rd = MEM[$rs + N]"
    wire isSW_M, isLW_M, isDivM, bypassWM;
    get_instr get_instrM(.opcode(M_instr[31:27]), .ALU_opcode(M_instr[6:2]), .isSw(isSW_M), .isLw(isLW_M), .isDiv(isDivM));
    assign address_dmem = M_D;                          // O: The address of the data to get or put from/to dmem
    // TODO: add the WM bypasses here
    assign bypassWM = (ctrl_writeEnable && (regB_M === ctrl_writeReg) && (regB_M !== 5'b0));
    assign data = bypassWM ? data_writeReg : M_B;       // O: The data to write to dmem (data) [WM bypass]
    assign wren = isSW_M;                               // O: Write enable for dmem (data)
    assign W_D = isLW_M ? q_dmem : M_D;                 // I: The data from dmem (data)
    // ------ writeback ------ // 
    // WriteEnable = add + addi + lw
    wire [4:0] opcode_W;
    assign opcode_W = W_instr[31:27];
    assign ctrl_writeEnable = (opcode_W == 5'b0) | (opcode_W == 5'b00101) | (opcode_W == 5'b01000); // O: Write enable for RegFile TODO: figure out multdiv hazard
    assign ctrl_writeReg = W_instr[26:22];    // O: Register to write to in RegFile
    assign data_writeReg = W_out;             // O: Data to write to for RegFile
endmodule

module get_type(opcode, isI, isR, isJ1, isJ2); 
    input [4:0] opcode;
    output isI;
    output isR;
    output isJ1;
    output isJ2;
    assign isI = (opcode == 5'b00101) | (opcode == 5'b00111) | (opcode == 5'b01000) | (opcode == 5'b00010) | (opcode == 5'b00110);
    assign isR = (opcode == 5'b00000);
    assign isJ1 = (opcode == 5'b00001) | (opcode == 5'b00011) | (opcode == 5'b10110) | (opcode == 5'b10101);
    assign isJ2 = (opcode == 5'b00100);
endmodule

module get_instr(opcode, ALU_opcode, isAdd, isAddi, isSub, isAnd, IsOr, isSll, isSra, isMul, isDiv, isSw, isLw,  isJ, isBne, isJal, isJr, isBlt, isBex, isSetx);
    input [4:0] opcode, ALU_opcode;
    output isAdd;
    output isAddi;
    output isSub;
    output isAnd;
    output IsOr;
    output isSll;
    output isSra;
    output isMul;
    output isDiv;
    output isBne;
    output isBlt;
    output isJ;
    output isJal;
    output isJr;
    output isSw;
    output isLw;
    output isSetx;
    output isBex;
    assign isAdd = (opcode == 5'b0) & (ALU_opcode == 5'b00000);
    assign isAddi = (opcode == 5'b00101);
    assign isSub = (opcode == 5'b0) & (ALU_opcode == 5'b00001);
    assign isAnd = (opcode == 5'b0) & (ALU_opcode == 5'b00010);
    assign IsOr = (opcode == 5'b0) & (ALU_opcode == 5'b00011);
    assign isSll = (opcode == 5'b0) & (ALU_opcode == 5'b00100);
    assign isSra = (opcode == 5'b0) & (ALU_opcode == 5'b00101);
    assign isMul = (opcode == 5'b0) & (ALU_opcode == 5'b00110);
    assign isDiv = (opcode == 5'b0) & (ALU_opcode == 5'b00111);
    assign isBne = (opcode == 5'b00010);
    assign isBlt = (opcode == 5'b00110);
    assign isJ = (opcode == 5'b00001);
    assign isJal = (opcode == 5'b00011);
    assign isJr = (opcode == 5'b00100);
    assign isSw = (opcode == 5'b00111);
    assign isLw = (opcode == 5'b01000);
    assign isSetx = (opcode == 5'b10101);
    assign isBex = (opcode == 5'b10110);
endmodule


module pulse_generator (
    input wire clk,       // Clock input
    input wire in_signal, // Input signal
    output wire out_pulse // Output pulse
);
    wire q1, q2;
    dffe_ref dff1 (
        .clk(clk),
        .d(in_signal),
        .q(q1),
        .en(1'b1),
        .clr(1'b0)
    );
    
    // Instantiating the second D Flip-Flop (delays the signal by one clock cycle)
    dffe_ref dff2 (
        .clk(clk),
        .d(q1),
        .q(q2),
        .en(1'b1),
        .clr(1'b0)
    );
    
    // AND gate to generate the pulse
    assign out_pulse = q1 & ~q2;
endmodule


module instruction_registers(instr, regA, regB, writeback_reg, will_writeback);
    input [31:0] instr;
    output [4:0] regA, regB, writeback_reg;
    output will_writeback;

    wire R_typeR, isAddR, isAddiR, isSubR, isAndR, IsOrR, isSllR, isSraR, isMulR, isDivR, isSwR, isLwR, isJR, isBneR, isJalR, isJrR, isBltR, isBexR, isSetxR;
    wire [4:0] RD, RS, RT, RStatus, R0, Rreturn;

    get_type get_typeD(.opcode(instr[31:27]), .isR(R_typeR));
    get_instr get_instrR(.opcode(instr[31:27]), .ALU_opcode(instr[6:2]), .isAdd(isAddR), .isAddi(isAddiR), .isSub(isSubR), .isAnd(isAndR), .IsOr(IsOrR), .isSll(isSllR), .isSra(isSraR), .isMul(isMulR), .isDiv(isDivR), .isSw(isSwR), .isLw(isLwR), .isJ(isJR), .isBne(isBneR), .isJal(isJalR), .isJr(isJrR), .isBlt(isBltR), .isBex(isBexR), .isSetx(isSetxR));
    
    assign RD = instr[26:22];
    assign RS = instr[21:17];
    assign RT = instr[16:12];
    assign RStatus = 5'b11110;
    assign Rreturn = 5'b11111;
    assign R0 = 5'b00000;

    assign regA = (isBneR | isBltR | isJrR) ? RD : (isBexR ? RStatus : RS); 
    assign regB = R_typeR ? RT : ((isBneR | isBltR) ? RS : (isSwR ? RD : R0));

    assign writeback_reg = (R_typeR | isAddiR | isLwR) ? RD : (isJalR ? Rreturn : RStatus);
    assign will_writeback = (R_typeR | isAddiR | isLwR | isJalR | isSetxR);
endmodule