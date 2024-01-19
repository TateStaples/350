module mux_8_tb;
    wire [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    wire [2:0] select;

    assign in0 = 32'd0;
    assign in1 = 32'd1;
    assign in2 = 32'd2;
    assign in3 = 32'd3;
    assign in4 = 32'd4;
    assign in5 = 32'd5;
    assign in6 = 32'd6;
    assign in7 = 32'd7;

    wire [31:0] out;

    mux_8 m1(out, select, in0, in1, in2, in3, in4, in5, in6, in7);

    integer i;
    assign select = i;
    initial begin 
        for (i=0; i < 8; i = i + 1) begin
            #20;
            $display("select = %d, out = %d", i, out);
        end
        $finish;
    end
endmodule