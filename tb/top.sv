`timescale 1ns / 100ps
`include "uvm_macros.svh"
`include "/misc/scratch/vignesh/verif_project/rtl/mesi_isc_define.v"
`include "/misc/scratch/vignesh/verif_project/tb/mesi_isc_tb_define.v"
import uvm_pkg::*;
import modules_pkg::*;
import sequences::*;
import coverage::*;
import scoreboard::*;
import tests::*;

//`include "mesi_isc_tb_sanity_check.v"

module mesi_isc_tb
    (
     

     // Outputs
     );

  parameter
  CBUS_CMD_WIDTH           = 3,
  ADDR_WIDTH               = 32,
  DATA_WIDTH               = 32,
  BROAD_TYPE_WIDTH         = 2,  
  BROAD_ID_WIDTH           = 5,  
  BROAD_REQ_FIFO_SIZE      = 4,
  BROAD_REQ_FIFO_SIZE_LOG2 = 2,
  MBUS_CMD_WIDTH           = 3,
  BREQ_FIFO_SIZE           = 2,
  BREQ_FIFO_SIZE_LOG2      = 1;
   
/// Regs and wires
//================================
// System
     mbus mif();
     cbus cif();
     tb_bus tif();

bit                   clk;          // System clock
bit rst;
reg [3:0] mbus_ack_memory;
wire [3:0] mbus_ack_mesi_isc;
reg [1:0] cpu_priority;
reg [1:0] cpu_selected;
integer mem_access;
reg   [DATA_WIDTH-1:0]  mbus_data_rd;  // Main bus data read
wire  [DATA_WIDTH-1:0]  mbus_data_wr_array [3:0];  // Main bus data read
wire  [MBUS_CMD_WIDTH-1:0] mbus_cmd_array [3:0]; // Main bus3 command
reg    [31:0]           mem   [9:0];  // Main memory
wire  [ADDR_WIDTH-1:0]  mbus_addr_array [3:0];  // Main bus3 address

integer i,j;
//wire [3:0] tb_ins_array[3:0];
//wire [3:0] tb_ins_addr[3:0];
//wire [3:0] tb_ins_ack;// Inputs 

always #50 clk = ~clk;

initial begin//{
    tif.cpu_busy=0;
    rst=1;
    // Reset the memory
    for (j = 0; j < 10; j = j + 1)
    mem[j] = 0;
    repeat(10) @(negedge clk);
    rst = 0;
end//}

initial begin
    uvm_config_db #(virtual mbus)::set(null,"uvm_test_top","mbus_vi",mif);
    uvm_config_db #(virtual cbus)::set(null,"uvm_test_top","cbus_vi",cif);
    uvm_config_db #(virtual tb_bus)::set(null,"uvm_test_top","tbus_vi",tif);
    uvm_top.finish_on_completion=1;

    //TODO:Modify the test name here
    run_test("isc_test");
end


assign mif.clk = clk;
assign cif.clk = clk;
assign tif.clk = clk;
assign mif.rst = rst;
assign cif.rst = rst;

//assign tb_ins_array = tif.tb_ins_array;
//assign tb_ins_addr = tif.tb_ins_addr;
//assign tb_ins_ack = tif.tb_ins_ack;


