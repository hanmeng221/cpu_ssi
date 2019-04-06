`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:57:25 03/14/2019 
// Design Name: 
// Module Name:    DATAMEM 
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

module DATAMEM(
    input [31:0] addr,
    input [31:0] data,
    input we,
    input clk,
    output reg [31:0] data_o
    );
	reg [31:0] data_mem[1023:0];
	
    //initial
	//	$readmemh("E:\xls\temp\data.txt",data_mem);
		
	always @(*) begin
		if ( we == `WriteDisable ) begin
			data_o <= data_mem[addr[11:2]];
		end else begin
			data_o <= `ZeroWord;
		end
	end
	
	always @( posedge clk) begin
		if(we == `WriteEnable) begin
			data_mem[addr[11:2]] 		<= data;
		end
	end
	
			


endmodule
