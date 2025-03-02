class ahb_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_monitor)

    virtual              ahb_intf.ahb_monitor mon_intf;
    ahb_sequence_item    mon2sb;
    ahb_apb_env_config   env_config_h;

    uvm_analysis_port # (ahb_sequence_item) monitor_port;

    function new (string name = "ahb_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db # (ahb_apb_env_config) :: get(this, "", "ahb_apb_env_config", env_config_h))
            `uvm_fatal(get_type_name, "can't retrieve env_config from uvm_config_db")
        
        monitor_port = new("monitor_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        mon_intf = env_config_h.ahb_vif;
    endfunction

    task run_phase(uvm_phase phase);
        @(posedge mon_intf.clk);
        forever
            monitor_transaction();
    endtask

    task monitor_transaction();
        begin
            @(posedge mon_intf.clk);
            
            mon2sb = ahb_sequence_item::type_id::create("mon2sb", this);

            mon2sb.HRESETn  = mon_intf.ahb_monitor_cb.HRESETn;
            mon2sb.HADDR    = mon_intf.ahb_monitor_cb.HADDR;
            mon2sb.HTRANS   = mon_intf.ahb_monitor_cb.HTRANS;
            mon2sb.HWRITE   = mon_intf.ahb_monitor_cb.HWRITE;
            mon2sb.HWDATA   = mon_intf.ahb_monitor_cb.HWDATA;
            mon2sb.HSELAHB  = mon_intf.ahb_monitor_cb.HSELAHB;
            mon2sb.HRDATA   = mon_intf.ahb_monitor_cb.HRDATA;
            mon2sb.HREADY   = mon_intf.ahb_monitor_cb.HREADY;
            mon2sb.HRESP    = mon_intf.ahb_monitor_cb.HRESP;

            `uvm_info(get_type_name, $sformatf("AHB monitor captured TX: \n%s", mon2sb.sprint()), UVM_MEDIUM)
            monitor_port.write(mon2sb);
        end     
    endtask
endclass
