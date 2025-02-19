
ifdef CADENCE 

  VCS_HOME = /pgs/cadence/vcs/...
  
  # define VCS compile, simulate commands

else

  QUESTA_HOME = /pkgs/mentor/questa/2024.2/questasim/

  VLIB = $(QUESTA_HOME)/bin/vlib
  VMAP = $(QUESTA_HOME)/bin/vmap
  VLOG = $(QUESTA_HOME)/bin/vlog -lint +acc=all -work work 
  VOPT = $(QUESTA_HOME)/bin/vopt 
  VSIM = $(QUESTA_HOME)/bin/vsim -voptargs=+acc -work work 
  
endif

HW   = ./

.PHONY: all compile sim gui clean

all: 
	@echo " "
	@echo " make targets are: "
	@echo "   - sim "
	@echo "   - gui "
	@echo "   - compile "
	@echo "   - clean "
	@echo " "

gui: compile
	$(VSIM) -do run.do ahb_apb_top

sim: compile
	$(VSIM) -c -do run.do ahb_apb_top

compile: clean
	rm -rf ./work

	$(VLIB) ./work
	$(VMAP) work ./work

	# add list of files to complie here
	$(VLOG) $(HW)/AHB_Master.sv
	$(VLOG) $(HW)/AHB_Slave_Interface.sv
	$(VLOG) $(HW)/APB_Controller.sv
	$(VLOG) $(HW)/APB_Interface.sv
	$(VLOG) $(HW)/bridge_top.sv
	$(VLOG) ../TB/top.sv

CRUFT  = transcript
CRUFT += *.wlf
CRUFT += work
CRUFT += modelsim.ini

clean:
	rm -rf $(CRUFT)
