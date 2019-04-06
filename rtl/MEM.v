`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:07:50 03/11/2019 
// Design Name: 
// Module Name:    MEM 
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

module MEM(
    input wire [31:0] wdata_i,
    input wire [4:0] wd_i,
    input wire wreg_i,
	input wire whilo_i,
	input wire [31:0] hi_i,
	input wire [31:0] lo_i,
	input wire resetn,

	input wire [7:0] aluop_i,
	input wire [31:0] mem_addr_i,
	input wire [31:0] reg2_i,
	input wire [31:0] mem_data_i,
	
	input wire cp0_reg_we_i,
	input wire [4:0] cp0_reg_write_addr_i,
	input wire [31:0] cp0_reg_data_i,
	
	input wire [31:0] excepttype_i,
	input wire [31:0] current_inst_addr_i,
	input wire is_in_delayslot_i,
	input wire [31:0] cp0_status_i,
	input wire [31:0] cp0_cause_i,
	input wire [31:0] cp0_epc_i,
	input wire wb_cp0_reg_we,
	input wire [4:0] wb_cp0_reg_write_addr,
	input wire [31:0] wb_cp0_reg_data,
	
    output reg [31:0] wdata_o,
    output reg [4:0] wd_o,
    output reg wreg_o,
	output reg whilo_o,
	output reg [31:0] hi_o,
	output reg [31:0] lo_o,
	
	output reg [31:0] mem_addr_o,
	output wire mem_we_o,
	output reg [31:0] mem_data_o,
	
	output reg cp0_reg_we_o,
	output reg [4:0] cp0_reg_write_addr_o,
	output reg [31:0] cp0_reg_data_o,
    
	output reg [31:0] excepttype_o,
	output wire [31:0] current_inst_addr_o,
	output wire is_in_delayslot_o,
	output wire [31:0] cp0_epc_o
	);
	reg mem_we;
	assign mem_we_o	 = mem_we & (~(|excepttype_o));
	
	assign is_in_delayslot_o = is_in_delayslot_i;
	assign current_inst_addr_o = current_inst_addr_i;
	
	reg [31:0] cp0_status;
	reg [31:0] cp0_cause;
	reg [31:0] cp0_epc;
	
	always@ (*) begin
		if(resetn == `RstEnable) begin
			cp0_status <= `ZeroWord;
		end else if ((wb_cp0_reg_we == `WriteEnable) && (wb_cp0_reg_write_addr == `CP0_REG_STATUS)) begin
			cp0_status <= wb_cp0_reg_data;
		end else begin
			cp0_status <= cp0_status_i;
		end
	end
	
	always@ (*) begin
		if(resetn == `RstEnable) begin
			cp0_epc <= `ZeroWord;
		end else if ((wb_cp0_reg_we == `WriteEnable) && (wb_cp0_reg_write_addr == `CP0_REG_EPC)) begin
			cp0_epc <= wb_cp0_reg_data;
		end else begin
			cp0_epc <= cp0_epc_i;
		end
	end
	
	assign cp0_epc_o = cp0_epc;
	
	always@(*) begin
		if(resetn == `RstEnable) begin
			cp0_cause <= `ZeroWord;
		end else if((wb_cp0_reg_we == `WriteEnable) && (wb_cp0_reg_write_addr == `CP0_REG_CAUSE)) begin
			cp0_cause[9:8] <= wb_cp0_reg_data[9:8];
			cp0_cause[22] <= wb_cp0_reg_data[22];
			cp0_cause[23] <= wb_cp0_reg_data[23];
		end else begin
			cp0_cause <= cp0_cause_i;
		end
	end
	 
	 
	always@(*) begin
		if(resetn == `RstEnable) begin
			excepttype_o <= `ZeroWord;
		end else begin
			excepttype_o <= `ZeroWord;
			if(current_inst_addr_i != `ZeroWord) begin
				if(((cp0_cause[15:8] &(cp0_status[15:8])) != 8'h00) && (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1)) begin
					excepttype_o <= 32'h00000001;
				end else if(excepttype_i[8] == 1'b1) begin
					excepttype_o <= 32'h00000008;
				end else if(excepttype_i[9] == 1'b1) begin
					excepttype_o <= 32'h0000000a;
				end else if(excepttype_i[10] == 1'b1) begin
					excepttype_o <= 32'h0000000d;
				end else if(excepttype_i[11] == 1'b1) begin
					excepttype_o <= 32'h0000000c;
				end else if(excepttype_i[12] == 1'b1) begin
					excepttype_o <= 32'h0000000e;
				end
			end
		end
	end
	
	
	always@(*) begin
		if (resetn == `RstEnable) begin
			wd_o	<= `NOPRegAddr;
			wreg_o	<= `WriteDisable;
			wdata_o	<= `ZeroWord;
			whilo_o <= `WriteDisable;
			hi_o	<= `ZeroWord;
			lo_o	<= `ZeroWord;
			
			mem_addr_o	<= `ZeroWord;
			mem_we		<= `WriteDisable;
			mem_data_o	<= `ZeroWord;
			
			cp0_reg_data_o 			<= `ZeroWord;
			cp0_reg_we_o			<= `WriteDisable;
			cp0_reg_write_addr_o 	<= 5'b00000;

		end else begin
			wd_o 	<= wd_i;
			wreg_o	<=	wreg_i;
			wdata_o	<= wdata_i;
			whilo_o <= whilo_i;
			hi_o	<= hi_i;
			lo_o	<= lo_i;
			
			mem_addr_o	<= `ZeroWord;
			mem_we		<= `WriteDisable;
			
			cp0_reg_data_o 			<= cp0_reg_data_i;
			cp0_reg_we_o			<= cp0_reg_we_i;
			cp0_reg_write_addr_o 	<= cp0_reg_write_addr_i;

			case (aluop_i)
				`EXE_LW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we		<= `WriteDisable;
					wdata_o		<= mem_data_i;
				end
				`EXE_SW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we		<= 	`WriteEnable;
					mem_data_o	<=reg2_i;
				end
				default:begin
				end
			endcase
		end
	end

endmodule
