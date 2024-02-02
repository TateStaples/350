`timescale 1 ns / 100 ps
module comp_2_tb;
    wire [7:0] A, B;
    wire EQ1, GT1;
    wire EQ0, GT0;

    comp_8 c1(.EQ1(EQ1), .GT1(GT1), .A(A), .B(B), .EQ0(EQ0), .GT0(GT0));

    integer i;
    assign {A, B, EQ1, GT1} = i;


    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            #20;
            $display("A = %b, B = %b, EQ0 = %b, GT0 = %b, EQ1 = %b, GT1 = %b", A, B, EQ0, GT0, EQ1, GT1);
        end
        $finish;
    end

    initial begin
        $dumpfile("comp_2_tb.vcd");
        $dumpvars(0, comp_2_tb);
    end
endmodule