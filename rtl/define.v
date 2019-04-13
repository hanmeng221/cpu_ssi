`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:20:33 03/11/2019 
// Design Name: 
// Module Name:    define 
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

`define True_v      		1'b1
`define False_v     		1'b0

`define WriteEnable 		1'b1
`define WriteDisable 		1'b0

`define RstEnable   		1'b0
`define RstDisable  		1'b1

`define Stop				1'b1
`define NoStop				1'b0

`define Branch 				1'b1
`define NotBranch			1'b0

`define InDelaySlot			1'b1
`define NotInDelaySlot		1'b0

`define MEMDisable			1'b0
`define MEMEnable			1'b1

`define REGEnable			1'b1
`define REGDisable			1'b0

`define InterruptAssert		1'b1
`define InterruptNotAssert	1'b0

`define InstBegin			32'h00003000 - 32'h4

`define InstValid 1'b0
`define InstInvalid 1'b1

`define TrapAssert 			1'b1
`define TrapNotAssert 		1'b0

`define ZeroWord			32'h00000000

`define NOPRegAddr			5'b00000

`define EXE_RES_NOP			3'b000
`define EXE_RES_LOGIC		3'b001
`define EXE_RES_SHIFT		3'b010
`define EXE_RES_MOVE		3'b011
`define EXE_RES_ARITHMETIC 	3'b100	
`define EXE_RES_MUL 		3'b101
`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE	3'b111

`define EXE_NOP				6'b000000
`define EXE_SPECIAL_INST 	6'b000000
`define EXE_REGIMM_INST 	6'b000001
`define EXE_SPECIAL2_INST 	6'b011100

`define EXE_ORI				6'b001101
`define EXE_AND				6'b100100
`define EXE_OR				6'b100101
`define EXE_XOR				6'b100110
`define EXE_NOR				6'b100111
`define EXE_ANDI			6'b001100
`define EXE_XORI			6'b001110
`define EXE_LUI				6'b001111
`define EXE_SLL				6'b000000
`define EXE_SLLV			6'b000100
`define EXE_SRL				6'b000010
`define EXE_SRLV			6'b000110
`define EXE_SRA				6'b000011
`define EXE_SRAV			6'b000111

`define EXE_SYNC			6'b001111
`define EXE_PREF			6'b110011
`define EXE_MOVZ			6'b001010
`define EXE_MOVN			6'b001011
`define EXE_MFHI			6'b010000
`define EXE_MTHI			6'b010001
`define EXE_MFLO			6'b010010
`define EXE_MTLO			6'b010011
`define EXE_SLT  			6'b101010
`define EXE_SLTU  			6'b101011
`define EXE_SLTI  			6'b001010
`define EXE_SLTIU  			6'b001011   

`define EXE_ADD  			6'b100000
`define EXE_ADDU  			6'b100001
`define EXE_SUB  			6'b100010
`define EXE_SUBU  			6'b100011
`define EXE_ADDI  			6'b001000
`define EXE_ADDIU  			6'b001001
`define EXE_CLZ  			6'b100000
`define EXE_CLO  			6'b100001
`define EXE_MULT 			6'b011000
`define EXE_MULTU  			6'b011001
`define EXE_MUL  			6'b000010

`define EXE_J				6'b000010
`define EXE_JAL				6'b000011
`define EXE_JALR			6'b001001
`define EXE_JR				6'b001000
`define EXE_BEQ				6'b000100
`define EXE_BGEZ			5'b00001
`define EXE_BGEZAL			5'b10001
`define EXE_BGTZ			6'b000111
`define EXE_BLEZ			6'b000110
`define EXE_BLTZ			5'b00000
`define EXE_BLTZAL			5'b10000
`define EXE_BNE				6'b000101

`define EXE_LW				6'b100011
`define EXE_SW				6'b101011

