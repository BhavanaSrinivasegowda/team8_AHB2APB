class ahb_sequence extends uvm_sequence # (ahb_sequence_item);
    `uvm_object_utils(ahb_sequence)

    function new (string name = "ahb_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(N_TX)  begin
            req = ahb_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask
endclass

class ahb_random_sequence extends uvm_sequence # (ahb_sequence_item);
    `uvm_object_utils(ahb_random_sequence)

    function new (string name = "ahb_random_sequence");
        super.new(name);
    endfunction

    virtual task body();
        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { req.HTRANS == 2'b00; });
        finish_item(req);

        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { req.HTRANS == 2'b10; });
        finish_item(req);

        repeat(N_TX) begin
            req = ahb_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { req.HTRANS == 2'b11; });
            finish_item(req);

            req = ahb_sequence_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { req.HTRANS == 2'b00; });
            finish_item(req);
        end
    endtask
endclass

class ahb_single_write_sequence extends uvm_sequence # (ahb_sequence_item);
    `uvm_object_utils(ahb_single_write_sequence)

    function new (string name = "ahb_single_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
            req.HRESETn == 1'b0;
            req.HWRITE == 1'b1;
            req.HTRANS == 2'b00;
        });
        finish_item(req);

        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
            req.HRESETn == 1'b1;
            req.HWRITE == 1'b1;
            req.HSELAHB == 1'b1;
            req.HTRANS == 2'b10;
        });
        finish_item(req);

        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
            req.HRESETn == 1'b1;
            req.HSELAHB == 1'b1;
            req.HWRITE == 1'b1;
            req.HTRANS == 2'b00;
        });
        finish_item(req);
    endtask
endclass

class ahb_single_read_sequence extends uvm_sequence # (ahb_sequence_item);
    `uvm_object_utils(ahb_single_read_sequence)

    function new (string name = "ahb_single_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
            req.HRESETn == 1'b0;
            req.HWRITE == 1'b0;
            req.HTRANS == 2'b00;
        });
        finish_item(req);

        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
            req.HRESETn == 1'b1;
            req.HWRITE == 1'b0;
            req.HSELAHB == 1'b1;
            req.HTRANS == 2'b10;
        });
        finish_item(req);

        req = ahb_sequence_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {
            req.HRESETn == 1'b1;
            req.HWRITE == 1'b0;
            req.HSELAHB == 1'b1;
            req.HTRANS == 2'b00;
        });
        finish_item(req);
    endtask
endclass

