`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:36:51 03/11/2019 
// Design Name: 
// Module Name:    CPU 
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

module CPU(
    input wire qclk,
    input wire hresetn,
    input wire artificial,
    input wire rx,
    output reg  clk,
    output [5:0] seg_sel,
    output [7:0] seg_led,
    output tx,
    output led1,
    output led2,
    output led3,
    

    //lcd接口                          
    output          	lcd_hs,         //LCD 行同步信号
    output          	lcd_vs,         //LCD 场同步信号
    output           lcd_de,         //LCD 数据使能
    output    [15:0] lcd_rgb,        //LCD RGB565颜色数据
    output          	lcd_bl,         //LCD 背光控制信号
    output          	lcd_rst,        //LCD 复位信号
    output          	lcd_pclk        //LCD 采样时钟    
  
    );
	//output [31:0] inst
   
    wire sresetn;
    wire mclk;
    
    wire resetn = hresetn & sresetn;
    
	wire [31:0] if_pc,if_inst;
	wire [31:0] id_pc,id_inst;
	
	wire [31:0] reg1_o,reg2_o;
	
	wire [7:0] id_aluop;
	wire [2:0] id_alusel;
	wire [31:0] id_reg1,id_reg2;
	wire [4:0] id_wd;
	wire id_wreg;
	wire [4:0] id_reg1_read,id_reg2_read;
	
	wire [4:0] wb_wd;
	wire [31:0] wb_wdata;
	wire  wb_wreg;
	
	wire [7:0] ex_aluop;
	wire [2:0] ex_alusel;
	wire [31:0] ex_reg1,ex_reg2;
	wire [4:0] ex_wd_i;
	wire ex_wreg_i;
    
	wire [31:0] ex_wdata;
	wire [4:0] ex_wd_o;
	wire ex_wreg_o;
	
	wire [31:0] mem_wdata_i;
	wire [4:0] mem_wd_i;
	wire mem_wreg_i;

	wire [31:0] mem_wdata_o;
	wire [4:0] mem_wd_o;
	wire mem_wreg_o;
	
	wire whilo;
	wire [31:0] hi_i;
	wire [31:0] lo_i;
	wire [31:0] hi_o;
	wire [31:0] lo_o;
	
	wire mem_whilo;
	wire [31:0] mem_hi;
	wire [31:0] mem_lo;
	
	wire ex_whilo;
	wire [31:0] ex_hi;
	wire [31:0] ex_lo;
	
	wire ex_whilo_o;
	wire [31:0] ex_hi_o;
	wire [31:0] ex_lo_o;
	
	wire id_stallreq,ex_stallreq;
	wire [5:0] stall;
	
	wire id_is_in_delayslot_o;
	wire [31:0]id_link_addr_o;
	wire id_next_inst_in_delayslot_o;
	wire [31:0] id_branch_target_address_o;
	wire id_branch_flag_o;
	
	wire id_ex_is_in_delayslot;
	wire [31:0] id_ex_link_address;
	wire id_ex_is_in_delayslot_o;
	
	wire [31:0] id_inst_o;
	wire [31:0] ex_inst_i;
	
	wire  [7:0] exe_aluop_o;
	wire  [31:0] exe_mem_addr_o;
	wire  [31:0] exe_ex_reg2;
	
	wire  [7:0] exe_mem_aluop_o;
	wire  [31:0] exe_mem_mem_addr_o;
	wire  [31:0] exe_mem_ex_reg2;
	
	wire [31:0] mem_data_i;
	
	wire [31:0] mem_mem_addr_o;
	wire mem_mem_we;
	wire [31:0] mem_mem_data;
	
	wire [31:0] mem_cp0_reg_data;
	wire [4:0] mem_cp0_reg_write_addr;
	wire mem_cp0_reg_we;

	wire [31:0] mem_wb_wb_cp0_reg_data;
	wire [4:0] mem_wb_wb_cp0_reg_write_addr;
	wire mem_wb_wb_cp0_reg_we;

	wire [31:0] ex_cp0_reg_data_o;
	wire [4:0] ex_cp0_reg_write_addr_o;
	wire ex_cp0_reg_we_o;

	wire [31:0] ex_mem_mem_cp0_reg_data;
	wire [4:0] ex_mem_mem_cp0_reg_write_addr;
	wire ex_mem_mem_cp0_reg_we;

	wire [31:0] cp0_data_o;
	wire [4:0] ex_cp0_reg_read_addr_o;

	wire [31:0] id_excepttype_o;
	wire [31:0] id_current_inst_addr_o;
	
	wire [31:0] id_ex_ex_excepttype;
	wire [31:0] id_ex_ex_current_inst_addr;
	
	wire [31:0] exe_excepttype_o;
	wire [31:0] exe_current_inst_addr_o;
	wire exe_is_in_delayslot_o;
	
	wire [31:0] ex_mem_mem_excepttype;
	wire [31:0] ex_mem_mem_current_inst_addr;
	wire ex_mem_mem_is_in_delayslot;
	
	wire [31:0] mem_excepttype_o;
	wire [31:0] mem_current_inst_addr_o;
	wire mem_is_in_delayslot_o;
	wire [31:0] mem_cp0_epc_o;
	
	wire [31:0] ctrl_new_pc;
	wire ctrl_flush;
	
	wire [31:0] cp0_status_o;
	wire [31:0] cp0_cause_o;
	wire [31:0] cp0_epc_o;
    
    reg [19:0] clk_count;
    

    
    always @(posedge clk or negedge resetn) begin
        if(resetn == `RstEnable)begin
            clk_count <= 20'b0;
        end else begin
            clk_count <= clk_count + 20'b1;
        end
    end
    
    wire rx_flag;
    wire [7:0] rx_data;
    
    wire sclk;
    
    assign led1 =  artificial;
    
    always @(*) begin
        if(artificial == 1'b1)
            clk <= sclk;
        else 
            clk <= mclk;
    end
    
  
    wire [10:0] rgb_offset;
    wire [15:0] rgb_data;
    RGBSCREEN myrgbscreen(.clk(qclk), .resetn(resetn), 
    
    .rgb_data(rgb_data),
    .rgb_offset(rgb_offset),
    //lcd接口                          
    .lcd_hs(lcd_hs),         //LCD 行同步信号
    .lcd_vs(lcd_vs),         //LCD 场同步信号
    .lcd_de(lcd_de),         //LCD 数据使能
    .lcd_rgb(lcd_rgb),        //LCD RGB565颜色数据
    .lcd_bl(lcd_bl),         //LCD 背光控制信号
    .lcd_rst(lcd_rst),        //LCD 复位信号
    .lcd_pclk(lcd_pclk)        //LCD 采样时钟
    
);


    
    
    CLOCK myclock(.clk(qclk),.resetn(resetn),
                .clock(mclk));
                
    SEG_LED mysegled(.clk(qclk),.resetn(resetn),
                      .data(clk_count),
                     .seg_sel(seg_sel),.seg_control(seg_led));

    UARTPACKAGE myuartpackage(
         .regdata(wb_wdata), .regaddr(wb_wd),.regen(wb_wreg),
         .alu_inst(ex_inst_i), .alu_reg1(ex_reg1),.alu_reg2(ex_reg2),.alu_result(ex_wdata),
         .inst(if_inst),
         .other_pc(if_pc), .other_hi(hi_o),.other_lo(lo_o),  
         .clk(qclk),.resetn(resetn),
         .send_clk(clk),
         .rx(rx),.tx(tx),
         .rx_done(rx_flag),.rx_data(rx_data));
    
    QTCONTROL myqtcontrol(.clk(qclk),.resetn(resetn),
                        .rx_done(rx_flag),.rx_data(rx_data),
        .sresetn(sresetn),.sclk(sclk));
        
	PC mypc(.clk(clk),.resetn(resetn),
			.stall(stall),
			.branch_target_address_i(id_branch_target_address_o),.branch_flag_i(id_branch_flag_o),
			.flush(ctrl_flush),.new_pc(ctrl_new_pc),
			.pc(if_pc));
	
	IM myim(.pc_in(if_pc),
			.inst_out(if_inst),
            .clk(clk));
	
	IF_ID myif_id(.if_pc(if_pc),.if_inst(if_inst),
				.clk(clk),.resetn(resetn),
				.stall(stall),
				.flush(ctrl_flush),
				.id_pc(id_pc),.id_inst(id_inst));
	
	
	ID	myid(.pc_i(id_pc),.inst_i(id_inst),.reg1_data(reg1_o),.reg2_data(reg2_o),
			.resetn(resetn),
			.ex_wdata(ex_wdata),.ex_wd(ex_wd_o),.ex_wreg(ex_wreg_o),
			.mem_wdata(mem_wdata_o),.mem_wd(mem_wd_o),.mem_wreg(mem_wreg_o),
			.is_in_delayslot_i(id_ex_is_in_delayslot_o),
			.ex_aluop_i(exe_aluop_o),
			.aluop_o(id_aluop),.alusel_o(id_alusel),.reg1_o(id_reg1),.reg2_o(id_reg2),
			.wd_o(id_wd),.wreg_o(id_wreg),
			.reg1_read_o(id_reg1_read),.reg2_read_o(id_reg2_read),
			.stallreq(id_stallreq),
			.is_in_delayslot_o(id_is_in_delayslot_o),.link_addr_o(id_link_addr_o),.next_inst_in_delayslot_o(id_next_inst_in_delayslot_o),
			.branch_target_address_o(id_branch_target_address_o),.branch_flag_o(id_branch_flag_o),
			.inst_o(id_inst_o),
			.excepttype_o(id_excepttype_o),.current_inst_addr_o(id_current_inst_addr_o));
		
	REG myreg(.raddr1(id_reg1_read),.raddr2(id_reg2_read),
			.clk(clk),.resetn(resetn),
			.wreg(wb_wreg),.waddr(wb_wd),.wdata(wb_wdata),
			.rdata1(reg1_o),.rdata2(reg2_o));
			
	
	ID_EX myid_ex(.id_aluop(id_aluop),.id_alusel(id_alusel),.id_reg1_i(id_reg1),.id_reg2_i(id_reg2),
					.id_wd_i(id_wd),.id_wreg(id_wreg),
					.clk(clk),.resetn(resetn),
					.stall(stall),
					.flush(ctrl_flush),
					.id_excepttype(id_excepttype_o),.id_current_inst_addr(id_current_inst_addr_o),
					.id_is_in_delayslot(id_is_in_delayslot_o),.id_link_address(id_link_addr_o),.next_inst_in_delayslot_i(id_next_inst_in_delayslot_o),
					.id_inst(id_inst_o),
					.ex_aluop(ex_aluop),.ex_alusel(ex_alusel),.ex_reg1_o(ex_reg1),.ex_reg2_o(ex_reg2),
					.ex_wd_o(ex_wd_i),.ex_wreg(ex_wreg_i),
					.ex_is_in_delayslot(id_ex_is_in_delayslot),.ex_link_address(id_ex_link_address),.is_in_delayslot_o(id_ex_is_in_delayslot_o),
					.ex_inst(ex_inst_i),
					.ex_excepttype(id_ex_ex_excepttype),.ex_current_inst_addr(id_ex_ex_current_inst_addr));
		
	
	EXE myexe(.aluop_i(ex_aluop),.alusel_i(ex_alusel),.reg1_i(ex_reg1),.reg2_i(ex_reg2),.wd_i(ex_wd_i),.wreg_i(ex_wreg_i),
			.hi_i(hi_o),.lo_i(lo_o),
			.wb_whilo_i(whilo),.wb_hi_i(hi_i),.wb_lo_i(lo_i),
			.mem_whilo_i(mem_whilo),.mem_hi_i(mem_hi),.mem_lo_i(mem_lo),
 			.cp0_reg_data_i(cp0_data_o),
 			.mem_cp0_reg_we(mem_cp0_reg_we),.mem_cp0_reg_write_addr(mem_cp0_reg_write_addr),.mem_cp0_reg_data(mem_cp0_reg_data),
			.wb_cp0_reg_we(mem_wb_wb_cp0_reg_we),.wb_cp0_reg_write_addr(mem_wb_wb_cp0_reg_write_addr),.wb_cp0_reg_data(mem_wb_wb_cp0_reg_data),
			.excepttype_i(id_ex_ex_excepttype),.current_inst_addr_i(id_ex_ex_current_inst_addr),
			.resetn(resetn),
			.is_in_delayslot_i(id_ex_is_in_delayslot),.link_address_i(id_ex_link_address),.inst_i(ex_inst_i),
			.wdata_o(ex_wdata),.wd_o(ex_wd_o),.wreg_o(ex_wreg_o),
			.whilo_o(ex_whilo_o),.hi_o(ex_hi_o),.lo_o(ex_lo_o),
			.stallreq(ex_stallreq),.aluop_o(exe_aluop_o),.mem_addr_o(exe_mem_addr_o),.ex_reg2(exe_ex_reg2),
			.cp0_reg_read_addr_o(ex_cp0_reg_read_addr_o),.cp0_reg_we_o(ex_cp0_reg_we_o),.cp0_reg_write_addr_o(ex_cp0_reg_write_addr_o),.cp0_reg_data_o(ex_cp0_reg_data_o),
			.excepttype_o(exe_excepttype_o),.current_inst_addr_o(exe_current_inst_addr_o),.is_in_delayslot_o(exe_is_in_delayslot_o));	
	

	EX_MEM myex_mem(.ex_wdata(ex_wdata),.ex_wd(ex_wd_o),.ex_wreg(ex_wreg_o),
					.ex_whilo(ex_whilo_o),.ex_hi(ex_hi_o),.ex_lo(ex_lo_o),
					.ex_cp0_reg_we(ex_cp0_reg_we_o),.ex_cp0_reg_write_addr(ex_cp0_reg_write_addr_o),.ex_cp0_reg_data(ex_cp0_reg_data_o),
					.clk(clk),.resetn(resetn),
					.stall(stall),
					.ex_aluop(exe_aluop_o),.ex_mem_addr(exe_mem_addr_o),.ex_reg2(exe_ex_reg2),
					.flush(ctrl_flush),
					.ex_excepttype(exe_excepttype_o),.ex_current_inst_addr(exe_current_inst_addr_o),.ex_is_in_delayslot(exe_is_in_delayslot_o),
					.mem_wdata(mem_wdata_i),.mem_wd(mem_wd_i),.mem_wreg(mem_wreg_i),
					.mem_whilo(ex_whilo),.mem_hi(ex_hi),.mem_lo(ex_lo),
					.mem_aluop(exe_mem_aluop_o),.mem_mem_addr(exe_mem_mem_addr_o),.mem_reg2(exe_mem_ex_reg2),
					.mem_cp0_reg_we(ex_mem_mem_cp0_reg_we),.mem_cp0_reg_write_addr(ex_mem_mem_cp0_reg_write_addr),.mem_cp0_reg_data(ex_mem_mem_cp0_reg_data),
					.mem_excepttype(ex_mem_mem_excepttype),.mem_current_inst_addr(ex_mem_mem_current_inst_addr),.mem_is_in_delayslot(ex_mem_mem_is_in_delayslot));
	
	
	MEM mymem(.wdata_i(mem_wdata_i),.wd_i(mem_wd_i),.wreg_i(mem_wreg_i),
			.whilo_i(ex_whilo),.hi_i(ex_hi),.lo_i(ex_lo),
			.cp0_reg_we_i(ex_mem_mem_cp0_reg_we),.cp0_reg_write_addr_i(ex_mem_mem_cp0_reg_write_addr),.cp0_reg_data_i(ex_mem_mem_cp0_reg_data),
			.excepttype_i(ex_mem_mem_excepttype),.current_inst_addr_i(ex_mem_mem_current_inst_addr),.is_in_delayslot_i(ex_mem_mem_is_in_delayslot),
			.cp0_status_i(cp0_status_o),.cp0_cause_i(cp0_cause_o),.cp0_epc_i(cp0_epc_o),
			.wb_cp0_reg_we(mem_wb_wb_cp0_reg_we),.wb_cp0_reg_write_addr(mem_wb_wb_cp0_reg_write_addr),.wb_cp0_reg_data(mem_wb_wb_cp0_reg_data),
			.resetn(resetn),
			.aluop_i(exe_mem_aluop_o),.mem_addr_i(exe_mem_mem_addr_o),.reg2_i(exe_mem_ex_reg2),.mem_data_i(mem_data_i),
			.wdata_o(mem_wdata_o),.wd_o(mem_wd_o),.wreg_o(mem_wreg_o),
			.whilo_o(mem_whilo),.hi_o(mem_hi),.lo_o(mem_lo),
			.mem_addr_o(mem_mem_addr_o),.mem_we_o(mem_mem_we),.mem_data_o(mem_mem_data),
			.cp0_reg_we_o(mem_cp0_reg_we),.cp0_reg_write_addr_o(mem_cp0_reg_write_addr),.cp0_reg_data_o(mem_cp0_reg_data),
			.excepttype_o(mem_excepttype_o),.current_inst_addr_o(mem_current_inst_addr_o),.is_in_delayslot_o(mem_is_in_delayslot_o),.cp0_epc_o(mem_cp0_epc_o));
	


	MEM_WB mymem_wb(.mem_wdata(mem_wdata_o),.mem_wd(mem_wd_o),.mem_wreg(mem_wreg_o),
					.mem_whilo(mem_whilo),.mem_hi(mem_hi),.mem_lo(mem_lo),
					.mem_cp0_reg_we(mem_cp0_reg_we),.mem_cp0_reg_write_addr(mem_cp0_reg_write_addr),.mem_cp0_reg_data(mem_cp0_reg_data),
					.clk(clk),.resetn(resetn),
					.stall(stall),.flush(ctrl_flush),
					.wb_wdata(wb_wdata),.wb_wd(wb_wd),.wb_wreg(wb_wreg),
					.wb_whilo(whilo),.wb_hi(hi_i),.wb_lo(lo_i),
					.wb_cp0_reg_we(mem_wb_wb_cp0_reg_we),.wb_cp0_reg_write_addr(mem_wb_wb_cp0_reg_write_addr),.wb_cp0_reg_data(mem_wb_wb_cp0_reg_data));
	
	HILO myhilo(.we(whilo),.hi_i(hi_i),.lo_i(lo_i),
				.resetn(resetn),.clk(clk),
				.hi_o(hi_o),.lo_o(lo_o));
			
	CTRL myctrl(.resetn(resetn),
				.stallreq_from_id(id_stallreq),.stallreq_from_ex(ex_stallreq),
				.cp0_epc_i(mem_cp0_epc_o),.excepttype_i(mem_excepttype_o),
				.stall(stall),
				.new_pc(ctrl_new_pc),.flush(ctrl_flush));
	
	DATAMEM mydatamem(.addr(mem_mem_addr_o),.data(mem_mem_data),.we(mem_mem_we),
					.clk(clk),
					.data_o(mem_data_i),
                    .rgb_offset(rgb_offset),.rgb_data(rgb_data),.rgb_clk(lcd_pclk));
                    
           
	CP0 mycp0( .we_i(mem_wb_wb_cp0_reg_we),.waddr_i(mem_wb_wb_cp0_reg_write_addr),.wdata_i(mem_wb_wb_cp0_reg_data),
				.int_i(),.raddr_i(ex_cp0_reg_read_addr_o),
				.excepttype_i(mem_excepttype_o),.current_inst_addr_i(mem_current_inst_addr_o),.is_in_delayslot_i(mem_is_in_delayslot_o),
				.resetn(resetn),.clk(clk),
				.data_o(cp0_data_o),
				.count_o(),.compare_o(),.status_o(cp0_status_o),.cause_o(cp0_cause_o),.epc_o(cp0_epc_o),.config_o(),.prid_o(),.timer_int_o());

    
endmodule
