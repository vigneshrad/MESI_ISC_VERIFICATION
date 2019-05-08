`include "uvm_macros.svh"
package sequences;

    import uvm_pkg::*;

    class dut_config extends uvm_object;
    `uvm_object_utils(dut_config)

    virtual mbus mbus_vi;
    virtual cbus cbus_vi;
    virtual tb_bus tbus_vi;

    endclass: dut_config

    class cpu_ins_trans extends uvm_sequence_item;
	
        `uvm_object_utils(cpu_ins_trans);

        rand logic [3:0] tb_ins_addr;
        rand logic [3:0] tb_ins;
        rand logic [1:0] cpu_id;
        logic [3:0] monitor_flag;
        function new(string name = "");
            super.new(name);
        endfunction: new

        function string convert2string;
            convert2string={
                $sformatf("CPU ID %x, INSTRUCTION CODE: %x, INSTR_ADDR: %d",cpu_id,tb_ins_addr,tb_ins)
            };
        endfunction: convert2string

    //TODO: ADD CONSTRAINTS
    constraint ins_addr_c1 {
                                tb_ins_addr <= 4'h9;
                            }
    constraint ins_c2 {
                                tb_ins <= 4'h2;
                       }

    endclass: cpu_ins_trans

    typedef uvm_sequencer #(cpu_ins_trans) cpu_sequencer_in;


    class cpu_inst_seq extends uvm_sequence #(cpu_ins_trans);
        `uvm_object_utils(cpu_inst_seq)

        integer id;
        function new(string name = "");
            super.new(name);
        endfunction: new

        
       task body;
            cpu_ins_trans tx;

            
            tx=cpu_ins_trans::type_id::create("tx");
            
            start_item(tx);

            assert(tx.randomize() with {cpu_id==id;});
            case(tx.tb_ins)
                4'h0:     `uvm_info(get_type_name(),$psprintf("ISSUING NOP INSTRUCTION TO CPU%d",tx.cpu_id),UVM_LOW)
                4'h1:     `uvm_info(get_type_name(),$psprintf("ISSUING WRITE INSTRUCTION TO CPU%d",tx.cpu_id),UVM_LOW)
                4'h2:     `uvm_info(get_type_name(),$psprintf("ISSUING READ INSTRUCTION TO CPU%d",tx.cpu_id),UVM_LOW)
                default:  `uvm_fatal(get_type_name(),"INCORRECT INSTRUCTION TO CPU")
            endcase
            finish_item(tx);

        endtask: body

    endclass: cpu_inst_seq

    class base_vseq extends uvm_sequence #(cpu_ins_trans);
        `uvm_object_utils(base_vseq)
            
            cpu_sequencer_in cpu0_sequencer_in_h;
            cpu_sequencer_in cpu1_sequencer_in_h;
            cpu_sequencer_in cpu2_sequencer_in_h;
            cpu_sequencer_in cpu3_sequencer_in_h;
        
        function new(string name = "");
            super.new(name);
        endfunction: new

    endclass: base_vseq

    class main_cpu_vseq extends base_vseq;
        `uvm_object_utils(main_cpu_vseq)
       
       function new(string name = "");
            super.new(name);
        endfunction: new
       
       task body;
            cpu_inst_seq cpu0_seq;
            cpu_inst_seq cpu1_seq;
            cpu_inst_seq cpu2_seq;
            cpu_inst_seq cpu3_seq;

            cpu0_seq = cpu_inst_seq::type_id::create("cpu0_seq");
            cpu1_seq = cpu_inst_seq::type_id::create("cpu1_seq");
            cpu2_seq = cpu_inst_seq::type_id::create("cpu2_seq");
            cpu3_seq = cpu_inst_seq::type_id::create("cpu3_seq");

            cpu0_seq.id = 0;
            cpu1_seq.id = 1;
            cpu2_seq.id = 2;
            cpu3_seq.id = 3;

            fork
              repeat(10) begin//{
                assert(cpu0_seq.randomize());
                cpu0_seq.start(cpu0_sequencer_in_h);
              end//}
              repeat(10) begin//{
                assert(cpu1_seq.randomize());
                cpu1_seq.start(cpu1_sequencer_in_h);
              end//}
              repeat(10) begin//{
                assert(cpu2_seq.randomize());
                cpu2_seq.start(cpu2_sequencer_in_h);
              end//}
              repeat(10) begin//{
                assert(cpu3_seq.randomize());
                cpu3_seq.start(cpu3_sequencer_in_h);
              end//}
            join

        endtask
    endclass: main_cpu_vseq

endpackage: sequences
