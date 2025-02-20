//The ahb_apb_top module serves as the testbench’s top-level module, integrating all essential
//components for verifying the bridge_top DUT (Design Under Test). It includes a clock generator
//producing a 5 ns period clock signal and an ahb_apb_bfm_if interface to facilitate communication
//between the DUT and testbench.
//
//The testbench instantiates and connects the DUT, mapping its ports to the interface signals.
//Additionally, a test instance (test_h) is created to drive the verification process, generating
//transactions, sampling coverage, and executing the test sequence. The initial block handles reset
//initialization and starts the simulation. After a defined simulation runtime, $stop is invoked to
//terminate execution.

//----------------------------------------------------------------------------------------------------------


`include "transactions.sv"
`include "generator.sv"
`include "interface.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"
`include "test.sv"  
`include "../CLASS/bridge_top.sv"  

module ahb_apb_top;

  logic clk, reset;

  // Generates clk with a time period of 5 ns
  always
  begin
    forever begin
      #5 clk = ~clk;
    end
  end

  ahb_apb_bfm_if bfm(clk, reset); // Connect clock and reset


  // Connecting DUT signals with signals present on the interface
// Connecting DUT signals with signals present on the interface
bridge_top dut(
    .Hclk(bfm.clk),
    .Hresetn(bfm.resetn),
    .Hwrite(bfm.Hwrite),
    .Hreadyin(bfm.Hreadyin),
    .Htrans(bfm.Htrans),
    .Hwdata(bfm.Hwdata),
    .Haddr(bfm.Haddr),
    .Hrdata(bfm.Hrdata),
    .Hresp(bfm.Hresp),
    .Hreadyout(bfm.Hreadyout),
    .Prdata(bfm.Prdata),
    .Pwdata(bfm.Pwdata),
    .Paddr(bfm.Paddr),
    .Pselx(bfm.Pselx),
    .Pwrite(bfm.Pwrite),
    .Penable(bfm.Penable)
);


  // test ahb_apb_test(bfm); // -> not initialized
    test test_h;
    Transaction trans;
  initial begin
    $display("in top");
    trans = new();
    trans.cov_cg.sample();  // -> to get the coverage
	test_h = new(bfm);
	test_h.run();

	
  end

 // Initialize clk and reset
  initial begin
    clk = 1;
    reset = 0;
    #10
    reset = 1;
	

    #100000;
    $stop; // Stops simulation
  end

endmodule

