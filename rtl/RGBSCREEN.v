`include "define.v"

module RGBSCREEN(
    input    wire       clk,        //系统时钟
    input    wire       resetn,      //复位信号
    input  [15:0]       rgb_data,
    output reg [10:0]    rgb_offset,
    output          	lcd_hs,         //LCD 行同步信号
    output          	lcd_vs,         //LCD 场同步信号
    output              lcd_de,         //LCD 数据使能
    output       [15:0] lcd_rgb,        //LCD RGB565颜色数据
    output          	lcd_bl,         //LCD 背光控制信号
    output          	lcd_rst,        //LCD 复位信号
    output          	lcd_pclk        //LCD 采样时钟
    );
	


//wire define
wire         lcd_clk_w;             //PLL分频得到9Mhz时钟
wire         locked_w;              //PLL输出稳定信号
wire         rst_n_w;               //内部复位信号
    

assign rst_n_w = resetn & locked_w;

pll_clk	mypll_clk(                  //时钟分频模块
	.inclk0         (clk),    
	.areset         (~resetn),
    
	.c0             (lcd_clk_w),    //lcd驱动时钟
	.locked         (locked_w)
	); 

	//reg define                                     
reg  [10:0] cnt_h;
reg  [10:0] cnt_v;

//wire define
wire       lcd_en;
wire       data_req; 


parameter  H_SYNC   =  11'd41;   //行同步
parameter  H_BACK   =  11'd2;    //行显示后沿
parameter  H_DISP   =  11'd480;   //行有效数据
parameter  H_FRONT  =  11'd2;    //行显示前沿
parameter  H_TOTAL  =  11'd525;  //行扫描周期

parameter  V_SYNC   =  11'd10;     //场同步
parameter  V_BACK   =  11'd2;    //场显示后沿
parameter  V_DISP   =  11'd272;   //场有效数据
parameter  V_FRONT  =  11'd2;    //场显示前沿
parameter  V_TOTAL  =  11'd286;   //场扫描周期

assign lcd_bl   = 1'b1;           //RGB LCD显示模块背光控制信号
assign lcd_rst  = 1'b1;           //RGB LCD显示模块系统复位信号
assign lcd_pclk = lcd_clk_w;        //RGB LCD显示模块采样时钟

assign lcd_de  = lcd_en;          //LCD输入的颜色数据采用数据输入使能信号同步
assign lcd_hs  = 1'b1;            //RGB LCD 采用数据输入使能信号同步时，
assign lcd_vs  = 1'b1;            //行场同步信号需要拉高

assign lcd_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                 &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                 ?  1'b1 : 1'b0;

                 
assign lcd_rgb = lcd_en ? rgb_data : 16'd0;

assign data_req = (((cnt_h >= H_SYNC+H_BACK-1'b1) && (cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
                  && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                  ?  1'b1 : 1'b0;
				  
wire [10:0] pixel_xpos;
wire [10:0] pixel_ypos;    
assign pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 11'd0;
assign pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 11'd0;


always @(posedge lcd_clk_w or negedge rst_n_w) begin         
    if (rst_n_w == `RstEnable) begin
        cnt_h <= 11'd0;             
	end else begin
        if(cnt_h < H_TOTAL - 1'b1) begin                                            
            cnt_h <= cnt_h + 1'b1;                               
        end else begin 
            cnt_h <= 11'd0;
        end  
    end
end

always @(posedge lcd_clk_w or negedge rst_n_w) begin         
    if (rst_n_w == `RstEnable) begin
        cnt_v <= 11'd0;                                  
    end else if(cnt_h == H_TOTAL - 1'b1) begin
        if(cnt_v < V_TOTAL - 1'b1)                                               
            cnt_v <= cnt_v + 1'b1;                               
        else 
            cnt_v <= 11'd0;  
    end
end

always @(posedge lcd_clk_w or negedge rst_n_w) begin         
    if (rst_n_w == `RstEnable)
        rgb_offset <= 11'd0;
    else begin
        if((pixel_xpos >= 0) && (pixel_xpos < (H_DISP/5)*1)) begin
            if((pixel_ypos >= 0) && (pixel_ypos < (V_DISP/3)*1)) begin
                rgb_offset <= 11'd0;
            end else if(((pixel_ypos >= (V_DISP/3)*1)) && (pixel_ypos < ((V_DISP/3)*2))) begin
                rgb_offset <= 11'd2;
            end else begin
                rgb_offset <= 11'd4;
            end
        end else if((pixel_xpos >= (H_DISP/5)*1) && (pixel_xpos < (H_DISP/5)*2)) begin
            if((pixel_ypos >= 0) && (pixel_ypos < (V_DISP/3)*1)) begin
                rgb_offset <= 11'd6;
            end else if(((pixel_ypos >= (V_DISP/3)*1)) && (pixel_ypos < ((V_DISP/3)*2))) begin
                rgb_offset <= 11'd8;
            end else begin
                rgb_offset <= 11'd10;
            end  
        end else if((pixel_xpos >= (H_DISP/5)*2) && (pixel_xpos < (H_DISP/5)*3)) begin
            if((pixel_ypos >= 0) && (pixel_ypos < (V_DISP/3)*1)) begin
                rgb_offset <= 11'd12;
            end else if(((pixel_ypos >= (V_DISP/3)*1)) && (pixel_ypos < ((V_DISP/3)*2))) begin
                rgb_offset <= 11'd14;
            end else begin
                rgb_offset <= 11'd16;
            end
        end else if((pixel_xpos >= (H_DISP/5)*3) && (pixel_xpos < (H_DISP/5)*4)) begin
            if((pixel_ypos >= 0) && (pixel_ypos < (V_DISP/3)*1)) begin
                rgb_offset <= 11'd18;
            end else if(((pixel_ypos >= (V_DISP/3)*1)) && (pixel_ypos < ((V_DISP/3)*2))) begin
                rgb_offset <= 11'd20;
            end else begin
                rgb_offset <= 11'd22;
            end
        end else begin
            if((pixel_ypos >= 0) && (pixel_ypos < (V_DISP/3)*1)) begin
                rgb_offset <= 11'd24;
            end else if(((pixel_ypos >= (V_DISP/3)*1)) && (pixel_ypos < ((V_DISP/3)*2))) begin
                rgb_offset <= 11'd26;
            end else begin
                rgb_offset <= 11'd28;
            end
        end
    end
end


endmodule
