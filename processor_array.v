module processor_array(clk, rst, ena, xpos, ypos);

    input clk;
    input rst;
    input ena;
    
    output reg [9:0] xpos;
    output reg [9:0] ypos;

    wire [99:0] iarray;
    wire [4099:0] tarray;
    wire [40:0] mark;
    wire valid;
    wire [39:0] sign;
    wire [9:0] xcpos;
    wire [9:0] ycpos;
    wire [10:0] xminpos;
    wire [10:0] yminpos;
    
    assign xminpos = {1'd0, xcpos} - 11'd40;
    assign yminpos = {1'd0, ycpos} - 11'd100;
    
    linebuffer linebuffer_inst (
        .clk (clk),
        .rst (rst),
        .ena (ena),
        .tarray (tarray[0 +: 100]),
        .iarray (iarray),
        .valid (valid),
        .xpos (xcpos),
        .ypos (ycpos),
        .mark (mark[0])
    );
    
    genvar i;
    generate
        for (i = 0; i < 40; i = i + 1) begin: processor_array_inst
            processor inst (
                .iarray (iarray),
                .tarray (tarray[i*100 +: 100]),
                .mark (mark[i]),
                .clk (clk),
                .rst (rst),
                .ena (ena),
                .tout (tarray[(i+1)*100 +: 100]),
                .markout (mark[i+1]),
                .sign (sign[i])
            );
        end
    endgenerate
    
    // Check for sign
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            xpos <= 10'd0;
            ypos <= 10'd0;
        end
        else
        if (!ena) begin
            if ((sign != 40'd0) & valid) begin
                xpos <= xminpos[9:0];
                ypos <= yminpos[9:0];
            end
            else begin
                xpos <= xpos;
                ypos <= ypos;
            end
        end
    end

endmodule
