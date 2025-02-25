import uvm_pkg::*;
`include "uvm_macros.svh"

int N_TX = 500;  // Set the number of transactions to be generated, change/adjust this as needed
 
`include "ahb_sequence_item.sv"
`include "apb_sequence_item.sv"
`include "ahb_apb_env_config.sv"

`include "ahb_sequencer.sv"
`include "ahb_driver.sv"
`include "ahb_monitor.sv"
`include "ahb_agent.sv"

`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"

`include "ahb_apb_scoreboard.sv"
`include "ahb_apb_env.sv"

`include "ahb_sequence.sv"
`include "apb_sequence.sv"
`include "ahb_apb_test.sv"
`include "ahb_apb_single_test.sv"

module tb_top();
    bit clk;
    ahb_intf AHB_INF (clk);  // AHB interface
    apb_intf APB_INF (clk);  // APB interface

    bridge_top DUT (
        .Hclk(clk),
        .Hresetn(AHB_INF.HRESETn),
        .Hwrite(AHB_INF.HWRITE),
        .Hreadyin(1'b1),           	// Always ready (no wait states implemented)
        .Htrans(AHB_INF.HTRANS),
        .Hwdata(AHB_INF.HWDATA),
        .Haddr(AHB_INF.HADDR),
        .Hrdata(AHB_INF.HRDATA),
        .Hresp(AHB_INF.HRESP),
        .Hreadyout(AHB_INF.HREADY),

        .Prdata(APB_INF.PRDATA[0]),	
        .Pwdata(APB_INF.PWDATA),
        .Paddr(APB_INF.PADDR),
        .Pselx(APB_INF.PSELx[2:0]),
        .Pwrite(APB_INF.PWRITE),
        .Penable(APB_INF.PENABLE)
    );

    initial begin
        uvm_config_db # (virtual ahb_intf)::set(null,"*","ahb_vif",AHB_INF); 
        uvm_config_db # (virtual apb_intf)::set(null,"*","apb_vif",APB_INF);

        run_test("ahb_apb_single_write_test");
        run_test("ahb_apb_single_read_test");
    end

    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end
endmodule
