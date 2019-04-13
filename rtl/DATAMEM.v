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
    output [31:0] data_o,
    input  [10:0] rgb_offset,
    input rgb_clk,
    output [15:0] rgb_data
    );
    //a 口用于CPU输入输出
    //b 口用于RGB读取
    
    dm_ram mydm_rams(
  
    .clock_a(~clk),
    .address_a(addr[11:2]),
	.data_a(data ),
	.wren_a(we),
	.q_a(data_o),

    
    .clock_b(rgb_clk),
    .address_b(rgb_offset),
	.data_b(16'd0),
    .wren_b(`WriteDisable),
	.q_b(rgb_data));
    
     
    /*
    
	//reg [31:0] data_mem[1023:0];
    reg [31:0] data_mem;
    //initial
	//	$readmemh("E:\xls\temp\data.txt",data_mem);
	
	always @(*) begin
		if ( we == `WriteDisable ) begin
            //data_o <= data_mem[addr[11:2]];
            data_o <= data_mem;
		end else begin
			data_o <= `ZeroWord;
        end
	end
	
	always @( posedge clk) begin
		if(we == `WriteEnable) begin
			//data_mem[addr[11:2]] 		<= data;
            data_mem 		<= data;
        end
	end
    */    
  

    
endmodule
