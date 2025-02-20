// -----------------------------------------------------------------------------
// Project: AHB APB Bridge Verification
// Module:  Environment
// File:    environment.sv
// -----------------------------------------------------------------------------
// Author: Lokarjun R 
// Created: Feb 16th
//
// Description: 
// The environment class is a central part of the verification process in a 
// SystemVerilog testbench. It houses all the main verification components such 
// as the generator, driver, monitor, and scoreboard, and manages the interactions 
// between them. 
// In this particular scenario, it establishes mailboxes for communication, 
// initiates all components, and manages specific test cases. These test cases 
// represent various transactions that the AHB APB bridge should be capable of 
// handling, thus facilitating comprehensive testing and verification of the 
// design under test (DUT).
//
// -----------------------------------------------------------------------------


class environment;
  mailbox #(Transaction) gen2driv;  
  mailbox #(Transaction) driv2sb;  
  mailbox #(Transaction) mail2sb; 
  mailbox #(Transaction) driv2cor;

  creating instances of the components of the TB
  generator gen;        
  driver driv;          
  ahb_apb_monitor moni;         
  ahb_apb_scoreboard sb;        
  // coverage_collector cov;
  virtual ahb_apb_bfm_if vif;

  function new(virtual ahb_apb_bfm_if vif);
    this.vif = vif;
  endfunction

  function create();
    gen2driv = new(1);
    driv2sb = new(1);
    mail2sb = new(1);
    driv2cor = new(1);
    gen = new(gen2driv);
    driv = new(gen2driv, driv2sb, driv2cor, vif);
    moni = new(mail2sb, vif);
    sb = new(driv2sb, mail2sb);
    // cov = new(driv2cor, vif);
  endfunction

/*
  task env_read_single_byte_nonseq_single_Htransfer_okay();
    fork
      gen.write_single_halfword_nonseq_single_Htransfer_okay();
      driv.drive();
      moni.watch();
      sb.data_write();

    join_none
  endtask

*/

	// Test Case 2
task env_write_single_halfword_nonseq_single_Htransfer_okay();
  fork
    gen.write_single_halfword_nonseq_single_Htransfer_okay();
    driv.drive();
    moni.watch();
    sb.data_write();

  join_none
endtask

// Test Case 3
task env_read_single_halfword_nonseq_single_Htransfer_okay();
  fork
    gen.read_single_halfword_nonseq_single_Htransfer_okay();
    driv.drive();
    moni.watch();
    sb.data_read();

  join_none
endtask

// Test Case 4
task env_write_single_byte_nonseq_single_Htransfer_error();
  fork
    gen.write_single_byte_nonseq_single_Htransfer_error();
    driv.drive();
    moni.watch();
    sb.data_write();

  join_none
endtask


// Test Case 5
task env_write_single_halfword_seq_single_Htransfer_okay();
  fork
    gen.write_single_halfword_seq_single_Htransfer_okay();
    driv.drive();
    moni.watch();
    sb.data_write();

  join_none
endtask

// Test Case 6
task env_read_single_word_seq_single_Htransfer_okay();
  fork
    gen.read_single_word_seq_single_Htransfer_okay();
    driv.drive();
    moni.watch();
    sb.data_read();

  join_none
endtask

// Test Case 7
task env_write_single_byte_seq_single_Htransfer_error();
  fork
    gen.write_single_byte_seq_single_Htransfer_error();
    driv.drive();
    moni.watch();
    sb.data_write();

  join_none
endtask

// Test Case 8
task env_read_single_byte_nonseq_single_Htransfer_reset();
  fork
    gen.read_single_byte_nonseq_single_Htransfer_reset();
    driv.drive();
    moni.watch();
    sb.data_read();

  join_none
endtask

// Test Case 9
task env_write_single_halfword_nonseq_single_Htransfer_reset();
  fork
    gen.write_single_halfword_nonseq_single_Htransfer_reset();
    driv.drive();
    moni.watch();
    sb.data_write();

  join_none
endtask

// Test Case 10
task env_read_single_word_nonseq_single_Htransfer_reset();
  fork
    gen.read_single_word_nonseq_single_Htransfer_reset();
    driv.drive();
    moni.watch();
    sb.data_read();

  join_none
endtask



// Test Case 11
task env_read_single_byte_seq_single_Htransfer_reset();
  fork
    gen.read_single_byte_seq_single_Htransfer_reset();
    driv.drive();
    moni.watch();
    sb.data_read();
  join_none
endtask

// Test Case 12
task env_write_single_halfword_seq_single_Htransfer_reset();
  fork
    gen.write_single_halfword_seq_single_Htransfer_reset();
    driv.drive();
    moni.watch();
    sb.data_write();
  join_none
endtask

// Test Case 13
task env_read_single_word_seq_single_Htransfer_reset();
  fork
    gen.read_single_word_seq_single_Htransfer_reset();
    driv.drive();
    moni.watch();
    sb.data_read();
  join_none
endtask

// Test Case 14
task env_write_single_byte_seq_single_Htransfer_error_reset();
  fork
    gen.write_single_byte_seq_single_Htransfer_error_reset();
    driv.drive();
    moni.watch();
    sb.data_write();
  join_none
endtask


// Test Case 15
task env_write_single_byte_idle_single_Htransfer_error();
  fork
    gen.write_single_byte_idle_single_Htransfer_error();
    driv.drive();
    moni.watch();
    sb.data_write();
  join_none
endtask

endclass

