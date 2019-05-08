//EE382M-Verification of Digital Systems
//
//
//Modules - 
//SystemVerilog Properties for the module - 
//`include "/home/ecelrc/students/bvinay/verif_labs/VERIF_PROJECT_VSMB/tb/mesi_isc_define.v"
//`include "/home/ecelrc/students/bvinay/verif_labs/VERIF_PROJECT_VSMB/tb/mesi_isc_tb_define.v"


//Reset values for output signals from the MESI Intersection Controller

mbus_ack_reset0: assert property(@(posedge clk) $past(rst,1) |-> !$past(mbus_ack_mesi_isc[0],1));
mbus_ack_reset1: assert property(@(posedge clk) $past(rst,1) |-> !$past(mbus_ack_mesi_isc[1],1));
mbus_ack_reset2: assert property(@(posedge clk) $past(rst,1) |-> !$past(mbus_ack_mesi_isc[2],1));
mbus_ack_reset3: assert property(@(posedge clk) $past(rst,1) |-> !$past(mbus_ack_mesi_isc[3],1));

cbus_cmd_reset0: assert property(@(posedge clk) $past(rst,1) |-> $past(cif.cbus_cmd0_o,1)==`MESI_ISC_CBUS_CMD_NOP);
cbus_cmd_reset1: assert property(@(posedge clk) $past(rst,1) |-> $past(cif.cbus_cmd1_o,1)==`MESI_ISC_CBUS_CMD_NOP);
cbus_cmd_reset2: assert property(@(posedge clk) $past(rst,1) |-> $past(cif.cbus_cmd2_o,1)==`MESI_ISC_CBUS_CMD_NOP);
cbus_cmd_reset3: assert property(@(posedge clk) $past(rst,1) |-> $past(cif.cbus_cmd3_o,1)==`MESI_ISC_CBUS_CMD_NOP);

cbus_addr_reset: assert property(@(posedge clk) $past(rst,1) |-> $past(cif.cbus_addr_o,1)==32'd0);

//assert properties for the mbus_ack_o

mbus_cmd0_assert:assert property(@(posedge clk) mif.mbus_cmd0_i inside {3,4} |-> ##[0:2] $rose(mbus_ack_mesi_isc[0]) ##1 !mbus_ack_mesi_isc[0]); //POSSIBLE BUG
mbus_cmd1_assert:assert property(@(posedge clk) mif.mbus_cmd1_i inside {3,4} |-> ##[0:2] $rose(mbus_ack_mesi_isc[1]) ##1 !mbus_ack_mesi_isc[1]);
mbus_cmd2_assert:assert property(@(posedge clk) mif.mbus_cmd2_i inside {3,4} |-> ##[0:2] $rose(mbus_ack_mesi_isc[2]) ##1 !mbus_ack_mesi_isc[2]);
mbus_cmd3_assert:assert property(@(posedge clk) mif.mbus_cmd3_i inside {3,4} |-> ##[0:2] $rose(mbus_ack_mesi_isc[3]) ##1 !mbus_ack_mesi_isc[3]);

assert property(@(posedge clk) mif.mbus_cmd0_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_WR_SNOOP));
assert property(@(posedge clk) mif.mbus_cmd1_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_WR_SNOOP));
assert property(@(posedge clk) mif.mbus_cmd2_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_WR_SNOOP));
assert property(@(posedge clk) mif.mbus_cmd3_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_WR_SNOOP && cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_WR_SNOOP));

assert property(@(posedge clk) mif.mbus_cmd0_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_RD_SNOOP));
assert property(@(posedge clk) mif.mbus_cmd1_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_RD_SNOOP));
assert property(@(posedge clk) mif.mbus_cmd2_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_RD_SNOOP));
assert property(@(posedge clk) mif.mbus_cmd3_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_RD_SNOOP && cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_RD_SNOOP));

assert property(@(posedge clk) !$isunknown(cif.cbus_cmd0_o));
assert property(@(posedge clk) !$isunknown(cif.cbus_cmd1_o));
assert property(@(posedge clk) !$isunknown(cif.cbus_cmd2_o));
assert property(@(posedge clk) !$isunknown(cif.cbus_cmd3_o));

assert property(@(posedge clk) $changed(cif.cbus_cmd0_o) |=> cif.cbus_cmd0_o inside {0,1,2,3,4});
assert property(@(posedge clk) $changed(cif.cbus_cmd1_o) |=> cif.cbus_cmd1_o inside {0,1,2,3,4});
assert property(@(posedge clk) $changed(cif.cbus_cmd2_o) |=> cif.cbus_cmd2_o inside {0,1,2,3,4});
assert property(@(posedge clk) $changed(cif.cbus_cmd3_o) |=> cif.cbus_cmd3_o inside {0,1,2,3,4});

assert property(@(posedge clk) mif.mbus_cmd0_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_ack1_i && cif.cbus_ack2_i && cif.cbus_ack3_i) ##1 cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_EN_WR);
assert property(@(posedge clk) mif.mbus_cmd1_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_ack0_i && cif.cbus_ack2_i && cif.cbus_ack3_i) ##1 cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_EN_WR);
assert property(@(posedge clk) mif.mbus_cmd2_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_ack0_i && cif.cbus_ack1_i && cif.cbus_ack3_i) ##1 cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_EN_WR);
assert property(@(posedge clk) mif.mbus_cmd3_i==`MESI_ISC_MBUS_CMD_WR_BROAD |-> ##[1:$] (cif.cbus_ack0_i && cif.cbus_ack1_i && cif.cbus_ack2_i) ##1 cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_EN_WR);

assert property(@(posedge clk) mif.mbus_cmd0_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_ack1_i && cif.cbus_ack2_i && cif.cbus_ack3_i) ##1 cif.cbus_cmd0_o==`MESI_ISC_CBUS_CMD_EN_RD);
assert property(@(posedge clk) mif.mbus_cmd1_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_ack0_i && cif.cbus_ack2_i && cif.cbus_ack3_i) ##1 cif.cbus_cmd1_o==`MESI_ISC_CBUS_CMD_EN_RD);
assert property(@(posedge clk) mif.mbus_cmd2_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_ack0_i && cif.cbus_ack1_i && cif.cbus_ack3_i) ##1 cif.cbus_cmd2_o==`MESI_ISC_CBUS_CMD_EN_RD);
assert property(@(posedge clk) mif.mbus_cmd3_i==`MESI_ISC_MBUS_CMD_RD_BROAD |-> ##[1:$] (cif.cbus_ack0_i && cif.cbus_ack1_i && cif.cbus_ack2_i) ##1 cif.cbus_cmd3_o==`MESI_ISC_CBUS_CMD_EN_RD);


