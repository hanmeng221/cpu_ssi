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
    output  reg [31:0] inst_out
    );
	//reg [31:0] im[1023:0];
	//assign inst_out = im[pc_in[11:2]];
    always @(*) begin
        case (pc_in[11:2])
            10'd0:inst_out<= 32'b00110100000010010000000000001010;
            10'd1:inst_out<= 32'b00100000000000010000000000000001;
            10'd2:inst_out<= 32'b00000001001000010100100000100010;
            10'd3:inst_out<= 32'b00110101000010100000000000000001;
            10'd4:inst_out<= 32'b00100000000000010000000000000000;
            10'd5:inst_out<= 32'b00010000001010011111111111111010;
            10'd6:inst_out<= 32'b00001000000000000000110000000001;
            10'd7:inst_out<= 32'b00000000000000000000000000000000;
        endcase
    end
    
	//initial
	//	$readmemh("E:\xls\temp\code.txt",im);
		
	
endmodule
