`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:46:51 03/12/2019 
// Design Name: 
// Module Name:    HILO 
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

module HILO(
    input wire we,
    input wire [31:0] hi_i,
    input wire [31:0] lo_i,
    input wire resetn,
    input wire clk,
    output reg [31:0] hi_o,
    output reg [31:0] lo_o
    );
	always @(posedge clk) begin
		if( resetn == `RstEnable) begin
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
		end else begin
			hi_o <= hi_i;
			lo_o <= lo_i;
		end
	end

endmodule
