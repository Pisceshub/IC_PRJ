// ==================================================
// Copyright (c)
// All rights reserved
// Filename        : hello.sv
// Author          : x00897025
// Email           : 1834093202@qq.com
// Created on      : 2024-11-23 04:53:45
// Last Modified   : 2024-11-23 05:58:47
// Description     : 
// 
// 
// ==================================================

//`include "/home/synopsys/vcs-mx/O-2018.09-1/etc/uvm-1.2/uvm_macros.svh"
//import uvm_pkg::*;


class hello_test extends uvm_test;
    `uvm_component_utils(hello_test)

    function new(string name = "hello_test", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("hello_test", "new is called", UVM_LOW);
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("hello_test", "main_phase is called", UVM_LOW);
        $display("a");
        #10000;
        `uvm_info("hello_test", "main_phase is finish", UVM_LOW);

        phase.drop_objection(this);
    endtask


endclass

`timescale 1ns/1ps

module tb;

    initial begin;
        run_test("hello_test");
    end

endmodule
