`include "define.v"
module UARTPACKAGE(
    input wire [31:0] regdata,
    input wire [4:0] regaddr,
    input wire regen,
    input wire [31:0] alu_inst,
    input wire [31:0] alu_reg1,
    input wire [31:0] alu_reg2,
    input wire [31:0] alu_result,
    input wire [31:0] inst,
    input wire [31:0] other_pc,
    input wire [31:0] other_hi,
    input wire [31:0] other_lo,
    input wire clk,
    input wire resetn,
    input wire send_clk,
    input wire rx,
    output tx,
    output rx_done,
    output [7:0] rx_data
   
);

    reg [3:0] package_cnt;
    reg [4:0] package_addr;
    reg [1:0] package_kind;
    reg [31:0] package_data;
    
	reg send_en_d0;
	reg send_en_d1;
	
	reg [7:0] send_data;
	
	wire send_flag;
	
	reg package_flag;
	
	reg uart_en;
	reg [24:0] clk_cnt;
	assign send_flag = (~send_en_d0) & send_en_d1;
	
	always @(posedge clk or negedge resetn) begin
		if(resetn == `RstEnable) begin
			send_en_d0 <= 1'b0;
			send_en_d1 <= 1'b0;
		end else begin
			send_en_d0 <= send_clk;
			send_en_d1 <= send_en_d0;
		end
	end
	
	
	always @(posedge clk or negedge resetn) begin
		if(resetn == `RstEnable) begin	
			package_flag <= 1'b0;
		end else begin
			if(send_flag) begin
				package_flag <= 1'b1;
			end else if((package_cnt == 4'd10) && (clk_cnt == 25'd20828)) begin
				package_flag <= 1'b0;
			end
		end
	end
	
	always @(posedge clk or negedge resetn) begin
		if (resetn == `RstEnable) begin
			clk_cnt <= 25'd0;
			package_cnt <= 4'd0;
			uart_en <= 1'b0;
		end else begin
			if(package_flag) begin
				if(clk_cnt <  25'd41655 ) begin
					clk_cnt <= clk_cnt + 1'b1;
					uart_en <= 1'b0;
				end else begin
					clk_cnt <= 25'd0;
					package_cnt <= package_cnt + 1'b1;
					uart_en <= package_cnt == 9? 1'b0:1'b1;
				end 
			end else begin
				clk_cnt <= 25'd0;
				package_cnt <=4'd0;
                uart_en <= 1'b0;
			end
		end
	end
	 
    always@(posedge clk or negedge resetn ) begin
        if(resetn == `RstEnable) begin
            package_addr <= 5'd0;
            package_data <= `ZeroWord;
            package_kind <= 2'd0;
        end else if(package_flag) begin
            case(package_cnt)
            4'd1:begin // reg
                if(regen == 1'b1) begin
                    package_data <= regdata;
                    package_addr <= regaddr;
                end else begin
                    package_addr <= 5'b0;
                    package_data <= `ZeroWord;
                end
                package_kind <= 2'b00;
            end
            4'd2:begin // alu_inst
                package_data <= alu_inst;
                package_addr <= 5'd1;
                package_kind <= 2'b01;
            end
            4'd3:begin//alu_reg1
                package_data <= alu_reg1;
                package_addr <= 5'd2;
                package_kind <= 2'b01;
            end
            4'd4: begin // alu_reg2
                package_data <= alu_reg2;
                package_addr <= 5'd3;
                package_kind <= 2'b01;
            end
            4'd5:begin // alu_result
                package_data <= alu_result;
                package_addr <= 5'd4;
                package_kind <= 2'b01;
            end
            4'd6: begin//inst
                package_data <= inst;
                package_addr <= 5'd1;
                package_kind <= 2'b10;
            end
            4'd7: begin//other_pc
                package_data <= other_pc;
                package_addr <= 5'd1;
                package_kind <= 2'b11;
            end
            4'd8:begin//other_hi
                package_data <= other_hi;
                package_addr <= 5'd2;
                package_kind <= 2'b11;
            end
            4'd9: begin //other_lo
                package_data <= other_lo;
                package_addr <= 5'd3;
                package_kind <= 2'b11;
            end
            endcase
        end else begin
            package_addr <= 5'd0;
            package_data <= `ZeroWord;
            package_kind <= 2'b0;
        end
    end
    
    
     UARTDATA myuartdata(
        .clk(clk),.resetn(resetn),
        .uart_send_en(uart_en),
        .data(package_data),.addr(package_addr),.kind(package_kind),
        .rx(rx),.tx(tx),
        .receive_done(rx_done),.receive_data(rx_data));
   
endmodule
    