`define EXE_TEQ 6'b110100
`define EXE_TEQI 5'b01100
`define EXE_TGE 6'b110000
`define EXE_TGEI 5'b01000
`define EXE_TGEIU 5'b01001
`define EXE_TGEU 6'b110001
`define EXE_TLT 6'b110010
`define EXE_TLTI 5'b01010
`define EXE_TLTIU 5'b01011
`define EXE_TLTU 6'b110011
`define EXE_TNE 6'b110110
`define EXE_TNEI 5'b01110
   
`define EXE_SYSCALL 6'b001100
  
`define EXE_ERET 32'b01000010000000000000000000011000

`define EXE_NOP_OP			8'b00000000

`define EXE_OR_OP			8'b00100101
`define EXE_AND_OP			8'b00100100
`define EXE_XOR_OP			8'b00100110
`define EXE_NOR_OP			8'b00100111
`define EXE_SLL_OP			8'b01111100
`define EXE_SRL_OP			8'b00000010
`define EXE_SRA_OP			8'b00000011

`define EXE_MOVZ_OP  		8'b00001010
`define EXE_MOVN_OP  		8'b00001011
`define EXE_MFHI_OP  		8'b00010000
`define EXE_MTHI_OP  		8'b00010001
`define EXE_MFLO_OP  		8'b00010010
`define EXE_MTLO_OP  		8'b00010011

`define EXE_SLT_OP  		8'b00101010
`define EXE_SLTU_OP  		8'b00101011
`define EXE_SLTI_OP  		8'b01010111
`define EXE_SLTIU_OP  		8'b01011000   

`define EXE_ADD_OP  		8'b00100000
`define EXE_ADDU_OP  		8'b00100001
`define EXE_SUB_OP  		8'b00100010
`define EXE_SUBU_OP  		8'b00100011
`define EXE_ADDI_OP  		8'b01010101
`define EXE_ADDIU_OP  		8'b01010110
`define EXE_CLZ_OP  		8'b10110000
`define EXE_CLO_OP  		8'b10110001
`define EXE_MULT_OP  		8'b00011000
`define EXE_MULTU_OP  		8'b00011001
`define EXE_MUL_OP  		8'b10101001

`define EXE_J_OP  			8'b01001111
`define EXE_JAL_OP  		8'b01010000
`define EXE_JALR_OP  		8'b00001001
`define EXE_JR_OP  			8'b00001000
`define EXE_BEQ_OP  		8'b01010001
`define EXE_BGEZ_OP  		8'b01000001
`define EXE_BGEZAL_OP  		8'b01001011
`define EXE_BGTZ_OP  		8'b01010100
`define EXE_BLEZ_OP  		8'b01010011
`define EXE_BLTZ_OP  		8'b01000000
`define EXE_BLTZAL_OP  		8'b01001010
`define EXE_BNE_OP  		8'b01010010

`define EXE_LW_OP			8'b11100011
`define EXE_SW_OP			8'b11101011

`define EXE_MFC0_OP 		8'b01011101
`define EXE_MTC0_OP 		8'b01100000

`define EXE_TEQ_OP 8'b00110100
`define EXE_TEQI_OP 8'b01001000
`define EXE_TGE_OP 8'b00110000
`define EXE_TGEI_OP 8'b01000100
`define EXE_TGEIU_OP 8'b01000101
`define EXE_TGEU_OP 8'b00110001
`define EXE_TLT_OP 8'b00110010
`define EXE_TLTI_OP 8'b01000110
`define EXE_TLTIU_OP 8'b01000111
`define EXE_TLTU_OP 8'b00110011
`define EXE_TNE_OP 8'b00110110
`define EXE_TNEI_OP 8'b01001001


`define EXE_SYSCALL_OP 8'b00001100

`define EXE_ERET_OP 	8'b01101011

`define CP0_REG_COUNT 		5'b01001
`define CP0_REG_COMPARE		5'b01011
`define CP0_REG_STATUS		5'b01100
`define CP0_REG_CAUSE		5'b01101
`define CP0_REG_EPC			5'b01110
`define CP0_REG_PRID		5'b01111
`define CP0_REG_CONFIG		5'b10000



