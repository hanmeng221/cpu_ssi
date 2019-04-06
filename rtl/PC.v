`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:19:40 03/11/2019 
// Design Name: 
// Module Name:    PC 
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

module PC(
    input wire clk,
    input wire resetn,
	input wire [5:0] stall,
	input wire [31:0] branch_target_address_i,
	input wire branch_flag_i,
	input wire flush,
	input wire [31:0] new_pc,
    output reg [31:0] pc
    );
	
	always @(posedge clk) begin
		if (resetn == `RstEnable) begin
			pc <= `InstBegin;
		end else begin
			if (flush == 1'b1) begin
				pc <= new_pc;
			end else if (stall[0] == `NoStop)  begin
				if(branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end else begin 
					pc <= pc + 4'h4;
				end
			end
		end
	end
endmodule
