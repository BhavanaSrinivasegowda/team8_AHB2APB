// -----------------------------------------------------------------------------
// Project: AHB APB Bridge Verification
// Module:  Test
// File:    test.sv
// -----------------------------------------------------------------------------
// Author: Harsha Vardhan Duvvuru 
// Created: 02/16/2025
//
// Description: 
// The Test class forms the backbone of any testbench in a SystemVerilog 
// verification environment. This class integrates all the test cases defined 
// in the environment and orchestrates their execution over the course of a 
// simulation run.
//
// In this particular scenario, the Test class creates an instance of the 
// environment class, providing it with the handle to the interface object. 
// The 'run' task of this class starts the environment and performs the test 
// sequences repeatedly over multiple clock cycles. 
// -----------------------------------------------------------------------------

class test;
  environment env;  // creates handle

  function new(virtual ahb_apb_bfm_if i);
    env = new(i); 
  endfunction : new
  
  task run();
    
    $display("in test");   
    env.create();  

    repeat(100)        
    begin 
      
      $display("in test repeat");

      env.env_write_single_halfword_nonseq_single_Htransfer_okay();
      #10;
      env.env_read_single_halfword_nonseq_single_Htransfer_okay();
      #10;
      env.env_write_single_byte_nonseq_single_Htransfer_error();
      #10; 
      env.env_write_single_halfword_seq_single_Htransfer_okay();
      #10;
      env.env_read_single_word_seq_single_Htransfer_okay();
      #10;
      env.env_write_single_byte_seq_single_Htransfer_error();
      #10;
      env.env_read_single_byte_nonseq_single_Htransfer_reset();
      #10;
      env.env_write_single_halfword_nonseq_single_Htransfer_reset();
      #10;
      env.env_read_single_word_nonseq_single_Htransfer_reset();
      #10;
      env.env_write_single_byte_idle_single_Htransfer_error();
      #10;
    
    end
  endtask
endclass

