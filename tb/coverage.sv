`include "/misc/scratch/vignesh/verif_project/tb/mesi_isc_tb_define.v"
`include "uvm_macros.svh"
package coverage;
import uvm_pkg::*;
//import modules_pkg::*;
import sequences::*;

class coverage_monitor extends uvm_monitor;
    `uvm_component_utils(coverage_monitor)

    //Declare Variables
    int mbus_cmd0;
    int mbus_cmd1;
    int mbus_cmd2;
    int mbus_cmd3;
    int cbus_cmd0;
    int cbus_cmd1;
    int cbus_cmd2;
    int cbus_cmd3;
    int tbus_ins0;
    int tbus_ins1;
    int tbus_ins2;
    int tbus_ins3;
    int tbus_addr0;
    int tbus_addr1;
    int tbus_addr2;
    int tbus_addr3;

    dut_config dut_config_0;
    virtual mbus mbus_vi;
    virtual cbus cbus_vi;
    virtual tb_bus tbus_vi;
    //TODO: Add covergroups for the inputs

    covergroup mesi_isc_verif;

        MBUS0_CMD: coverpoint mbus_cmd0 {
                                            bins NOP      = {'d0};
                                            bins WR       = {'d1};
                                            bins RD       = {'d2};
                                            bins WR_BROAD = {'d3};
                                            bins RD_BROAD = {'d4};
                                        }

        MBUS1_CMD: coverpoint mbus_cmd1 {
                                            bins NOP      = {'d0};
                                            bins WR       = {'d1};
                                            bins RD       = {'d2};
                                            bins WR_BROAD = {'d3};
                                            bins RD_BROAD = {'d4};
                                        }
        
        MBUS2_CMD: coverpoint mbus_cmd2 {
                                            bins NOP      = {'d0};
                                            bins WR       = {'d1};
                                            bins RD       = {'d2};
                                            bins WR_BROAD = {'d3};
                                            bins RD_BROAD = {'d4};
                                        }
                                        
        MBUS3_CMD: coverpoint mbus_cmd2 {
                                            bins NOP      = {'d0};
                                            bins WR       = {'d1};
                                            bins RD       = {'d2};
                                            bins WR_BROAD = {'d3};
                                            bins RD_BROAD = {'d4};
                                        }
        
        CBUS0_CMD: coverpoint cbus_cmd0 {
                                            bins NOP      = {'d0};
                                            bins WR_SNOOP = {'d1};
                                            bins RD_SNOOP = {'d2};
                                            bins WR_EN    = {'d3};
                                            bins RD_EN    = {'d4};
                                        }

        CBUS1_CMD: coverpoint cbus_cmd1 {
                                            bins NOP      = {'d0};
                                            bins WR_SNOOP = {'d1};
                                            bins RD_SNOOP = {'d2};
                                            bins WR_EN    = {'d3};
                                            bins RD_EN    = {'d4};
                                        }

        CBUS2_CMD: coverpoint cbus_cmd2 {
                                            bins NOP      = {'d0};
                                            bins WR_SNOOP = {'d1};
                                            bins RD_SNOOP = {'d2};
                                            bins WR_EN    = {'d3};
                                            bins RD_EN    = {'d4};
                                        }
        
        CBUS3_CMD: coverpoint cbus_cmd3 {
                                            bins NOP      = {'d0};
                                            bins WR_SNOOP = {'d1};
                                            bins RD_SNOOP = {'d2};
                                            bins WR_EN    = {'d3};
                                            bins RD_EN    = {'d4};
                                        }

         TB_INS_CPU0 : coverpoint tbus_ins0 {
                                                bins NOP = {'d0};
                                                bins WR  = {'d1};
                                                bins RD  = {'d2};
                                            }

         TB_INS_CPU1 : coverpoint tbus_ins1 {
                                                bins NOP = {'d0};
                                                bins WR  = {'d1};
                                                bins RD  = {'d2};
                                            }
         
         TB_INS_CPU2 : coverpoint tbus_ins2 {
                                                bins NOP = {'d0};
                                                bins WR  = {'d1};
                                                bins RD  = {'d2};
                                            }
         
         TB_INS_CPU3 : coverpoint tbus_ins3 {
                                                bins NOP = {'d0};
                                                bins WR  = {'d1};
                                                bins RD  = {'d2};
                                            }

          TB_INS_ADDR0 : coverpoint tbus_addr0 {
                                                   bins mem0 = {'d0}; 
                                                   bins mem1 = {'d1}; 
                                                   bins mem2 = {'d2}; 
                                                   bins mem3 = {'d3}; 
                                                   bins mem4 = {'d4}; 
                                                   bins mem5 = {'d5}; 
                                                   bins mem6 = {'d6}; 
                                                   bins mem7 = {'d7}; 
                                                   bins mem8 = {'d8}; 
                                                   bins mem9 = {'d9}; 
                                                
                                               }

          TB_INS_ADDR1 : coverpoint tbus_addr1 {
                                                   bins mem0 = {'d0}; 
                                                   bins mem1 = {'d1}; 
                                                   bins mem2 = {'d2}; 
                                                   bins mem3 = {'d3}; 
                                                   bins mem4 = {'d4}; 
                                                   bins mem5 = {'d5}; 
                                                   bins mem6 = {'d6}; 
                                                   bins mem7 = {'d7}; 
                                                   bins mem8 = {'d8}; 
                                                   bins mem9 = {'d9}; 
                                                    
                                               }

          TB_INS_ADDR2 : coverpoint tbus_addr2 {
                                                   bins mem0 = {'d0}; 
                                                   bins mem1 = {'d1}; 
                                                   bins mem2 = {'d2}; 
                                                   bins mem3 = {'d3}; 
                                                   bins mem4 = {'d4}; 
                                                   bins mem5 = {'d5}; 
                                                   bins mem6 = {'d6}; 
                                                   bins mem7 = {'d7}; 
                                                   bins mem8 = {'d8}; 
                                                   bins mem9 = {'d9};                                                 
                                               }

          TB_INS_ADDR3 : coverpoint tbus_addr3 {
                                                   bins mem0 = {'d0}; 
                                                   bins mem1 = {'d1}; 
                                                   bins mem2 = {'d2}; 
                                                   bins mem3 = {'d3}; 
                                                   bins mem4 = {'d4}; 
                                                   bins mem5 = {'d5}; 
                                                   bins mem6 = {'d6}; 
                                                   bins mem7 = {'d7}; 
                                                   bins mem8 = {'d8}; 
                                                   bins mem9 = {'d9};             
                                                
                                               }
    endgroup : mesi_isc_verif

    function new(string name, uvm_component parent);
        super.new(name,parent);
        mesi_isc_verif = new;
    endfunction: new


   function void build_phase(uvm_phase phase);
       
       assert( uvm_config_db #(dut_config)::get(this, "", "dut_config", dut_config_0));
       mbus_vi = dut_config_0.mbus_vi;
       cbus_vi = dut_config_0.cbus_vi;
       tbus_vi = dut_config_0.tbus_vi;

    endfunction : build_phase
    
    
    task run_phase(uvm_phase phase);
        forever begin//{
            
            @(posedge mbus_vi.clk) begin //{
                
                mbus_cmd0 <= mbus_vi.mbus_cmd0_i;
                mbus_cmd1 <= mbus_vi.mbus_cmd1_i;
                mbus_cmd2 <= mbus_vi.mbus_cmd2_i;
                mbus_cmd3 <= mbus_vi.mbus_cmd3_i;
                cbus_cmd0 <= cbus_vi.cbus_cmd0_o;
                cbus_cmd1 <= cbus_vi.cbus_cmd1_o;
                cbus_cmd2 <= cbus_vi.cbus_cmd2_o;
                cbus_cmd3 <= cbus_vi.cbus_cmd3_o;
                tbus_ins0 <= tbus_vi.tb_ins_array[0];
                tbus_ins1 <= tbus_vi.tb_ins_array[1];
                tbus_ins2 <= tbus_vi.tb_ins_array[2];
                tbus_ins3 <= tbus_vi.tb_ins_array[3];
                tbus_addr0 <= tbus_vi.tb_ins_addr[0];
                tbus_addr1 <= tbus_vi.tb_ins_addr[1];
                tbus_addr2 <= tbus_vi.tb_ins_addr[2];
                tbus_addr3 <= tbus_vi.tb_ins_addr[3];
                
                mesi_isc_verif.sample();
            end//}

        end//}  
        
    endtask: run_phase



endclass: coverage_monitor


endpackage: coverage
