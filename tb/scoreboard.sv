`include "uvm_macros.svh"
package scoreboard; 
import uvm_pkg::*;
import sequences::*;

class scoreboard_c extends uvm_scoreboard;
    `uvm_component_utils(scoreboard_c)

    uvm_analysis_export #(cpu_ins_trans) sb_in;

    uvm_tlm_analysis_fifo #(cpu_ins_trans) fifo;

    cpu_ins_trans tx_in;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        tx_in=new("tx_in");
    endfunction: new

    function void build_phase(uvm_phase phase);
        sb_in=new("sb_in",this);
        fifo=new("fifo",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        sb_in.connect(fifo.analysis_export);
    endfunction: connect_phase

    task run();
        forever begin
            fifo.get(tx_in);
        end
    endtask: run

        
endclass: scoreboard_c


endpackage: scoreboard
