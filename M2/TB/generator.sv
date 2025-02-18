// -----------------------------------------------------------------------------
// Project: AHB APB Bridge Verification
// Module:  Generator
// File:    generator.sv
// -----------------------------------------------------------------------------
// Author: Lokarjun R
// Created: Feb 12th
//
// Description: 
// The SystemVerilog generator class generates transactions of different 
// types and sends them to the driver for execution. In this module, there 
// are several test cases defined as tasks, each representing a unique 
// transaction.
//
// The class generator has a transaction handle 'tx' and a mailbox 'gen2driv'
// that is used to send transactions to the driver. It also has a virtual
// interface 'vif' to communicate with the DUT.
//
// The 'read_single_byte_nonseq_single_Htransfer_okay' task, for instance, 
// creates a read transaction, with each field of the transaction being 
// assigned a value according to the requirements of the test case. Once the 
// transaction is ready, it is sent to the driver using the 'gen2driv.put(tx);' 
// command.
//
// Similar operations are performed in other test case tasks. Each task 
// defines a different type of transaction, with various values assigned to 
// the fields of the transaction.
//
// The generator class also samples each transaction for coverage using the 
// 'tx.cov_cg.sample();' command. This helps to ensure that all types of 
// transactions are generated and executed, thus ensuring complete functional 
// coverage.
// -----------------------------------------------------------------------------

class generator;

    Transaction tx;   // Handle for Htransactions          
    mailbox #(Transaction) gen2driv;  // Generator to Driver mailbox

    logic [31:0] temp_Haddr; // temporary variable  
    logic [11:0] Haddr_array [6] =  {8'h11, 8'h22, 12'h384, 12'hFD2, 12'h64, 12'hDAC}; // Haddress array
    logic [11:0] Haddr_Hburst[2] = {12'hab , 12'hde}; // Hburst
    int i =0;

    function new(mailbox #(Transaction)gen2driv);
        this.gen2driv   = gen2driv;
    endfunction
    
    // Test Case 1
    task write_single_halfword_nonseq_single_Htransfer_okay();
        $display($time, "   write_single_halfword_nonseq_single_Htransfer_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1; // Write operation
    tx.update_trans_type();
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b10;
    tx.Penable = 1;
        tx.Hwdata = $urandom(); // Generate random data for write
    tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask


    // Test Case 2
    task read_single_halfword_nonseq_single_Htransfer_okay();
        $display($time, "   read_single_word_nonseq_single_Htransfer_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b10;
    tx.Penable = 1;
    tx.Pwrite = 0;
    tx.cov_cg.sample(); // After transaction is fully defined
      tx.update_trans_type();
        gen2driv.put(tx);
    endtask

    // Test Case 3
    task write_single_byte_nonseq_single_Htransfer_error();
        $display($time, "   write_single_byte_nonseq_single_Htransfer_error task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b10;
        tx.Hwdata = $urandom();
        tx.hresp = 1;
	tx.Penable = 1;
	tx.cov_cg.sample(); // After transaction is fully defined
  	tx.update_trans_type();
        gen2driv.put(tx);
    endtask

    // Test Case 4
    task read_incr_halfword_nonseq_incr_Hburst_okay();
        $display($time, "   read_incr_halfword_nonseq_incr_Hburst_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b10;
	tx.Penable = 1;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 5
    task write_incr_word_nonseq_incr_Hburst_okay();
        $display($time, "   write_incr_word_nonseq_incr_Hburst_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b10;
	tx.Penable = 1;
        tx.Hwdata = $urandom();
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    

    // Test Case 6
    task read_single_byte_seq_single_Htransfer_okay();
        $display($time, "   read_single_byte_seq_single_Htransfer_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 7
    task write_single_halfword_seq_single_Htransfer_okay();
        $display($time, "   write_single_halfword_seq_single_Htransfer_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
        tx.Hwdata = $urandom();
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 8
    task read_single_word_seq_single_Htransfer_okay();
        $display($time, "   read_single_word_seq_single_Htransfer_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 9
    task write_single_byte_seq_single_Htransfer_error();
        $display($time, "   write_single_byte_seq_single_Htransfer_error task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
        tx.Hwdata = $urandom();
        tx.hresp = 1;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 10
    task read_incr_halfword_seq_incr_Hburst_okay();
        $display($time, "   read_incr_halfword_seq_incr_Hburst_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b11;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 11
    task write_incr_word_seq_incr_Hburst_okay();
        $display($time, "   write_incr_word_seq_incr_Hburst_okay task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b11;
        tx.Hwdata = $urandom();
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask


    // Test Case 12
    task read_single_byte_nonseq_single_Htransfer_reset();
        $display($time, "   read_single_byte_nonseq_single_Htransfer_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b10;
        tx.hreset = 1;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

    // Test Case 13
    task write_single_halfword_nonseq_single_Htransfer_reset();
        $display($time, "   write_single_halfword_nonseq_single_Htransfer_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b10;
        tx.Hwdata = $urandom();
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 14
    task read_single_word_nonseq_single_Htransfer_reset();
        $display($time, "   read_single_word_nonseq_single_Htransfer_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b10;
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 15
    task write_incr_byte_nonseq_incr_Hburst_reset();
        $display($time, "   write_incr_byte_nonseq_incr_Hburst_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b10;
        tx.Hwdata = $urandom();
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 16
    task read_incr_halfword_nonseq_incr_Hburst_reset();
        $display($time, "   read_incr_halfword_nonseq_incr_Hburst_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b10;
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 17
    task write_incr_word_nonseq_incr_Hburst_reset();
        $display($time, "   write_incr_word_nonseq_incr_Hburst_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b10;
        tx.Hwdata = $urandom();
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask



    // Test Case 18
    task read_single_byte_seq_single_Htransfer_reset();
        $display($time, "   read_single_byte_seq_single_Htransfer_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 19
    task write_single_halfword_seq_single_Htransfer_reset();
        $display($time, "   write_single_halfword_seq_single_Htransfer_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
        tx.Hwdata = $urandom();
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 20
    task read_single_word_seq_single_Htransfer_reset();
        $display($time, "   read_single_word_seq_single_Htransfer_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b11;
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 21
    task write_single_byte_seq_single_Htransfer_error_reset();
        $display($time, "   write_single_byte_seq_single_Htransfer_error_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;

        tx.Htrans = 2'b11;
        tx.Hwdata = $urandom();
        tx.hresp = 1;
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 22
    task read_incr_halfword_seq_incr_Hburst_reset();
        $display($time, "   read_incr_halfword_seq_incr_Hburst_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 0;
        tx.Hsize = 3'b001;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b11;
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask

    // Test Case 23
    task write_incr_word_seq_incr_Hburst_reset();
        $display($time, "   write_incr_word_seq_incr_Hburst_reset task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b010;
        tx.Hburst = 3'b001;
        tx.Htrans = 2'b11;
        tx.Hwdata = $urandom();
        tx.hreset = 1;
        gen2driv.put(tx);
    endtask


    // Test Case 24
    task write_single_byte_idle_single_Htransfer_error();
        $display($time, "   write_single_byte_idle_single_Htransfer_error task in generator");
        tx = new();
        tx.Haddr = $urandom;
        tx.Hwrite = 1;
        tx.Hsize = 3'b000;
        tx.Hburst = 3'b000;
        tx.Htrans = 2'b00;
        tx.Hwdata = $urandom();
        tx.hresp = 1;
	tx.cov_cg.sample(); // After transaction is fully defined
        gen2driv.put(tx);
    endtask

endclass
