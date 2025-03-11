int logfile, errorlogfile;
class ahb_apb_report_server extends uvm_report_server;
`uvm_object_utils(ahb_apb_report_server)

function new (string name="ahb_apb_report_server");
	super.new();
	$display( "Constructing report serevr %0s",name);
endfunction


virtual function string compose_message( uvm_severity severity,string name,string id,string message,string filename,int line );
	$display("%0s",super.compose_message(severity,name,id,message,filename,line));

    return $sformatf( "UVM_INFO | %16s | %2d | %0t | %-21s | %-7s | %s",
                         filename, line, $time, name, id, message );
endfunction

endclass


class ahb_apb_base_test extends uvm_test;
    `uvm_component_utils (ahb_apb_base_test)

    ahb_apb_env_config env_config_h;
    ahb_apb_env env_h;

    function new(string name = "ahb_apb_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env_config_h = ahb_apb_env_config::type_id::create("env_config_h");
        
        uvm_config_db #(ahb_apb_env_config)::set(this, "*", "ahb_apb_env_config", env_config_h);

        if(!uvm_config_db #(virtual ahb_intf)::get(this, "", "ahb_vif", env_config_h.ahb_vif))
            `uvm_fatal (get_type_name, "can't get ahb_intf from config_db");
        
        if(!uvm_config_db #(virtual apb_intf)::get(this, "", "apb_vif", env_config_h.apb_vif))
            `uvm_fatal (get_type_name, "can't get apb_intf from config_db");

        env_config_h.ahb_agent_enabled  = 1;
        env_config_h.apb_agent_enabled  = 1;
        env_config_h.scoreboard_enabled = 1;

        env_config_h.ahb_agent_is_active = UVM_ACTIVE;
        env_config_h.apb_agent_is_active = UVM_ACTIVE;

        env_h = ahb_apb_env::type_id::create("env_h", this);
    endfunction

        function void start_of_simulation_phase(uvm_phase phase);
        ahb_apb_report_server server = new;
        super.start_of_simulation_phase(phase);
        `uvm_info("TEST CLASS","start of simulation phase - test",UVM_NONE);
        logfile = $fopen("UVM_log.txt","w");
        set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        set_report_severity_file_hier(UVM_INFO, logfile);
        
        errorlogfile = $fopen("error_log_file.txt","w");
        set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
        set_report_severity_file_hier(UVM_ERROR, errorlogfile);
        uvm_report_server::set_server( server );
    endfunction
endclass

class ahb_apb_random_test extends ahb_apb_base_test;
    `uvm_component_utils(ahb_apb_random_test)

    ahb_random_sequence ahb_rand_seq_h;
    apb_random_sequence apb_rand_seq_h;

    function new(string name = "ahb_apb_random_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ahb_rand_seq_h = ahb_random_sequence::type_id::create("ahb_rand_seq_h");
        apb_rand_seq_h = apb_random_sequence::type_id::create("apb_rand_seq_h");
    endfunction

    task run_phase (uvm_phase phase);
        phase.raise_objection(this);
        fork
            ahb_rand_seq_h.start(env_h.ahb_agent_h.sequencer_h);
            apb_rand_seq_h.start(env_h.apb_agent_h.sequencer_h);
        join
        phase.drop_objection(this);
        phase.phase_done.set_drain_time(this, 50);
    endtask
endclass
