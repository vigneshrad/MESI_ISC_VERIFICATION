package tests;
`include "uvm_macros.svh"
import modules_pkg::*;
import uvm_pkg::*;
import sequences::*;
import scoreboard::*;

class isc_test extends test;
    `uvm_component_utils(isc_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new
    
    task run_phase(uvm_phase phase);
        main_cpu_vseq vseq;
        vseq = main_cpu_vseq::type_id::create("vseq");
        assert(vseq.randomize());
	    phase.raise_objection(this);
	    #50;
        init_vseq(vseq);
        vseq.start(null);
        phase.drop_objection(this);
    endtask: run_phase     
endclass: isc_test

endpackage: tests
