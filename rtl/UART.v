module UART(
	input clk,
	input resetn,
	input uart_send_en,
	input [7:0] uart_din,
	
	input uart_rxd,
	output reg uart_done,
	output reg [7:0] uart_data,
	
	output reg uart_txd
);

	parameter CLK_FREQ = 50000000;
	parameter UART_BPS = 115200;
	localparam BPS_CNT  = CLK_FREQ/UART_BPS;
	
	reg uart_rxd_d0; 
	reg uart_rxd_d1;
	reg [15:0] clk_cnt_rx;
	reg [15:0] clk_cnt_tx;
	reg [3:0] rx_cnt;
	reg rx_flag;
	reg [7:0] rxdata;
	
	reg uart_en_d0;
	reg uart_en_d1;
	reg [3:0] tx_cnt;
	reg tx_flag;
	reg [7:0] tx_data;
	
	wire start_flag;
	
	wire en_flag;
	
	assign start_flag = uart_rxd_d1 & (~uart_rxd_d0);
	assign en_flag = (~uart_en_d1) & uart_en_d0;
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			uart_rxd_d0 <= 1'b0;
			uart_rxd_d1 <= 1'b0;
			
			uart_en_d0 <= 1'b0;
			uart_en_d1 <= 1'b0;
		end else begin
			uart_rxd_d0 <= uart_rxd;
			uart_rxd_d1 <= uart_rxd_d0;
			
			uart_en_d0 <= uart_send_en;
			uart_en_d1 <= uart_en_d0;
		end
	end
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin	
			rx_flag <= 1'b0;
			
		end else begin
			if(start_flag) begin
				rx_flag <= 1'b1;
			end else if((rx_cnt == 4'd9) && (clk_cnt_rx == BPS_CNT/2)) begin
				rx_flag <= 1'b0;
			end
		end
	end
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin	
			tx_flag <= 1'b0;
			tx_data <= 8'd0;
		end else begin
			if(en_flag) begin
				tx_flag <= 1'b1;
				tx_data <= uart_din;
			end else if((tx_cnt == 4'd9) && (clk_cnt_tx == BPS_CNT/2)) begin
				tx_flag <= 1'b0;
				tx_data <= 8'd0;
			end
		end
	end
	
	always @(posedge clk) begin
		if (resetn == `RstEnable) begin
			clk_cnt_rx <= 16'd0;
			clk_cnt_tx <= 16'd0;
			rx_cnt <= 4'd0;
			tx_cnt <= 4'd0;
		end else begin
			if(rx_flag) begin
				if(clk_cnt_rx <  BPS_CNT -1 ) begin
					clk_cnt_rx <= clk_cnt_rx + 1'b1;
				end else begin
					clk_cnt_rx <= 16'd0;
					rx_cnt <= rx_cnt + 1'b1;
				end
			end else begin
				clk_cnt_rx <= 16'd0;
				rx_cnt <=4'd0;
			end
			if(tx_flag) begin
				if(clk_cnt_tx <  BPS_CNT -1 ) begin
					clk_cnt_tx <= clk_cnt_tx + 1'b1;
				end else begin
					clk_cnt_tx <= 16'd0;
					tx_cnt <= tx_cnt + 1'b1;
				end
			end else begin
				clk_cnt_tx <= 16'd0;
				tx_cnt <=4'd0;
			end
		end
	end
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			rxdata <= 8'd0;
		end else if(rx_flag) begin
			if(clk_cnt_rx == BPS_CNT/2) begin
				case(rx_cnt)
				4'd1: rxdata[0] <= uart_rxd_d1;
				4'd2: rxdata[1] <= uart_rxd_d1;
				4'd3: rxdata[2] <= uart_rxd_d1;
				4'd4: rxdata[3] <= uart_rxd_d1;
				4'd5: rxdata[4] <= uart_rxd_d1;
				4'd6: rxdata[5] <= uart_rxd_d1;
				4'd7: rxdata[6] <= uart_rxd_d1;
				4'd8: rxdata[7] <= uart_rxd_d1;
				default:begin
				end
				endcase
			end
		end else begin
			rxdata <= 8'd0;
		end
	end
	
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			uart_txd <= 1'b1;
		end else if(tx_flag)
			case (tx_cnt)
				4'd0: uart_txd <= 1'b0;
				4'd1: uart_txd <= tx_data[0];
				4'd2: uart_txd <= tx_data[1];
				4'd3: uart_txd <= tx_data[2];
				4'd4: uart_txd <= tx_data[3];
				4'd5: uart_txd <= tx_data[4];
				4'd6: uart_txd <= tx_data[5];
				4'd7: uart_txd <= tx_data[6];
				4'd8: uart_txd <= tx_data[7];
				4'd9: uart_txd <= 1'b1;
				default: begin
				end
			endcase
		else begin
			uart_txd <= 1'b1;
		end
	end
				
	always @(posedge clk) begin
		if(resetn == `RstEnable) begin
			uart_data <= 8'd0;
			uart_done <= 1'b0;
		end else if(rx_cnt == 4'd9) begin
			uart_data <= rxdata;
			uart_done <= 1'b1;
		end else begin
			uart_data <= 8'd0;
			uart_done <= 1'b0;
		end
	end
	
endmodule








		

