module mux_2_tb;
    wire [31:0] in0, in1;
    wire select;

    assign in0 = 32'd0;
    assign in1 = 32'd1;

    wire [31:0] out;

    mux_2 m1(out, select, in0, in1);

    integer i;
    assign select = i;
    initial begin 
        for (i=0; i < 2; i = i + 1) begin
            #20;
            $display("select = %d, out = %d", i, out);
        end
        $finish;
    end
endmodule