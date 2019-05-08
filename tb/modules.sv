`include "uvm_macros.svh"

package modules_pkg;

import uvm_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;

typedef uvm_sequencer #(cpu_ins_trans) cpu_sequencer_in;



class driver_in extends uvm_driver#(cpu_ins_trans);
    `uvm_component_utils(driver_in)

    dut_config dut_config_0;
    virtual mbus mbus_vi;  
    virtual cbus cbus_vi;  
    virtual tb_bus tbus_vi;

    integer id;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
       
       assert( uvm_config_db #(dut_config)::get(this, "", "dut_config", dut_config_0));
       mbus_vi = dut_config_0.mbus_vi;
       cbus_vi = dut_config_0.cbus_vi;
       tbus_vi = dut_config_0.tbus_vi;

    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        cpu_ins_trans instr;
        if(mbus_vi.rst==1) begin//{
         `uvm_info(get_type_name(),"WAITING FOR INST RST DE_ASSERTION",UVM_LOW)
            @(negedge mbus_vi.rst);
            `uvm_info(get_type_name(),"RST DONE, WAIT FOR CLK",UVM_LOW)
        end//}
        @(posedge mbus_vi.clk);
         `uvm_info(get_type_name(),"CLK DONE WAIT FOR TRANS ITEM",UVM_LOW)
        seq_item_port.get_next_item(instr);
         `uvm_info(get_type_name(),"GOT ITEM",UVM_LOW)


        if(instr.cpu_id==id) begin//{
            `uvm_info(get_type_name(),"WAIT FOR CPU BUSY BEING 0",UVM_LOW)
            if(tbus_vi.cpu_busy[id]==1'b1)
                @(negedge tbus_vi.cpu_busy[id]);
            tbus_vi.cpu_busy[id]=1;
            tbus_vi.tb_ins_array[id] <= instr.tb_ins;
            tbus_vi.tb_ins_addr[id] <= instr.tb_ins_addr;
            `uvm_info(get_type_name(),"WAITING FOR INST ACK",UVM_LOW)
            if(instr.tb_ins!=0) begin//{
                @(posedge tbus_vi.tb_ins_ack[id]);
            end//}
            tbus_vi.cpu_busy[id]=0;
        end//}
        else
        `uvm_fatal(get_type_name(),$psprintf("INCORRECT DRIVER INSTRUCTION CPU ID RECEIVED:%d",instr.cpu_id))
        seq_item_port.item_done();
    end
    endtask: run_phase

endclass: driver_in

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    uvm_analysis_port #(cpu_ins_trans) aport;

    dut_config dut_config_0;

    virtual tb_bus tbus_vi;
    
    integer i;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        dut_config_0=dut_config::type_id::create("config");
        aport=new("aport",this);
        assert( uvm_config_db #(dut_config)::get(this, "", "dut_config", dut_config_0) );
        tbus_vi=dut_config_0.tbus_vi;

    endfunction: build_phase

    task run_phase(uvm_phase phase);
      forever
      begin//{
        cpu_ins_trans trans;
        @(posedge tbus_vi.clk);
        trans = cpu_ins_trans::type_id::create("trans");
        for(i=0;i<4;i=i+1)begin//{
            if(tbus_vi.tb_ins_ack[i]) begin//{
                trans.tb_ins[i]=tbus_vi.tb_ins_array[i];
                trans.monitor_flag = 1;
            end//}
            else
                trans.monitor_flag = 0;
        end//}
        aport.write(trans);
      end//}
    endtask: run_phase

endclass: monitor

class agent_in extends uvm_agent;
    `uvm_component_utils(agent_in)

    uvm_analysis_port #(cpu_ins_trans) aport;

    cpu_sequencer_in cpu0_sequencer_in_h;
    cpu_sequencer_in cpu1_sequencer_in_h;
    cpu_sequencer_in cpu2_sequencer_in_h;
    cpu_sequencer_in cpu3_sequencer_in_h;
    driver_in cpu0_driver;
    driver_in cpu1_driver;
    driver_in cpu2_driver;
    driver_in cpu3_driver;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        aport=new("aport",this);
        cpu0_sequencer_in_h=cpu_sequencer_in::type_id::create("cpu0_sequencer_in_h",this);
        cpu0_driver=driver_in::type_id::create("cpu0_driver",this);
        cpu1_sequencer_in_h=cpu_sequencer_in::type_id::create("cpu1_sequencer_in_h",this);
        cpu1_driver=driver_in::type_id::create("cpu1_driver",this);
        cpu2_sequencer_in_h=cpu_sequencer_in::type_id::create("cpu2_sequencer_in_h",this);
        cpu2_driver=driver_in::type_id::create("cpu2_driver",this);
        cpu3_sequencer_in_h=cpu_sequencer_in::type_id::create("cpu3_sequencer_in_h",this);
        cpu3_driver=driver_in::type_id::create("cpu3_driver",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        
        cpu0_driver.seq_item_port.connect(cpu0_sequencer_in_h.seq_item_export);
        cpu1_driver.seq_item_port.connect(cpu1_sequencer_in_h.seq_item_export);
        cpu2_driver.seq_item_port.connect(cpu2_sequencer_in_h.seq_item_export);
        cpu3_driver.seq_item_port.connect(cpu3_sequencer_in_h.seq_item_export);
        cpu0_driver.id=0;
        cpu1_driver.id=1;
        cpu2_driver.id=2;
        cpu3_driver.id=3;

    endfunction: connect_phase

endclass: agent_in

class agent_out extends uvm_agent;
    `uvm_component_utils(agent_out)

    uvm_analysis_port #(cpu_ins_trans) aport;

    monitor cpu_monitor;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        aport=new("aport",this);
        cpu_monitor=monitor::type_id::create("cpu_monitor",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        cpu_monitor.aport.connect(aport);
    endfunction: connect_phase

endclass: agent_out

class env extends uvm_env;
    `uvm_component_utils(env)

    agent_in cpu_agent_in_h;
    agent_out cpu_agent_out_h;
    coverage_monitor cpu_subscriber_in_h;
    scoreboard_c cpu_scoreboard_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        cpu_agent_in_h = agent_in::type_id::create("cpu_agent_in_h",this);
        cpu_agent_out_h = agent_out::type_id::create("cpu_agent_out_h",this);
        cpu_subscriber_in_h = coverage_monitor::type_id::create("cpu_subscriber_in_h",this);
        cpu_scoreboard_h = scoreboard_c::type_id::create("cpu_scoreboard_h",this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        //TODO
        //cpu_agent_in_h.aport.connect(cpu_subscriber_in_h.analysis_export);
        //cpu_agent_out_h.aport.connect(cpu_scoreboard_h.sb_in);
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        //TODO: Use this command to set the verbosity of the testbench. By
        //default, it is UVM_MEDIUM
        uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
    endfunction: start_of_simulation_phase

endclass: env

class test extends uvm_test;
    `uvm_component_utils(test)

    dut_config dut_config_0;
    env env_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        dut_config_0 = new();
        if(!uvm_config_db #(virtual mbus)::get( this, "", "mbus_vi", dut_config_0.mbus_vi))
          `uvm_fatal("NOVIF", "No virtual interface set for mbus")
  
        if(!uvm_config_db #(virtual cbus)::get( this, "", "cbus_vi", dut_config_0.cbus_vi))
          `uvm_fatal("NOVIF", "No virtual interface set for cbus")

        if(!uvm_config_db #(virtual tb_bus)::get( this, "", "tbus_vi", dut_config_0.tbus_vi))
          `uvm_fatal("NOVIF", "No virtual interface set for tb_bus")

            
        uvm_config_db #(dut_config)::set(this, "*", "dut_config", dut_config_0);
        env_h = env::type_id::create("env_h", this);
    endfunction: build_phase

    function void init_vseq(base_vseq vseq);
        vseq.cpu0_sequencer_in_h = env_h.cpu_agent_in_h.cpu0_sequencer_in_h;
        vseq.cpu1_sequencer_in_h = env_h.cpu_agent_in_h.cpu1_sequencer_in_h;
        vseq.cpu2_sequencer_in_h = env_h.cpu_agent_in_h.cpu2_sequencer_in_h;
        vseq.cpu3_sequencer_in_h = env_h.cpu_agent_in_h.cpu3_sequencer_in_h;
    endfunction

endclass:test

endpackage: modules_pkg

