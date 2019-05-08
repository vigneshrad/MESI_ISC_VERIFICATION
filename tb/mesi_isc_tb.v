//////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2009 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
////                                                              ////
////  MESI_ISC Project                                            ////
////                                                              ////
////  Author(s):                                                  ////
////      - Yair Amitay       yair.amitay@yahoo.com               ////
////                          www.linkedin.com/in/yairamitay      ////
////                                                              ////
////  Description                                                 ////
////  mesi_isc_tb                                                 ////
////  -------------------                                         ////
////  Project test bench                                          ////
////  - Instantiation of the top level module mesi_isc            ////
////  - Generates the tests stimulus                              ////
////  - Simulate the CPU and caches                               ////
////  - Generates clock, reset and watchdog                       ////
////  - Generate statistic                                        ////
////  - Generate dump file                                        ////
////  - Check for behavior correctness                            ////
////  - Check for coherency correctness                           ////
////                                                              ////
////  For more details see the project spec document.             ////
////  To Do:                                                      ////
////   -                                                          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "mesi_isc_define.v"
`include "mesi_isc_tb_define.v"

module mesi_isc_tb
    (
     // Inputs
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
reg                   clk;          // System clock
reg                   rst;          // Active high system reset

// Main buses
wire  [MBUS_CMD_WIDTH-1:0] mbus_cmd_array [3:0]; // Main bus3 command
wire  [MBUS_CMD_WIDTH-1:0] mbus_cmd3; // Main bus2 command
wire  [MBUS_CMD_WIDTH-1:0] mbus_cmd2; // Main bus2 command
wire  [MBUS_CMD_WIDTH-1:0] mbus_cmd1; // Main bus1 command
wire  [MBUS_CMD_WIDTH-1:0] mbus_cmd0; // Main bus0 command
// Coherence buses
wire  [ADDR_WIDTH-1:0]  mbus_addr_array [3:0];  // Main bus3 address
wire  [ADDR_WIDTH-1:0]  mbus_addr3;  // Main bus3 address
wire  [ADDR_WIDTH-1:0]  mbus_addr2;  // Main bus2 address
wire  [ADDR_WIDTH-1:0]  mbus_addr1;  // Main bus1 address
wire  [ADDR_WIDTH-1:0]  mbus_addr0;  // Main bus0 address
reg   [DATA_WIDTH-1:0]  mbus_data_rd;  // Main bus data read
wire  [DATA_WIDTH-1:0]  mbus_data_wr_array [3:0];  // Main bus data read
wire  [DATA_WIDTH-1:0]  mbus_data_wr3;  // Main bus data read
wire  [DATA_WIDTH-1:0]  mbus_data_wr2;  // Main bus data read
wire  [DATA_WIDTH-1:0]  mbus_data_wr1;  // Main bus data read
wire  [DATA_WIDTH-1:0]  mbus_data_wr0;  // Main bus data read

wire  [7:0]             mbus_data_rd_word_array [3:0]; // Bus data read in words
                                        // word

wire                    cbus_ack3;  // Coherence bus3 acknowledge
wire                    cbus_ack2;  // Coherence bus2 acknowledge
wire                    cbus_ack1;  // Coherence bus1 acknowledge
wire                    cbus_ack0;  // Coherence bus0 acknowledge
   

wire   [ADDR_WIDTH-1:0] cbus_addr;  // Coherence bus address. All busses have
                                      // the same address
wire   [CBUS_CMD_WIDTH-1:0] cbus_cmd3; // Coherence bus3 command
wire   [CBUS_CMD_WIDTH-1:0] cbus_cmd2; // Coherence bus2 command
wire   [CBUS_CMD_WIDTH-1:0] cbus_cmd1; // Coherence bus1 command
wire   [CBUS_CMD_WIDTH-1:0] cbus_cmd0; // Coherence bus0 command

wire   [3:0]            mbus_ack;  // Main bus3 acknowledge
reg    [3:0]            mbus_ack_memory;
wire   [3:0]            mbus_ack_mesi_isc;
reg    [3:0]            tb_ins_array [3:0];
wire   [3:0]            tb_ins3;
wire   [3:0]            tb_ins2;
wire   [3:0]            tb_ins1;
wire   [3:0]            tb_ins0;
reg    [3:0]            tb_ins_addr_array [3:0];
wire   [3:0]            tb_ins_addr3;
wire   [3:0]            tb_ins_addr2;
wire   [3:0]            tb_ins_addr1;
wire   [3:0]            tb_ins_addr0;
reg    [7:0]            tb_ins_nop_period [3:0];
wire   [7:0]            tb_ins_nop_period3;
wire   [7:0]            tb_ins_nop_period2;
wire   [7:0]            tb_ins_nop_period1;
wire   [7:0]            tb_ins_nop_period0;
wire   [3:0]            tb_ins_ack;
reg    [31:0]           mem   [9:0];  // Main memory
wire   [31:0]           mem0;
wire   [31:0]           mem1;
wire   [31:0]           mem2;
wire   [31:0]           mem3;
wire   [31:0]           mem4;
wire   [31:0]           mem5;
wire   [31:0]           mem6;
wire   [31:0]           mem7;
wire   [31:0]           mem8;
wire   [31:0]           mem9;
reg    [1:0]            cpu_priority;
reg    [3:0]            cpu_selected;   
reg                     mem_access;
integer                 stimulus_rand_numb [9:0];
integer                 seed;
reg    [1:0]            stimulus_rand_cpu_select;
reg    [1:0]            stimulus_op;
reg    [7:0]            stimulus_addr;
reg    [7:0]            stimulus_nop_period;
integer                 cur_stimulus_cpu;
// For debug in GTKwave
wire   [ADDR_WIDTH+BROAD_TYPE_WIDTH+2+BROAD_ID_WIDTH:0] broad_fifo_entry0;
wire   [ADDR_WIDTH+BROAD_TYPE_WIDTH+2+BROAD_ID_WIDTH:0] broad_fifo_entry1;
wire   [ADDR_WIDTH+BROAD_TYPE_WIDTH+2+BROAD_ID_WIDTH:0] broad_fifo_entry2;
wire   [ADDR_WIDTH+BROAD_TYPE_WIDTH+2+BROAD_ID_WIDTH:0] broad_fifo_entry3;

wire   [5:0]            cache_state_valid_array [3:0];

integer                 i, j, k, l, m, n, p;

reg [31:0]              stat_cpu_access_nop [3:0];
reg [31:0]              stat_cpu_access_rd  [3:0];
reg [31:0]              stat_cpu_access_wr  [3:0];
   

`include "mesi_isc_tb_sanity_check.v"
   
