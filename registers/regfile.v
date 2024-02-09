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
	wire [31:0] wHot, aHot, bHot, zero_out;
	// one-hot encoding
	decoder32 writeHot(.out(wHot), .select(ctrl_writeReg), .enable(1'b1));
	decoder32 readAHot(.out(aHot), .select(ctrl_readRegA), .enable(1'b1));
	decoder32 readBHot(.out(bHot), .select(ctrl_readRegB), .enable(1'b1));

	// reg 0 - hardwired to 0
	assign zero_out = 32'b0;
	tristate zero_tri1(.in(zero_out), .en(aHot[0]), .out(data_readRegA));
	tristate zero_tri2(.in(zero_out), .en(bHot[0]), .out(data_readRegB));

   genvar i;
   generate
        for (i = 1; i < 32; i = i + 1) begin: loop1
            wire[31:0] reg_out;
			wire writing;

			and andgate(writing, wHot[i], ctrl_writeEnable);

			register theReg(.q(reg_out), .d(data_writeReg), .clk(clock), .en(writing), .clr(ctrl_reset));

			//tristate of outputs
			tristate outA(.in(reg_out), .en(aHot[i]), .out(data_readRegA));
			tristate outB(.in(reg_out), .en(bHot[i]), .out(data_readRegB));
        end

   endgenerate
endmodule
