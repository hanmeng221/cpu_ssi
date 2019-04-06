`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:06:56 03/11/2019 
// Design Name: 
// Module Name:    EX_MEM 
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

module EX_MEM(
    input wire [31:0] ex_wdata,
    input wire [4:0] ex_wd,
    input wire ex_wreg,
	input wire ex_whilo,
	input wire [31:0] ex_hi,
	input wire [31:0] ex_lo,
    input wire clk,
    input wire resetn,
	input wire [5:0] stall,  
	input wire [7:0] ex_aluop,
	input wire [31:0] ex_mem_addr,
	input wire [31:0] ex_reg2,
	input wire ex_cp0_reg_we,
	input wire [4:0] ex_cp0_reg_write_addr,
	input wire [31:0] ex_cp0_reg_data,
	input wire flush,
	input wire [31:0] ex_excepttype,
	input wire [31:0] ex_current_inst_addr,
	input wire ex_is_in_delayslot,
	
    output reg [31:0] mem_wdata,
    output reg [4:0] mem_wd,
    output reg mem_wreg,
	output reg mem_whilo,
	output reg [31:0] mem_hi,
	output reg [31:0] mem_lo,
	output reg [7:0] mem_aluop,
	output reg [31:0] mem_mem_addr,
	output reg [31:0] mem_reg2,
    output reg mem_cp0_reg_we,
    output reg [4:0] mem_cp0_reg_write_addr,
    output reg [31:0] mem_cp0_reg_data, 
    
	output reg[31:0] mem_excepttype,
	output reg[31:0] mem_current_inst_addr,
	output reg mem_is_in_delayslot
	);

	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			mem_wd		<= `NOPRegAddr;
			mem_wreg 	<= `WriteDisable;
			mem_wdata 	<= `ZeroWord;
			mem_whilo	<= `WriteDisable;
			mem_hi		<= `ZeroWord;
			mem_lo		<= `ZeroWord;
			mem_aluop	<= `EXE_NOP_OP;
			mem_mem_addr<= `ZeroWord;
			mem_reg2	<= `ZeroWord;
			
			mem_cp0_reg_data 		<= `ZeroWord;
			mem_cp0_reg_we 	 		<= `WriteDisable;
			mem_cp0_reg_write_addr 	<= 5'b00000;
			
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
			mem_current_inst_addr <= `ZeroWord;
		end else if(flush == 1'b1) begin
			mem_wd		<= `NOPRegAddr;
			mem_wreg 	<= `WriteDisable;
			mem_wdata 	<= `ZeroWord;
			mem_whilo	<= `WriteDisable;
			mem_hi		<= `ZeroWord;
			mem_lo		<= `ZeroWord;
			mem_aluop	<= `EXE_NOP_OP;
			mem_mem_addr<= `ZeroWord;
			mem_reg2	<= `ZeroWord;
			
			mem_cp0_reg_data 		<= `ZeroWord;
			mem_cp0_reg_we 	 		<= `WriteDisable;
			mem_cp0_reg_write_addr 	<= 5'b00000;
			
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
			mem_current_inst_addr <= `ZeroWord;
			
		end else if(stall[3] == `Stop && stall[4] == `NoStop ) begin
			mem_wd		<= `NOPRegAddr;
			mem_wreg 	<= `WriteDisable;
			mem_wdata 	<= `ZeroWord;
			mem_whilo	<= `WriteDisable;
			mem_hi		<= `ZeroWord;
			mem_lo		<= `ZeroWord;
			mem_aluop	<= `EXE_NOP_OP;
			mem_mem_addr<= `ZeroWord;
			mem_reg2	<= `ZeroWord;
			mem_cp0_reg_data 		<= `ZeroWord;
			mem_cp0_reg_we 	 		<= `WriteDisable;
			mem_cp0_reg_write_addr 	<= 5'b00000;
		
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
			mem_current_inst_addr <= `ZeroWord;
			
		end else if(stall[3] == `NoStop) begin
			mem_wd		<= ex_wd;
			mem_wreg	<= ex_wreg;
			mem_wdata	<= ex_wdata;
			mem_whilo	<= ex_whilo;
			mem_hi		<= ex_hi;
			mem_lo		<= ex_lo;
			mem_aluop	<= ex_aluop;
			mem_mem_addr<= ex_mem_addr;
			mem_reg2	<= ex_reg2;
			mem_cp0_reg_data 		<= ex_cp0_reg_data;
			mem_cp0_reg_we 	 		<= ex_cp0_reg_we;
			mem_cp0_reg_write_addr 	<= ex_cp0_reg_write_addr;
			
			mem_excepttype <= ex_excepttype;
			mem_is_in_delayslot <= ex_is_in_delayslot;
			mem_current_inst_addr <= ex_current_inst_addr;
			
		end
	end
	
endmodule
