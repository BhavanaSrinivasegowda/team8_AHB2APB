class ahb_apb_env extends uvm_env;
    `uvm_component_utils(ahb_apb_env)

    ahb_apb_env_config          env_config_h;
    ahb_agent                   ahb_agent_h;
    apb_agent                   apb_agent_h;
    ahb_apb_scoreboard          sb_h;  

    function new(string name = "ahb_apb_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db # (ahb_apb_env_config)::get(this, "*", "ahb_apb_env_config", env_config_h))
            `uvm_fatal(get_type_name, "can't get env_config from uvm_config_db")

        if(env_config_h.ahb_agent_enabled)
            ahb_agent_h = ahb_agent::type_id::create("ahb_agent_h", this);

        if(env_config_h.apb_agent_enabled)
            apb_agent_h = apb_agent::type_id::create("apb_agent_h", this);

        if(env_config_h.scoreboard_enabled)
            sb_h = ahb_apb_scoreboard::type_id::create("sb_h", this); 

        super.build_phase(phase);
    endfunction

    function void connect_phase(uvm_phase phase);
        uvm_top.print_topology(); 

        if(env_config_h.ahb_agent_enabled && env_config_h.scoreboard_enabled)
            ahb_agent_h.mon_h.monitor_port.connect(sb_h.ahb_fifo.analysis_export); 

        if(env_config_h.apb_agent_enabled && env_config_h.scoreboard_enabled)
            apb_agent_h.mon_h.monitor_port.connect(sb_h.apb_fifo.analysis_export); 
    endfunction
endclass