// Memory and matrix
//================================
always @(posedge clk or posedge rst)
  if (rst)
  begin
                     cpu_priority    = 0;
                     cpu_selected    = 0;
  end
  else
  begin
                     mbus_ack_memory = 0;
                     mem_access      = 0;
    for (i = 0; i < 4; i = i + 1)
       if ((mbus_cmd_array[cpu_priority+i] == `MESI_ISC_MBUS_CMD_WR |
            mbus_cmd_array[cpu_priority+i] == `MESI_ISC_MBUS_CMD_RD  ) &
            !mem_access)
    begin
                     mem_access      = 1;
                     cpu_selected    = cpu_priority+i;
                     mbus_ack_memory[cpu_priority+i] = 1;
      if (mbus_cmd_array[cpu_priority+i] == `MESI_ISC_MBUS_CMD_WR)
      // WR
      begin
                  //   sanity_check_rule1_rule2(cpu_selected,
                  //                          mbus_addr_array[cpu_priority+i],
                  //                          mbus_data_wr_array[cpu_priority+i]);
                     mem[mbus_addr_array[cpu_priority+i]] =
                                           mbus_data_wr_array[cpu_priority+i];
      end
      // RD
      else
                     mbus_data_rd =        mem[mbus_addr_array[cpu_priority+i]];
    end
  end
   
assign mif.mbus_ack3_o = mbus_ack_memory[3] | mbus_ack_mesi_isc[3];
assign mif.mbus_ack2_o = mbus_ack_memory[2] | mbus_ack_mesi_isc[2];
assign mif.mbus_ack1_o = mbus_ack_memory[1] | mbus_ack_mesi_isc[1];
assign mif.mbus_ack0_o = mbus_ack_memory[0] | mbus_ack_mesi_isc[0];


// Instantiations
//================================


// mesi_isc
mesi_isc #(CBUS_CMD_WIDTH,
           ADDR_WIDTH,
           BROAD_TYPE_WIDTH,
           BROAD_ID_WIDTH,
           BROAD_REQ_FIFO_SIZE,
           BROAD_REQ_FIFO_SIZE_LOG2,
           MBUS_CMD_WIDTH,
           BREQ_FIFO_SIZE,
           BREQ_FIFO_SIZE_LOG2
          )
  mesi_isc
    (
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .mbus_cmd3_i      (mif.mbus_cmd3_i),
     .mbus_cmd2_i      (mif.mbus_cmd2_i),
     .mbus_cmd1_i      (mif.mbus_cmd1_i),
     .mbus_cmd0_i      (mif.mbus_cmd0_i),
     .mbus_addr3_i     (cif.mbus_addr3_i),
     .mbus_addr2_i     (cif.mbus_addr2_i),
     .mbus_addr1_i     (cif.mbus_addr1_i),
     .mbus_addr0_i     (cif.mbus_addr0_i),
     .cbus_ack3_i      (cif.cbus_ack3_i),
     .cbus_ack2_i      (cif.cbus_ack2_i),
     .cbus_ack1_i      (cif.cbus_ack1_i),
     .cbus_ack0_i      (cif.cbus_ack0_i),
     // Outputs
     .cbus_addr_o      (cif.cbus_addr_o),
     .cbus_cmd3_o      (cif.cbus_cmd3_o),
     .cbus_cmd2_o      (cif.cbus_cmd2_o),
     .cbus_cmd1_o      (cif.cbus_cmd1_o),
     .cbus_cmd0_o      (cif.cbus_cmd0_o),
     .mbus_ack3_o      (mbus_ack_mesi_isc[3]),
     .mbus_ack2_o      (mbus_ack_mesi_isc[2]),
     .mbus_ack1_o      (mbus_ack_mesi_isc[1]),
     .mbus_ack0_o      (mbus_ack_mesi_isc[0])
    );

// mesi_isc_tb_cpu3
mesi_isc_tb_cpu  #(
       CBUS_CMD_WIDTH,
       ADDR_WIDTH,
       DATA_WIDTH,
       BROAD_TYPE_WIDTH,
       BROAD_ID_WIDTH,
       BROAD_REQ_FIFO_SIZE,
       BROAD_REQ_FIFO_SIZE_LOG2,
       MBUS_CMD_WIDTH,
       BREQ_FIFO_SIZE,
       BREQ_FIFO_SIZE_LOG2
      )
   //         \ /
   mesi_isc_tb_cpu3
    (
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .cbus_addr_i      (cif.cbus_addr_o),
     //                        \ /
     .cbus_cmd_i       (cif.cbus_cmd3_o),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mif.mbus_ack3_o),
     //                   \ /
     .cpu_id_i         (2'd3),
     //                      \ /
     .tb_ins_i         (tif.tb_ins_array[3]),
     //                           \ /
     .tb_ins_addr_i    (tif.tb_ins_addr[3]),
     // Outputs                \ /
     .mbus_cmd_o       (mif.mbus_cmd3_i),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[3]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[3]),
     //                        \ /
     .cbus_ack_o       (cif.cbus_ack3_i),
     //                          \ /
     .tb_ins_ack_o     (tif.tb_ins_ack[3])
 );

// mesi_isc_tb_cpu2
mesi_isc_tb_cpu  #(
       CBUS_CMD_WIDTH,
       ADDR_WIDTH,
       DATA_WIDTH,
       BROAD_TYPE_WIDTH,
       BROAD_ID_WIDTH,
       BROAD_REQ_FIFO_SIZE,
       BROAD_REQ_FIFO_SIZE_LOG2,
       MBUS_CMD_WIDTH,
       BREQ_FIFO_SIZE,
       BREQ_FIFO_SIZE_LOG2
      )
   //         \ /
   mesi_isc_tb_cpu2
    (
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .cbus_addr_i      (cif.cbus_addr_o),
     //                        \ /
     .cbus_cmd_i       (cif.cbus_cmd2_o),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mif.mbus_ack2_o),
     //                   \ /
     .cpu_id_i         (2'd2),
     //                      \ /
     .tb_ins_i         (tif.tb_ins_array[2]),
     //                           \ /
     .tb_ins_addr_i    (tif.tb_ins_addr[2]),
     // Outputs                \ /
     .mbus_cmd_o       (mif.mbus_cmd2_i),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[2]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[2]),
     //                        \ /
     .cbus_ack_o       (cif.cbus_ack2_i),
     //                          \ /
     .tb_ins_ack_o     (tif.tb_ins_ack[2])
 );

// mesi_isc_tb_cpu1
mesi_isc_tb_cpu  #(
       CBUS_CMD_WIDTH,
       ADDR_WIDTH,
       DATA_WIDTH,
       BROAD_TYPE_WIDTH,
       BROAD_ID_WIDTH,
       BROAD_REQ_FIFO_SIZE,
       BROAD_REQ_FIFO_SIZE_LOG2,
       MBUS_CMD_WIDTH,
       BREQ_FIFO_SIZE,
       BREQ_FIFO_SIZE_LOG2
      )
   //         \ /
   mesi_isc_tb_cpu1
    (
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .cbus_addr_i      (cif.cbus_addr_o),
     //                        \ /
     .cbus_cmd_i       (cif.cbus_cmd1_o),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mif.mbus_ack1_o),
     //                   \ /
     .cpu_id_i         (2'd1),
     //                      \ /
     .tb_ins_i         (tif.tb_ins_array[1]),
     //                           \ /
     .tb_ins_addr_i    (tif.tb_ins_addr[1]),
     // Outputs                \ /
     .mbus_cmd_o       (mif.mbus_cmd1_i),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[1]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[1]),
     //                        \ /
     .cbus_ack_o       (cif.cbus_ack1_i),
     //                          \ /
     .tb_ins_ack_o     (tif.tb_ins_ack[1])
 );

// mesi_isc_tb_cpu0
mesi_isc_tb_cpu  #(
       CBUS_CMD_WIDTH,
       ADDR_WIDTH,
       DATA_WIDTH,
       BROAD_TYPE_WIDTH,
       BROAD_ID_WIDTH,
       BROAD_REQ_FIFO_SIZE,
       BROAD_REQ_FIFO_SIZE_LOG2,
       MBUS_CMD_WIDTH,
       BREQ_FIFO_SIZE,
       BREQ_FIFO_SIZE_LOG2
      )
   //         \ /
   mesi_isc_tb_cpu0
    (
     // Inputs
     .clk              (clk),
     .rst              (rst),
     .cbus_addr_i      (cbus_addr),
     //                        \ /
     .cbus_cmd_i       (cif.cbus_cmd0_o),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mif.mbus_ack0_o),
     //                   \ /
     .cpu_id_i         (2'd0),
     //                      \ /
     .tb_ins_i         (tif.tb_ins_array[0]),
     //                           \ /
     .tb_ins_addr_i    (tif.tb_ins_addr[0]),
     // Outputs                \ /
     .mbus_cmd_o       (mif.mbus_cmd0_i),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[0]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[0]),
     //                        \ /
     .cbus_ack_o       (cif.cbus_ack0_i),
     //                           \ /
     .tb_ins_ack_o     (tif.tb_ins_ack[0])
 );

`include "assertions.sv"

endmodule
