module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB; // 32 registers
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire [31:0] register [31:0];
	assign register0 = 32'b0;
	
	genvar i;
	generate  // update the register
		for (i=1; i<32; i=i+1) begin  // TODO: figure out how to use ctrl_writeReg
			register dffe_ref0(register[i], data_writeReg, clock, ctrl_writeEnable, ctrl_reset);  // q, d, clk, en, clr
		end
	endgenerate


	// read the register
	mux_32 readA(data_readRegA, ctrl_readRegA, register[0], register[1], register[2], register[3], register[4], register[5], register[6], register[7], register[8], register[9], register[10], register[11], register[12], register[13], register[14], register[15], register[16], register[17], register[18], register[19], register[20], register[21], register[22], register[23], register[24], register[25], register[26], register[27], register[28], register[29], register[30], register[31]);
	mux_32 readB(data_readRegB, ctrl_readRegB, register[0], register[1], register[2], register[3], register[4], register[5], register[6], register[7], register[8], register[9], register[10], register[11], register[12], register[13], register[14], register[15], register[16], register[17], register[18], register[19], register[20], register[21], register[22], register[23], register[24], register[25], register[26], register[27], register[28], register[29], register[30], register[31]);
endmodule
