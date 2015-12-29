`timescale 1 ns/100 ps

module processor_array_tb;

    reg clk;
    reg rst;
    reg ena;
    
    wire [9:0] xpos;
    wire [9:0] ypos;
    
    processor_array dut (clk, rst, ena, xpos, ypos);
    
    initial begin
        clk <= 1'd1;
        rst <= 1'd0;
        ena <= 1'd1;
        #85
        rst <= 1'd1;
        #125
        ena <= 1'd0;
    end
    
    always begin
        #20
        clk <= !clk;
    end

endmodule
