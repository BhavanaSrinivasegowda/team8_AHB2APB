
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)
    ahb_apb_env_config env_config_h;

    apb_sequencer sequencer_h;
    apb_driver    drv_h;
    apb_monitor   mon_h;

    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db # (ahb_apb_env_config) :: get(this, "", "ahb_apb_env_config", env_config_h))
            `uvm_fatal("config", "Failed to retrieve env_config_h from uvm_config_db")

        mon_h = apb_monitor::type_id::create("mon_h", this);

        if (env_config_h.apb_agent_is_active == UVM_ACTIVE) begin
            drv_h = apb_driver::type_id::create("drv_h", this);
            sequencer_h = apb_sequencer::type_id::create("sequencer_h", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if (env_config_h.apb_agent_is_active == UVM_ACTIVE) begin
            drv_h.seq_item_port.connect(sequencer_h.seq_item_export);
        end
    endfunction

endclass
