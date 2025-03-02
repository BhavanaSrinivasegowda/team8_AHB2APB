
class ahb_apb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(ahb_apb_scoreboard)

    uvm_tlm_analysis_fifo #(ahb_sequence_item) ahb_fifo;
    uvm_tlm_analysis_fifo #(apb_sequence_item) apb_fifo;

    ahb_sequence_item ahb_data_pkt, ahb_predicted_pkt, current_pkt, ahb_temp_data;
    apb_sequence_item apb_data_pkt, apb_predicted_pkt;

    int selected_slave;  

    int ahb_pkt_count = 0;
    int apb_pkt_count = 0;
    int verified_data_count = 0;

    covergroup cov_group;
        option.per_instance = 1;
        reset      : coverpoint current_pkt.HRESETn  { bins reset_val = {0}; }
        bus_write      : coverpoint current_pkt.HWRITE   { bins write_val = {1}; }
        bus_read       : coverpoint current_pkt.HWRITE   { bins read_val  = {0}; }
 
        trans_type    : coverpoint current_pkt.HTRANS {
            bins idle_val   = {2'b00};
            bins nonseq_val = {2'b10};
            bins seq_val    = {2'b11};
        }
        WRITE_COVERAGE: cross bus_write, trans_type;
        READ_COVERAGE : cross bus_read, trans_type;
    endgroup

    function new (string sb_name, uvm_component sb_parent);
        super.new(sb_name, sb_parent);
        ahb_fifo = new("ahb_fifo", this);
        apb_fifo = new("apb_fifo", this);

        ahb_predicted_pkt = ahb_sequence_item::type_id::create("ahb_predicted_pkt", this);
        apb_predicted_pkt = apb_sequence_item::type_id::create("apb_predicted_pkt", this);
        ahb_temp_data = ahb_sequence_item::type_id::create("ahb_temp_data", this);
        cov_group = new;
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            ahb_fifo.get(ahb_data_pkt);
            ahb_pkt_count++;
            `uvm_info (get_type_name, $sformatf("[%0d] Scoreboard sampled ahb_data_pkt\n%s", ahb_pkt_count, ahb_data_pkt.sprint()), UVM_MEDIUM);

            apb_fifo.get(apb_data_pkt);
            apb_pkt_count++;
            `uvm_info (get_type_name, $sformatf("[%0d] Scoreboard sampled apb_data_pkt\n%s", apb_pkt_count, apb_data_pkt.sprint()), UVM_MEDIUM);

            predict_data();

            current_pkt = ahb_data_pkt;
            cov_group.sample();
        end
    endtask

    task predict_data();
        if(ahb_data_pkt.HRESETn == 1'b0) return;

        if(ahb_data_pkt.HTRANS == 2'b10) begin
            ahb_temp_data.HADDR  = ahb_data_pkt.HADDR;
            ahb_temp_data.HWRITE = ahb_data_pkt.HWRITE;
        end 
        else if (ahb_data_pkt.HTRANS inside {2'b11, 2'b00}) begin
            apb_predicted_pkt.PADDR  = ahb_temp_data.HADDR;
            apb_predicted_pkt.PWRITE = ahb_temp_data.HWRITE;
            apb_predicted_pkt.PWDATA = ahb_data_pkt.HWDATA;

            configure_pselx();

            ahb_temp_data.HADDR  = ahb_data_pkt.HADDR;
            ahb_temp_data.HWRITE = ahb_data_pkt.HWRITE;          

            check_apb_data();  
        end

        if(apb_data_pkt.PENABLE == 1'b1 & apb_data_pkt.PWRITE == 1'b0) begin
            ahb_predicted_pkt.HRDATA = apb_data_pkt.PRDATA[selected_slave];
            
            check_ahb_data();
        end
    endtask

    task configure_pselx();
        if(ahb_temp_data.HADDR inside {[32'h000:32'h0FF]}) apb_predicted_pkt.PSELx = 8'h01;
        else if (ahb_temp_data.HADDR inside {[32'h100:32'h1FF]}) apb_predicted_pkt.PSELx = 8'h02;
    endtask

    task check_apb_data();
        if(apb_predicted_pkt.PADDR  == apb_data_pkt.PADDR);
        if(apb_predicted_pkt.PWRITE == apb_data_pkt.PWRITE);
        if(apb_predicted_pkt.PSELx  == apb_data_pkt.PSELx);
        if(apb_predicted_pkt.PWDATA == apb_data_pkt.PWDATA);
        verified_data_count++;
    endtask

    task check_ahb_data();
        if(ahb_predicted_pkt.HRDATA == ahb_data_pkt.HRDATA);
        verified_data_count++;
    endtask

    function void report_phase(uvm_phase phase);
        $display("\n=== Scoreboard Summary ===");
        $display("AHB Packets: %0d",ahb_pkt_count);
        $display("APB Packets: %0d", apb_pkt_count);
        $display("Verified Transactions: %d",verified_data_count);
        $display("Unverified Transactions: %d", (ahb_pkt_count-verified_data_count));

        $display("=== Coverage Report ===");
        $display("RESET: %0f%%", cov_group.reset.get_coverage());
        $display("WRITE: %0f%%", cov_group.bus_write.get_coverage());
        $display("READ: %0f%%", cov_group.bus_read.get_coverage());
        $display("=== End of Summary ===\n");
    endfunction

endclass
