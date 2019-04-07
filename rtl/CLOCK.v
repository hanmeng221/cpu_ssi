module CLOCK(
    input wire clk,
    input wire resetn,
    output reg clock
    );
	
    reg [31:0] counter;
    
	always @(posedge clk or negedge resetn) begin
		if (resetn == `RstEnable) begin
			counter <= `ZeroWord;
            clock <= 1'b0;
		end else if (counter < 32'd25_000000) begin
            counter <= counter + 1'b1;
		end else begin
            counter <= `ZeroWord;
            clock <= ~clock;    
        end
	end
endmodule