// Stimulus
//================================
// The stimulus drives instruction to the CPU. There are three possible 
// instructions:
// 1. NOP - Do nothing for a random cycles.   
// 2. RD - Read a memory address line with a random address. If the line address
//    is valid on the cache read it from there, if not bring the line according
//    to the the MESI protocol.
// 3. WR - Write a memory address line with a random address. If the line address
//    is valid on the cache write to it according to the MESI protocol. If it is
//    not valid, bring it from the memory according to the the MESI protocol.
assign mbus_ack[3:0] = mbus_ack_memory[3:0] | mbus_ack_mesi_isc[3:0];

// Assigns
//================================
// GTKwave can't see arrays. points to array so GTKwave can see these signals
assign broad_fifo_entry0 = mesi_isc.mesi_isc_broad.broad_fifo.entry[0];
assign broad_fifo_entry1 = mesi_isc.mesi_isc_broad.broad_fifo.entry[1];
assign brroad_fifo_entry2 = mesi_isc.mesi_isc_broad.broad_fifo.entry[2];
assign brroad_fifo_entry3 = mesi_isc.mesi_isc_broad.broad_fifo.entry[3];
assign mbus_cmd3          = mbus_cmd_array[3];
assign mbus_cmd2          = mbus_cmd_array[2];
assign mbus_cmd1          = mbus_cmd_array[1];
assign mbus_cmd0          = mbus_cmd_array[0];
assign mbus_addr3         = mbus_addr_array[3];
assign mbus_addr2         = mbus_addr_array[2];
assign mbus_addr1         = mbus_addr_array[1];
assign mbus_addr0         = mbus_addr_array[0];
assign mbus_data_wr3      = mbus_data_wr_array[3];
assign mbus_data_wr2      = mbus_data_wr_array[2];
assign mbus_data_wr1      = mbus_data_wr_array[1];
assign mbus_data_wr0      = mbus_data_wr_array[0];
assign tb_ins3            = tb_ins_array[3];
assign tb_ins2            = tb_ins_array[2];
assign tb_ins1            = tb_ins_array[1];
assign tb_ins0            = tb_ins_array[0];
assign tb_ins_addr3       = tb_ins_addr_array[3];
assign tb_ins_addr2       = tb_ins_addr_array[2];
assign tb_ins_addr1       = tb_ins_addr_array[1];
assign tb_ins_addr0       = tb_ins_addr_array[0];
assign tb_ins_nop_period3 = tb_ins_nop_period[3];
assign tb_ins_nop_period2 = tb_ins_nop_period[2];
assign tb_ins_nop_period1 = tb_ins_nop_period[1];
assign tb_ins_nop_period0 = tb_ins_nop_period[0];
assign mem0 = mem[0];
assign mem1 = mem[1];
assign mem2 = mem[2];
assign mem3 = mem[3];
assign mem4 = mem[4];
assign mem5 = mem[5];
assign mem6 = mem[6];
assign mem7 = mem[7];
assign mem8 = mem[8];
assign mem9 = mem[9];
assign mbus_data_rd_word_array[3] = mbus_data_rd[31:24]; 
assign mbus_data_rd_word_array[2] = mbus_data_rd[23:16]; 
assign mbus_data_rd_word_array[1] = mbus_data_rd[15:8]; 
assign mbus_data_rd_word_array[0] = mbus_data_rd[7:0]; 
   
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
     .mbus_cmd3_i      (mbus_cmd_array[3]),
     .mbus_cmd2_i      (mbus_cmd_array[2]),
     .mbus_cmd1_i      (mbus_cmd_array[1]),
     .mbus_cmd0_i      (mbus_cmd_array[0]),
     .mbus_addr3_i     (mbus_addr_array[3]),
     .mbus_addr2_i     (mbus_addr_array[2]),
     .mbus_addr1_i     (mbus_addr_array[1]),
     .mbus_addr0_i     (mbus_addr_array[0]),
     .cbus_ack3_i      (cbus_ack3),
     .cbus_ack2_i      (cbus_ack2),
     .cbus_ack1_i      (cbus_ack1),
     .cbus_ack0_i      (cbus_ack0),
     // Outputs
     .cbus_addr_o      (cbus_addr),
     .cbus_cmd3_o      (cbus_cmd3),
     .cbus_cmd2_o      (cbus_cmd2),
     .cbus_cmd1_o      (cbus_cmd1),
     .cbus_cmd0_o      (cbus_cmd0),
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
     .cbus_addr_i      (cbus_addr),
     //                        \ /
     .cbus_cmd_i       (cbus_cmd3),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mbus_ack[3]),
     //                   \ /
     .cpu_id_i         (2'd3),
     //                      \ /
     .tb_ins_i         (tb_ins_array[3]),
     //                           \ /
     .tb_ins_addr_i    (tb_ins_addr3),
     // Outputs                \ /
     .mbus_cmd_o       (mbus_cmd_array[3]),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[3]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[3]),
     //                        \ /
     .cbus_ack_o       (cbus_ack3),
     //                          \ /
     .tb_ins_ack_o     (tb_ins_ack[3])
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
     .cbus_addr_i      (cbus_addr),
     //                        \ /
     .cbus_cmd_i       (cbus_cmd2),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mbus_ack[2]),
     //                   \ /
     .cpu_id_i         (2'd2),
     //                      \ /
     .tb_ins_i         (tb_ins_array[2]),
     //                           \ /
     .tb_ins_addr_i    (tb_ins_addr2),
     // Outputs                \ /
     .mbus_cmd_o       (mbus_cmd_array[2]),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[2]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[2]),
     //                        \ /
     .cbus_ack_o       (cbus_ack2),
     //                          \ /
     .tb_ins_ack_o     (tb_ins_ack[2])
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
     .cbus_addr_i      (cbus_addr),
     //                        \ /
     .cbus_cmd_i       (cbus_cmd1),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mbus_ack[1]),
     //                   \ /
     .cpu_id_i         (2'd1),
     //                      \ /
     .tb_ins_i         (tb_ins_array[1]),
     //                           \ /
     .tb_ins_addr_i    (tb_ins_addr1),
     // Outputs                \ /
     .mbus_cmd_o       (mbus_cmd_array[1]),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[1]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[1]),
     //                        \ /
     .cbus_ack_o       (cbus_ack1),
     //                          \ /
     .tb_ins_ack_o     (tb_ins_ack[1])
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
     .cbus_cmd_i       (cbus_cmd0),
     //                             \ /
     .mbus_data_i      (mbus_data_rd),
     //                        \ /
     .mbus_ack_i       (mbus_ack[0]),
     //                   \ /
     .cpu_id_i         (2'd0),
     //                      \ /
     .tb_ins_i         (tb_ins_array[0]),
     //                           \ /
     .tb_ins_addr_i    (tb_ins_addr0),
     // Outputs                \ /
     .mbus_cmd_o       (mbus_cmd_array[0]),
      //                        \ /
     .mbus_addr_o      (mbus_addr_array[0]),
      //                        \ /
     .mbus_data_o      (mbus_data_wr_array[0]),
     //                        \ /
     .cbus_ack_o       (cbus_ack0),
     //                           \ /
     .tb_ins_ack_o     (tb_ins_ack[0])
 );

endmodule
