`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:05:58 03/11/2019 
// Design Name: 
// Module Name:    EXE 
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

module EXE(
    input wire[7:0] aluop_i,
    input wire [2:0] alusel_i,
    input wire [31:0] reg1_i,
    input wire [31:0] reg2_i,
    input wire [4:0] wd_i,
    input wire wreg_i,
	
	input wire [31:0] hi_i,
	input wire [31:0] lo_i,
	input wire wb_whilo_i,
	input wire [31:0] wb_hi_i,
	input wire [31:0] wb_lo_i,
	input wire mem_whilo_i,
	input wire [31:0] mem_hi_i,
	input wire [31:0] mem_lo_i,
	
    input wire resetn,
	
	input wire is_in_delayslot_i,
	input wire [31:0] link_address_i,
	input wire [31:0] inst_i,
	
	input wire [31:0] cp0_reg_data_i,
	
	input wire  mem_cp0_reg_we,
	input wire [4:0] mem_cp0_reg_write_addr,
	input wire [31:0] mem_cp0_reg_data,
	
	input wire wb_cp0_reg_we,
	input wire [4:0] wb_cp0_reg_write_addr,
	input wire [31:0] wb_cp0_reg_data,

	input wire [31:0] excepttype_i,
	input wire [31:0] current_inst_addr_i,
	
    output reg [31:0] wdata_o,
    output reg [4:0] wd_o,
    output reg wreg_o,
    output reg whilo_o,
	output reg [31:0] hi_o,
	output reg [31:0] lo_o,
	output  stallreq,
	output  [7:0] aluop_o,
	output  [31:0] mem_addr_o,
	output  [31:0] ex_reg2,

	output reg [4:0] cp0_reg_read_addr_o,
	output reg cp0_reg_we_o,
	output reg [4:0] cp0_reg_write_addr_o,
	output reg [31:0] cp0_reg_data_o,
	
	output wire [31:0] excepttype_o,
	output wire [31:0] current_inst_addr_o,
	output wire is_in_delayslot_o
	);
	reg [31:0] logicout;
	reg [31:0] shiftout;
	reg [31:0] moveout;
	reg [31:0] HI,LO;
	reg [31:0] arithmeticres;
	
	reg trapassert;
	reg ovassert;
	
	assign excepttype_o = {excepttype_i[31:12],ovassert,trapassert,excepttype_i[9:8],8'h00};
	assign is_in_delayslot_o = is_in_delayslot_i;
	assign current_inst_addr_o = current_inst_addr_i;	assign 	stallreq = `NoStop;
	
	assign aluop_o = aluop_i;
	assign mem_addr_o = reg1_i +  {{16{inst_i[15]}},inst_i[15:0]};
	assign ex_reg2 = reg2_i;
	
	wire ov_sum;
	wire reg1_eq_reg2;
	wire req1_lt_reg2;
	wire [31:0] reg2_i_mux;
	wire [31:0] reg1_i_not;
	wire [31:0] result_sum;
	wire [31:0] opdata1_mult;
	wire [31:0] opdata2_mult;
	wire [63:0] hilo_temp;
	reg [63:0] mulres;
	
	assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || (aluop_i == `EXE_SUBU_OP) || (aluop_i == `EXE_SLT_OP) || (aluop_i == `EXE_TLT_OP) || (aluop_i == `EXE_TLTI_OP) || (aluop_i == `EXE_TGE_OP) || (aluop_i == `EXE_TGEI_OP))? (~reg2_i)+1 : reg2_i;
	assign result_sum = reg1_i + reg2_i_mux;
	assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) || ((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));
	wire  reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP) || (aluop_i == `EXE_TLT_OP) || (aluop_i == `EXE_TLTI_OP) || (aluop_i == `EXE_TGE_OP) || (aluop_i == `EXE_TGEI_OP))?((reg1_i[31] && !reg2_i[31]) || (!reg1_i[31] && !reg2_i[31] && result_sum[31]) || (reg1_i[31] && reg2_i[31] && result_sum[31])):(reg1_i<reg2_i);
	assign reg1_i_not = ~reg1_i;
	
	always @(*) begin
		if (resetn == `RstEnable) begin
			arithmeticres <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLT_OP,`EXE_SLTU_OP: begin
					arithmeticres <= reg1_lt_reg2;
				end
				`EXE_ADD_OP,`EXE_ADDU_OP,`EXE_ADDI_OP,`EXE_ADDIU_OP:begin
					arithmeticres <= result_sum;
				end
				`EXE_SUB_OP,`EXE_SUBU_OP: begin
					arithmeticres <= result_sum;
				end
				`EXE_CLZ_OP: begin
					arithmeticres <= reg1_i[31] ? 0:reg1_i[30] ? 1:
									reg1_i[29] ? 2:reg1_i[28] ? 3:
									reg1_i[27] ? 4:reg1_i[26] ? 5:
									reg1_i[25] ? 6:reg1_i[24] ? 7:
									reg1_i[23] ? 8:reg1_i[22] ? 9:
									reg1_i[21] ? 10:reg1_i[20] ? 11:
									reg1_i[19] ? 12:reg1_i[18] ? 13:
									reg1_i[17] ? 14:reg1_i[16] ? 15:
									reg1_i[15] ? 16:reg1_i[14] ? 17:
									reg1_i[13] ? 18:reg1_i[12] ? 19:
									reg1_i[11] ? 20:reg1_i[10] ? 21:
									reg1_i[9] ? 22:reg1_i[8] ? 23:
									reg1_i[7] ? 24:reg1_i[6] ? 25:
									reg1_i[5] ? 26:reg1_i[4] ? 27:
									reg1_i[3] ? 28:reg1_i[2] ? 29:
									reg1_i[1] ? 30:reg1_i[0] ? 31:32;
				end
				`EXE_CLO_OP: begin
					arithmeticres <= reg1_i_not[31] ? 0:reg1_i_not[30] ? 1:
									reg1_i_not[29] ? 2:reg1_i_not[28] ? 3:
									reg1_i_not[27] ? 4:reg1_i_not[26] ? 5:
									reg1_i_not[25] ? 6:reg1_i_not[24] ? 7:
									reg1_i_not[23] ? 8:reg1_i_not[22] ? 9:
									reg1_i_not[21] ? 10:reg1_i_not[20] ? 11:
									reg1_i_not[19] ? 12:reg1_i_not[18] ? 13:
									reg1_i_not[17] ? 14:reg1_i_not[16] ? 15:
									reg1_i_not[15] ? 16:reg1_i_not[14] ? 17:
									reg1_i_not[13] ? 18:reg1_i_not[12] ? 19:
									reg1_i_not[11] ? 20:reg1_i_not[10] ? 21:
									reg1_i_not[9] ? 22:reg1_i_not[8] ? 23:
									reg1_i_not[7] ? 24:reg1_i_not[6] ? 25:
									reg1_i_not[5] ? 26:reg1_i_not[4] ? 27:
									reg1_i_not[3] ? 28:reg1_i_not[2] ? 29:
									reg1_i_not[1] ? 30:reg1_i_not[0] ? 31:32;
				end
				default: begin
					arithmeticres <= `ZeroWord;
				end
			endcase
		end
	end
	
	assign opdata1_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP)) && (reg1_i[31] == 1'b1)) ? (~reg1_i + 1): reg1_i;
	
	assign opdata2_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP)) && (reg2_i[31] == 1'b1)) ? (~reg2_i + 1) :reg2_i;
	
	assign hilo_temp = opdata1_mult * opdata2_mult;
	
	always@(*) begin
		if (resetn == `RstEnable) begin
			mulres <= {`ZeroWord,`ZeroWord};
		end else if ((aluop_i == `EXE_MUL_OP ) || (aluop_i == `EXE_MULT_OP)) begin
			if (reg1_i[31] ^ reg2_i[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end else begin
				mulres <= hilo_temp ;
			end 
		end else begin
			mulres <= hilo_temp;
		end
	end

	always @(*) begin
		wd_o <= wd_i;
		if (((aluop_i == `EXE_ADD_OP ) || (aluop_i == `EXE_ADDI_OP ) || (aluop_i == `EXE_SUB_OP )) && (ov_sum == 1'b1)) begin
			wreg_o <= `WriteDisable;
			ovassert <= 1'b1;
		end else begin
			wreg_o <= wreg_i;
			ovassert <= 1'b0;
		end
			
		case (alusel_i)
			`EXE_RES_LOGIC: begin
				wdata_o <= logicout;
			end
			`EXE_RES_SHIFT:begin
				wdata_o <= shiftout;
			end
			`EXE_RES_MOVE: begin
				wdata_o <= moveout;
			end
			`EXE_RES_ARITHMETIC:begin
				wdata_o <= arithmeticres;
			end
			`EXE_RES_MUL: begin
				wdata_o <= mulres[31:0];
			end
			`EXE_RES_JUMP_BRANCH:begin
				wdata_o <= link_address_i;
			end
			default: begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end
	
	always @(*) begin
		if (resetn == `RstEnable) begin
			{HI,LO} <= {`ZeroWord,`ZeroWord};
		end else if (mem_whilo_i == `WriteEnable) begin
			{HI,LO} <= {mem_hi_i,mem_lo_i};
		end else if (wb_whilo_i == `WriteEnable) begin
			{HI,LO} <= {wb_hi_i,wb_lo_i};
		end else begin
			{HI,LO} <= {hi_i,lo_i};
		end
	end

			
	always @(*) begin
		if (resetn == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP: begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP: begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_XOR_OP: begin
					logicout <= reg1_i ^ reg2_i;
				end
				`EXE_NOR_OP: begin
					logicout <= ~(reg1_i ^ reg2_i);
				end
				default: begin
					logicout <= `ZeroWord;
				end
			endcase
		end
	end
	
	always @(*) begin
		if (resetn == `RstEnable) begin
			shiftout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP: begin
					shiftout <= reg2_i << reg1_i[4:0];
				end
				`EXE_SRL_OP: begin
					shiftout <= reg2_i >> reg1_i[4:0];
				end
				`EXE_SRA_OP: begin
					shiftout <= ({32{reg2_i[31]}}<<(6'd32-{1'b0,reg1_i[4:0]})) | reg2_i >>reg1_i[4:0];
				end
				default: begin
					shiftout <= `ZeroWord;
				end
			endcase
		end
	end
	
	always @(*) begin
		if (resetn == `RstEnable) begin
			moveout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_MFHI_OP: begin
					moveout <= HI;
				end
				`EXE_MFLO_OP: begin
					moveout <= LO;
				end
				`EXE_MOVZ_OP:begin
					moveout <= reg1_i;
				end
				`EXE_MOVN_OP:begin
					moveout <= reg1_i;
				end
				`EXE_MFC0_OP: begin
					cp0_reg_read_addr_o <= inst_i[15:11];
					moveout			<= cp0_reg_data_i;
					if ( mem_cp0_reg_we == `WriteEnable && mem_cp0_reg_write_addr == inst_i[15:11]) begin
						moveout <= mem_cp0_reg_data;
					end else if (wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_write_addr == inst_i[15:11] ) begin
						moveout <= wb_cp0_reg_data;
					end
				end
				default:begin
				end
			endcase
		end
	end
	

	always@(*) begin
		if(resetn == `RstEnable) begin
			cp0_reg_write_addr_o	<= 5'b00000;
			cp0_reg_we_o 			<= `WriteDisable;
			cp0_reg_data_o			<= `ZeroWord;
		end else if(aluop_i == `EXE_MTC0_OP) begin
			cp0_reg_write_addr_o 	<= inst_i[15:11];
			cp0_reg_we_o 			<= `WriteEnable;
			cp0_reg_data_o 			<= reg1_i;
		end else begin
			cp0_reg_write_addr_o	<= 5'b00000;
			cp0_reg_we_o 			<= `WriteDisable;
			cp0_reg_data_o			<= `ZeroWord;
		end
	end


	always@(*) begin
		if(resetn == `RstEnable) begin
			whilo_o <= `WriteDisable;
			hi_o 	<= `ZeroWord;
			lo_o 	<= `ZeroWord;
		end else if((aluop_i == `EXE_MULT_OP ) ||(aluop_i == `EXE_MULTU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o    <= mulres[63:32];
			lo_o	<= mulres[31:0];
		end else if (aluop_i == `EXE_MTHI_OP) begin
			whilo_o <= `WriteEnable;
			hi_o 	<= reg1_i;
			lo_o 	<= LO;
		end else if (aluop_i == `EXE_MTLO_OP) begin
			whilo_o <= `WriteEnable;
			hi_o	<= HI;
			lo_o	<= reg1_i;
		end else begin
			whilo_o <= `WriteDisable;
			hi_o	<= `ZeroWord;
			lo_o	<= `ZeroWord;
		end
	end
	
	always @(*) begin
		if(resetn == `RstEnable) begin
			trapassert <= `TrapNotAssert;
		end else begin
			trapassert <= `TrapNotAssert;
			case (aluop_i)
				`EXE_TEQ_OP,`EXE_TEQI_OP: begin	
					if(reg1_i == reg2_i) begin
						trapassert <= `TrapAssert;
					end
				end
				`EXE_TGE_OP,`EXE_TGEI_OP,`EXE_TGEIU_OP,`EXE_TGEU_OP: begin
					if(~reg1_lt_reg2) begin
						trapassert <= `TrapAssert;
					end
				end
				`EXE_TLT_OP,`EXE_TLTI_OP,`EXE_TLTIU_OP,`EXE_TLTU_OP: begin
					if(reg1_lt_reg2) begin
						trapassert <= `TrapAssert;
					end
				end
				`EXE_TNE_OP,`EXE_TNEI_OP: begin
					if(reg1_i != reg2_i) begin
						trapassert <= `TrapAssert;
					end
				end
				default: begin
					trapassert <= `TrapNotAssert;
				end
			endcase
		end
	end
endmodule
