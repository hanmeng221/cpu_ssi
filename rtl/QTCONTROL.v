module QTCONTROL(
    input wire clk,
    input wire resetn,
    input wire rx_done,
    input wire [7:0] rx_data,
    output reg sresetn,
    output reg sclk
    );
	
    reg clk_flag;
    reg [24:0] clk_count;
    always @(posedge clk or negedge resetn ) begin
        if(resetn == `RstEnable) begin
            clk_flag <= 1'b0;
            sresetn <= `RstDisable;
        end else if(rx_done) begin
            case(rx_data)
            
            8'b01100111:begin//g
                
            end
            8'b01110000:begin //p
                clk_flag <= 1'b1;
            end
            8'b01110010:begin //r
                sresetn <= `RstEnable;
            end
            endcase
        end else begin
            sresetn <= `RstDisable;
            clk_flag <= 1'b0;
        end
    end
    
    reg clk_flag_d1;
    reg clk_flag_d0;
    
    reg clk_start_count;
    
    
    wire clk_start;
    assign clk_start  = (~clk_flag_d1) & clk_flag_d0;
    
    always@(posedge clk or negedge resetn ) begin
        if(resetn == `RstEnable) begin
            clk_flag_d0 <= 1'b0;
            clk_flag_d1 <= 1'b0;
        end else begin
            clk_flag_d0 <= clk_flag;
            clk_flag_d1 <= clk_flag_d0;
        end
    end
    
    always @(posedge clk or negedge resetn ) begin
        if(resetn == `RstEnable) begin
            clk_start_count <= 1'b0;
        end else begin
            if(clk_start == 1'b1) begin
                clk_start_count <= 1'b1;
            end else if(clk_count == 25'd24999999) begin
                clk_start_count <= 1'b0;
            end
        end
    end
    
    always @(posedge clk or negedge resetn ) begin
        if(resetn == `RstEnable) begin
            sclk <= 1'b0;
            clk_count <= 25'b0;
        end else begin
            if(clk_start_count == 1'b1) begin
                clk_count <= clk_count + 1;
                sclk <= 1'b1;
            end else begin
                sclk <= 1'b0;
                clk_count <= 25'd0;
            end
        end
    end
    
endmodule