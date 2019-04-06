`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:04:39 03/11/2019 
// Design Name: 
// Module Name:    ID_EX 
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

module ID_EX(
    input wire [7:0] id_aluop,
    input wire[2:0] id_alusel,
    input wire[31:0] id_reg1_i,
    input wire[31:0] id_reg2_i,
    input wire[4:0] id_wd_i,
    input wire id_wreg,
    input wire clk,
    input wire resetn,
	input wire [5:0] stall,
	input wire id_is_in_delayslot,
	input wire [31:0] id_link_address,
	input wire next_inst_in_delayslot_i,
	input wire [31:0] id_inst,
	input wire flush,
	input wire [31:0] id_excepttype,
	input wire [31:0] id_current_inst_addr,
	
    output reg [7:0] ex_aluop,
    output reg [2:0] ex_alusel,
    output reg [31:0] ex_reg1_o,
    output reg [31:0] ex_reg2_o,
    output reg [4:0] ex_wd_o,
    output reg ex_wreg,
	output reg ex_is_in_delayslot,
	output reg [31:0] ex_link_address,
	output reg is_in_delayslot_o,
	output reg [31:0] ex_inst,
    output reg [31:0] ex_excepttype,
	output reg [31:0] ex_current_inst_addr
	);
	
	always@(posedge clk) begin
		if (resetn == `RstEnable) begin
			ex_aluop 	<= `EXE_NOP_OP;
			ex_alusel	<= `EXE_RES_NOP;
			ex_reg1_o	<= `ZeroWord;
			ex_reg2_o	<= `ZeroWord;
			ex_wd_o		<= `NOPRegAddr;
			ex_wreg		<= `WriteDisable;
			ex_link_address	<= `ZeroWord;
			ex_is_in_delayslot <= `NotInDelaySlot;
			is_in_delayslot_o  <= `NotInDelaySlot;
			ex_inst		<= `ZeroWord;
			ex_excepttype <= `ZeroWord;
			ex_current_inst_addr <= `ZeroWord;
		end else if(flush == 1'b1 ) begin
			ex_aluop 	<= `EXE_NOP_OP;
			ex_alusel	<= `EXE_RES_NOP;
			ex_reg1_o	<= `ZeroWord;
			ex_reg2_o	<= `ZeroWord;
			ex_wd_o		<= `NOPRegAddr;
			ex_wreg		<= `WriteDisable;
			ex_link_address	<= `ZeroWord;
			ex_is_in_delayslot <= `NotInDelaySlot;
			is_in_delayslot_o  <= `NotInDelaySlot;
			ex_inst		<= `ZeroWord;
			ex_excepttype <= `ZeroWord;
			ex_current_inst_addr <= `ZeroWord;
		end else if (stall[2] == `Stop && stall[3] == `NoStop) begin
			ex_aluop 	<= `EXE_NOP_OP;
			ex_alusel	<= `EXE_RES_NOP;
			ex_reg1_o	<= `ZeroWord;
			ex_reg2_o	<= `ZeroWord;
			ex_wd_o		<= `NOPRegAddr;
			ex_wreg		<= `WriteDisable;
			ex_link_address	<= `ZeroWord;
			ex_is_in_delayslot <= `NotInDelaySlot;
			ex_inst		<= `ZeroWord;
			ex_excepttype <= `ZeroWord;
			ex_current_inst_addr <= `ZeroWord;
		end else if (stall[2] == `NoStop ) begin
			ex_aluop 	<= id_aluop;
			ex_alusel	<= id_alusel;
			ex_reg1_o	<= id_reg1_i;
			ex_reg2_o	<= id_reg2_i;
			ex_wd_o		<= id_wd_i;
			ex_wreg		<= id_wreg;
			ex_link_address <= id_link_address;
			ex_is_in_delayslot <= id_is_in_delayslot;
			is_in_delayslot_o <= next_inst_in_delayslot_i;
			ex_inst		<= id_inst;
			ex_excepttype <= id_excepttype;
			ex_current_inst_addr <= id_current_inst_addr;
		end
	end
	
endmodule
