vlib test1
vmap work test1
vlog -work test1 AHB_Master.sv
vlog -work test1 AHB_Slave_Interface.sv
vlog -work test1 APB_Controller.sv
vlog -work test1 APB_Interface.sv
vlog -work test1 bridge_top.sv
vsim -voptargs=+acc work.top_tb
add wave -r *
run -all
