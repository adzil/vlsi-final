module processor(iarray, tarray, mark, clk, rst, ena, tout, markout, sign);

    input [99:0] iarray;
    input [99:0] tarray;
    input mark;
    input clk;
    input rst;
    input ena;
    
    output reg [99:0] tout = 100'd0;
    output reg markout = 1'd0;
    output reg sign = 1'd0;
    
    reg [8:0] result = 9'd0;
    
    wire [99:0] xcorr;
    wire [7:0] adder;
    wire adder_next;
    
    assign xcorr = iarray ^ tarray;
    assign adder_next = !result[8];
    
    treeadder treeadder_inst(
        .din (xcorr),
        .dout (adder)
    );
    
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            tout <= 100'd0;
            markout <= 1'd0;
            sign <= 1'd0;
            result <= 9'd0;
        end
        else
        if (!ena) begin
            tout <= tarray;
            markout <= mark;
            
            if (mark) begin
                if (adder_next)
                    sign <= 1'd1;
                else
                    sign <= 1'd0;
                
                result <= {1'd0, adder};
            end
            else begin
                if (adder_next)
                    result <= result + adder;
                else
                    result <= result;
                    
                sign <= 1'd0;
            end
        end
    end

endmodule
