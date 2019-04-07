module SEG_LED(
    input wire clk,
    input wire resetn,
	input wire [19:0] data,
	output reg [5:0] seg_sel,
    output reg [7:0] seg_control
    );
	reg [19:0] cnt;
    reg flag;
    reg    [2:0]              cnt_sel ;
    wire   [23:0]              num    ;      
         
    wire   [3:0]              num1    ;        
    wire   [3:0]              num2    ;        
    wire   [3:0]              num3    ;        
    wire   [3:0]              num4    ;        
    wire   [3:0]              num5    ;        
    wire   [3:0]              num6    ;   
    
    assign  num =  {num1,num2,num3,num4,num5,num6};
    
    assign  num1 =    (data / 17'd100000) ; 
    assign  num2  =   (data / 14'd10000 % 4'd10) ;
    assign  num3  =   (data / 10'd1000 % 4'd10) ;
    assign  num4 =     (data / 7'd100 % 4'd10);
    assign  num5 =     (data / 4'd10 % 4'd10);
    assign  num6 =     (data % 4'd10);
    


    
    reg [3:0] num_disp;
    
    always @ (posedge clk or negedge resetn) begin
        if ( resetn == `RstEnable) begin
            cnt <= 20'b0;
            flag<= 1'b0;
        end else if (cnt == 20'd5_0000 ) begin
        //end else if (cnt == 20'd10 ) begin
            cnt <= 20'b0;
            flag <= ~flag;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
    
    always @ (posedge flag or negedge resetn) begin
        if (resetn == `RstEnable) begin
            cnt_sel <= 3'b0;
        end else begin
            if(cnt_sel < 3'd5)
                cnt_sel <= cnt_sel + 1'b1;
            else
                cnt_sel <= 3'b0;
        end
    end
    
    always @ (posedge flag  or negedge resetn) begin
        if(resetn == `RstEnable) begin
        seg_sel  <= 6'b111111;              //位选信号低电平有效
        end else begin
            case (cnt_sel)
                3'd0 :begin
                    seg_sel  <= 6'b011111;  //显示数码管最低位
                    num_disp <= num[3:0] ;  //显示的数据
                 
                end
                3'd1 :begin
                    seg_sel  <= 6'b111110;  //显示数码管第1位
                    num_disp <= num[7:4] ;
                  
                end
                3'd2 :begin
                    seg_sel  <= 6'b111101;  //显示数码管第2位
                    num_disp <= num[11:8];
                 
                end
                3'd3 :begin
                    seg_sel  <= 6'b111011;  //显示数码管第3位
                    num_disp <= num[15:12];
                    
                end
                3'd4 :begin
                    seg_sel  <= 6'b110111;  //显示数码管第4位
                    num_disp <= num[19:16];
                  
                end
                3'd5 :begin
                    seg_sel  <= 6'b101111;  //显示数码管最高位
                    num_disp <= num[23:20];
                  
                end
                default :begin
                    seg_sel  <= 6'b111111;
                    num_disp <= 4'b0;
                   
                end
            endcase
        end
    end
    
    always @ (posedge flag or negedge resetn) begin
        if (resetn == `RstEnable) begin
            seg_control <= 8'hc0;
        end else begin
            case (num_disp)
                4'd0 : seg_control <= 8'b11000000; //显示数字 0
                4'd1 : seg_control <= 8'b11111001; //显示数字 1
                4'd2 : seg_control <= 8'b10100100; //显示数字 2
                4'd3 : seg_control <= 8'b10110000; //显示数字 3
                4'd4 : seg_control <= 8'b10011001; //显示数字 4
                4'd5 : seg_control <= 8'b10010010; //显示数字 5
                4'd6 : seg_control <= 8'b10000010; //显示数字 6
                4'd7 : seg_control <= 8'b11111000; //显示数字 7
                4'd8 : seg_control <= 8'b10000000; //显示数字 8
                4'd9 : seg_control <= 8'b10010000; //显示数字 9
                default: 
                   seg_control <= {8'b00000000};
            endcase
        end
    end
    
    
endmodule
