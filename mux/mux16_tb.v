module mux_16_tb;
    wire [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
    wire [3:0] select;

    assign in0 = 32'd0;
    assign in1 = 32'd1;
    assign in2 = 32'd2;
    assign in3 = 32'd3;
    assign in4 = 32'd4;
    assign in5 = 32'd5;
    assign in6 = 32'd6;
    assign in7 = 32'd7;
    assign in8 = 32'd8;
    assign in9 = 32'd9;
    assign in10 = 32'd10;
    assign in11 = 32'd11;
    assign in12 = 32'd12;
    assign in13 = 32'd13;
    assign in14 = 32'd14;
    assign in15 = 32'd15;

    wire [31:0] out;

    mux_16 m1(out, select, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15);

    integer i;
    assign select = i;
    initial begin 
        for (i=0; i < 16; i = i + 1) begin
            #20;
            $display("select = %d, out = %d", i, out);
        end
        $finish;
    end
endmodule