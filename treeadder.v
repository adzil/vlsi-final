/*
	-- Calculate the SAD value of a colomn
	
	
*/

module treeadder(din, dout);
    /* Parameter definition */
	localparam NDATA = 128;
	localparam NDATA_IN = 100;
    localparam NDATA_LOG = $clog2(NDATA);
    
    /* Input/output definition */
    input [NDATA_IN-1:0] din;
    output [NDATA_LOG:0] dout;

   	/* Wire/register declaration */
    wire [NDATA-1:0] buffer = {din[NDATA_IN-1:0], {(NDATA-NDATA_IN){1'd0}}};
	
    /* Generator definition */
    genvar i,x;
    generate
        // Iterate to Log2(N) binary tree adder
        for(i=1; i<NDATA_LOG;i = i+1) begin: Add
            // Get the number of adder in one level
            localparam j = (NDATA >> i);
            // Create new data wire
            wire [i:0] data [0:j-1];

            for(x=0; x<j; x = x + 1) begin: Adder
                localparam nx = x*2;
                if (i == 1)
                    // Wiring from input wire
                    assign Add[i].data[x] = buffer[nx:nx] + buffer[nx+1:nx+1];
                else
                    // Wiring from last data wire
                    assign Add[i].data[x] = Add[i-1].data[nx] + Add[i-1].data[nx+1];
            end
        end

        // Wire output to the last data wire
        assign dout = Add[NDATA_LOG-1].data[0] + Add[NDATA_LOG-1].data[1];
    endgenerate
    
endmodule
