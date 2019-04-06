module UARTDATA(
	input clk,
	input resetn,
	input uart_send_en,
	input [31:0] data,
	input [4:0] addr,
	input [1:0] kind,
	input rx,
	output tx,
	output done
);

	wire legal = data2[0] ^  data3[0] ^ data4[0] ^ data5[0] ^ data6[0];
	wire [7:0] data1 = {2'b10,legal,addr};
	wire [7:0] data2 = {1'b0,data[30:24]};
	wire [7:0] data3 = {1'b0,data[22:16]};
	wire [7:0] data4 = {1'b0,data[14:8]};
	wire [7:0] data5 = {1'b0,data[6:0]};
	wire [7:0] data6 = {2'b11,kind,data[31],data[23],data[15],data[7]};
	
	
	reg [2:0] tosend_cnt;

	reg send_en_d0;
	reg send_en_d1;
	
	reg [7:0] send_data;
	
	wire send_flag;
	
	reg uart_flag;
	
	reg uart_en;
	reg [24:0] clk_cnt;
	assign send_flag = (~send_en_d1) & send_en_d0;
	
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			send_en_d0 <= 1'b0;
			send_en_d1 <= 1'b0;
		end else begin
			send_en_d0 <= uart_send_en;
			send_en_d1 <= send_en_d0;
		end
	end
	
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin	
			uart_flag <= 1'b0;
		end else begin
			if(send_flag) begin
				uart_flag <= 1'b1;
			end else if((tosend_cnt == 3'd7) && (clk_cnt == 25'd2604)) begin
				uart_flag <= 1'b0;
			end
		end
	end
	
	always @(posedge clk) begin
		if (resetn == `RstEnable) begin
			clk_cnt <= 25'd0;
			tosend_cnt <= 3'd0;
			uart_en <= 1'b0;
		end else begin
			if(uart_flag) begin
				if(clk_cnt <  25'd5207 ) begin
					clk_cnt <= clk_cnt + 1'b1;
					uart_en <= 1'b0;
				end else begin
					clk_cnt <= 25'd0;
					tosend_cnt <= tosend_cnt + 1'b1;
					uart_en <= tosend_cnt == 6? 1'b0:1'b1;
				end 
			end else begin
				clk_cnt <= 25'd0;
				tosend_cnt <=3'd0;
                uart_en <= 1'b0;
			end
		end
	end
	
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			send_data <= 8'd0;
		end else if(uart_flag) begin
			case(tosend_cnt)
			3'd1: send_data <= data1;
			3'd2: send_data <= data2;
			3'd3: send_data <= data3;
			3'd4: send_data <= data4;
			3'd5: send_data <= data5;
			3'd6: send_data <= data6;
			endcase
		end else begin
			send_data <= 8'd0;
		end
	end
	
	UART myuart(.clk(clk),.resetn(resetn),
                .uart_send_en(uart_en),.uart_din(send_data),
                .uart_rxd(rx),.uart_done(),.uart_data(),
                .uart_txd(tx));
    
	
endmodule








		

