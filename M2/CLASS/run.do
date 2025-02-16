if [file exists "work"] {vdel -all}
vlib work

vlog AHB_Master.sv
vlog AHB_Slave_Interface.sv
vlog APB_Controller.sv
vlog APB_Interface.sv
vlog bridge_top.sv
vlog ../TB/top.sv

vopt ahb_apb_top -o top_optimized  +acc +cover=sbfec+bridge_top(rtl).
vsim top_optimized -coverage
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

# Waveform Logging
if {[file exists "wave.do"]} { source wave.do }

run -all

coverage save project.ucdb
vcover report project.ucdb 
vcover report project.ucdb -cvg -details
quit