`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:56:50 03/11/2019 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input wire [31:0] pc_in,
    output  [31:0] inst_out
    );
	reg [31:0] im[1023:0];
	assign inst_out = im[pc_in[11:2]];
        
	initial $readmemh("E:/fpga/muliplyCPU/rtl/rom.data",im);
		
	
endmodule
