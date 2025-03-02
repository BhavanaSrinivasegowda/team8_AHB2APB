class apb_sequence extends uvm_sequence # (apb_sequence_item);
    `uvm_object_utils(apb_sequence)

    function new (string name = "apb_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(N_TX)  begin
            req = apb_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask
endclass

class apb_random_sequence extends uvm_sequence # (apb_sequence_item);
    `uvm_object_utils(apb_random_sequence)

    function new (string name = "apb_random_sequence");
        super.new(name);
    endfunction

    virtual task body();
        begin
            repeat(N_TX - 8) begin
                req = apb_sequence_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {req.PSLVERR == 8'b0;});
                finish_item(req);
            end
            
            repeat(10) begin
                req = apb_sequence_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {req.PSLVERR == 8'b1;});
                finish_item(req);
            end

            req = apb_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with {req.PSLVERR == 8'b0;});
            finish_item(req);
        end
    endtask
endclass

class apb_single_write_sequence extends uvm_sequence # (apb_sequence_item);
    `uvm_object_utils(apb_single_write_sequence)

    function new (string name = "apb_single_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        begin
            repeat(3) begin
                req = apb_sequence_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {req.PSLVERR == 8'b0;});
                finish_item(req);
            end
        end
    endtask
endclass

class apb_single_read_sequence extends uvm_sequence # (apb_sequence_item);
    `uvm_object_utils(apb_single_read_sequence)

    function new (string name = "apb_single_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        begin
            repeat(3) begin
                req = apb_sequence_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {req.PSLVERR == 8'b0;});
                finish_item(req);
            end
        end
    endtask
endclass
