module mux_4_tb;
    wire [31:0] in0, in1, in2, in3;
    wire [1:0] select;

    assign in0 = 32'd0;
    assign in1 = 32'd1;
    assign in2 = 32'd2;
    assign in3 = 32'd3;

    wire [31:0] out;

    mux_4 m1(out, select, in0, in1, in2, in3);

    integer i;
    assign select = i;
    initial begin 
        for (i=0; i < 4; i = i + 1) begin
            #20;
            $display("select = %d, out = %d", i, out);
        end
        $finish;
    end
endmodule