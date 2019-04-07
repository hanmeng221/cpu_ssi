`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:02:00 03/11/2019 
// Design Name: 
// Module Name:    REG 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module REG(
    input wire [4:0] raddr1,
    input wire [4:0] raddr2,
    input wire clk,
    input wire resetn,
    input wire wreg,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    output reg [31:0] rdata1,
    output reg [31:0] rdata2
    );

	reg[31:0] regs[0:31];
	initial begin
			regs[0] <= 32'b0;
			regs[1] <= 32'b0;
			regs[2] <= 32'b0;
			regs[3] <= 32'b0;
			regs[4] <= 32'b0;
			regs[5] <= 32'b0;
			regs[6] <= 32'b0;
			regs[7] <= 32'b0;
			regs[8] <= 32'b0;
			regs[9] <= 32'b0;
			regs[10]<= 32'b0;
			regs[11] <= 32'b0;
			regs[12] <= 32'b0;
			regs[13] <= 32'b0;
			regs[14] <= 32'b0;
			regs[15] <= 32'b0;
			regs[16] <= 32'b0;
			regs[17] <= 32'b0;
			regs[18] <= 32'b0;
			regs[19] <= 32'b0;
			regs[20] <= 32'b0;
			regs[21] <= 32'b0;
			regs[22] <= 32'b0;
			regs[23] <= 32'b0;
			regs[24] <= 32'b0;
			regs[25] <= 32'b0;
			regs[26] <= 32'b0;
			regs[27] <= 32'b0;
			regs[28] <= 32'b0;
			regs[29] <= 32'b0;
			regs[30] <= 32'b0;
			regs[31] <= 32'b0;
		end
		
	always@(posedge clk or negedge resetn)begin
		if(resetn == `RstEnable) begin
			regs[0] <= 32'b0;
			regs[1] <= 32'b0;
			regs[2] <= 32'b0;
			regs[3] <= 32'b0;
			regs[4] <= 32'b0;
			regs[5] <= 32'b0;
			regs[6] <= 32'b0;
			regs[7] <= 32'b0;
			regs[8] <= 32'b0;
			regs[9] <= 32'b0;
			regs[10]<= 32'b0;
			regs[11] <= 32'b0;
			regs[12] <= 32'b0;
			regs[13] <= 32'b0;
			regs[14] <= 32'b0;
			regs[15] <= 32'b0;
			regs[16] <= 32'b0;
			regs[17] <= 32'b0;
			regs[18] <= 32'b0;
			regs[19] <= 32'b0;
			regs[20] <= 32'b0;
			regs[21] <= 32'b0;
			regs[22] <= 32'b0;
			regs[23] <= 32'b0;
			regs[24] <= 32'b0;
			regs[25] <= 32'b0;
			regs[26] <= 32'b0;
			regs[27] <= 32'b0;
			regs[28] <= 32'b0;
			regs[29] <= 32'b0;
			regs[30] <= 32'b0;
			regs[31] <= 32'b0;
		end else begin
            if((wreg == `WriteEnable) && (waddr != 5'h0))begin
				regs[waddr] <= wdata;
			end
        end
	end
	
	always@(*) begin
		if(resetn == `RstEnable) begin
			rdata1 <= `ZeroWord;
		end else if (raddr1 == 5'h0) begin
			rdata1 <= `ZeroWord;
		end else if ((raddr1 == waddr) && (wreg == `WriteEnable)) begin
			rdata1 <= wdata;
		end else begin
			rdata1 <= regs[raddr1];
		end
	end
	
	always@(*) begin
		if(resetn == `RstEnable) begin
			rdata2 <= `ZeroWord;
		end else if (raddr2 == 5'h0) begin
			rdata2 <= `ZeroWord;
		end else if ((raddr2 == waddr) && (wreg == `WriteEnable)) begin
			rdata2 <= wdata;
		end else begin
			rdata2 <= regs[raddr2];
		end
	end

    

endmodule
