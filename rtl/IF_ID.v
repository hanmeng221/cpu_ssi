`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:58:05 03/11/2019 
// Design Name: 
// Module Name:    IF_ID 
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
`include  "define.v"

module IF_ID(
    input wire[31:0] if_pc,
    input wire [31:0] if_inst,
    input wire clk,
    input wire resetn,
	input wire [5:0] stall,
	input wire flush,
    output reg [31:0] id_pc,
    output reg [31:0] id_inst
    );
	always @(posedge clk) begin
		if (resetn == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if (flush == 1'b1) begin 
			id_pc  <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if(stall[1] == `Stop && stall[2] == `NoStop )begin
			id_pc	<= `ZeroWord;
			id_inst	<= `ZeroWord;
		end else if (stall[1] == `NoStop) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
	

endmodule
