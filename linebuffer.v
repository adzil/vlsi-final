module linebuffer (clk, rst, ena, tarray, iarray, valid, xpos, ypos, mark);
    
    // Control line input
    input clk;
    input rst;
    input ena;
    
    // Output from ROM
    wire [0:0] idata;
    output [99:0] tarray;
    
    // Output from Shift register
    output [99:0] iarray;
    
    // Status line output
    output reg valid = 1'd0;
    output reg [9:0] xpos = 10'd0;
    output reg [9:0] ypos = 10'd0;
    output reg mark = 1'd1;
    
    // Addressing input to ROM
    reg [18:0] iaddr = 19'd0;
    reg [5:0] taddr = 6'd0;
    
    rom_input rom_input_inst(
        .address (iaddr),
        .clken (ena),
        .clock (clk),
        .q (idata)
    );
    
    rom_template rom_template_inst(
        .address (taddr),
        .clken (ena),
        .clock (clk),
        .q (tarray)
    );
    
    sreg_input sreg_input_inst(
        .clken (ena),
        .clock (clk),
        .shiftin (idata),
        .taps (iarray)
    );
    
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            valid <= 1'd0;
            xpos <= 10'd0;
            ypos <= 10'd0;
            iaddr <= 19'd0;
            taddr <= 6'd0;
            mark <= 1'd1;
        end
        else
        if (!ena) begin
            // Image address pointer
            if (iaddr == 19'd307199)
                iaddr <= 19'd0;
            else
                iaddr <= iaddr + 19'd1;
            
            // Template address pointer
            if (taddr == 6'd39) begin
                taddr <= 6'd0;
                mark <= 1'd1;
            end
            else begin
                taddr <= taddr + 6'd1;
                mark <= 1'd0;
            end
            
            // X and Y position locator
            if (xpos == 10'd639) begin
                xpos <= 10'd0;
                if (ypos == 10'd479)
                    ypos <= 10'd0;
                else
                    ypos <= ypos + 10'd1;
            end
            else
                xpos <= xpos + 10'd1;
            
            valid <= (xpos < 10'd40) | (ypos < 10'd100);
        end
    end

endmodule
