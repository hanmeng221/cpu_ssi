transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/altera/13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/altera/13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/altera/13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {c:/altera/13.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/IM.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/define.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/CPU.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/REG.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/PC.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/MEM_WB.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/MEM.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/IF_ID.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/ID_EX.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/ID.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/HILO.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/EXE.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/EX_MEM.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/DATAMEM.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/CTRL.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/CP0.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/CLOCK.v}
vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/rtl {E:/fpga/muliplyCPU/rtl/SEG_LED.v}

vlog -vlog01compat -work work +incdir+E:/fpga/muliplyCPU/par/simulation/modelsim {E:/fpga/muliplyCPU/par/simulation/modelsim/CPU.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  CPU_vlg_tst

add wave *
view structure
view signals
run -all
