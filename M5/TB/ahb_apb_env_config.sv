
class ahb_apb_env_config extends uvm_object;
    `uvm_object_utils(ahb_apb_env_config)

    bit ahb_agent_enabled;      
    bit apb_agent_enabled;       
    bit scoreboard_enabled;     

    uvm_active_passive_enum ahb_agent_is_active;
    uvm_active_passive_enum apb_agent_is_active;

    virtual ahb_intf ahb_vif;
    virtual apb_intf apb_vif;

    function new(string name = "ahb_apb_env_config");
        super.new(name);
    endfunction
endclass
