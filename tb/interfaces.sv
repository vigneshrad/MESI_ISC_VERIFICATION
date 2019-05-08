`define MBUS_CMD_WIDTH 3
`define CBUS_CMD_WIDTH 3
`define ADDR_WIDTH 32

interface mbus;
logic                   clk;          // System clock
logic                   rst;          // Active high system reset

logic [`MBUS_CMD_WIDTH-1:0] mbus_cmd3_i; // Main bus3 command
logic [`MBUS_CMD_WIDTH-1:0] mbus_cmd2_i; // Main bus2 command
logic [`MBUS_CMD_WIDTH-1:0] mbus_cmd1_i; // Main bus1 command
logic [`MBUS_CMD_WIDTH-1:0] mbus_cmd0_i; // Main bus0 command

logic                  mbus_ack3_o;  // Main bus3 acknowledge
logic                  mbus_ack2_o;  // Main bus2 acknowledge
logic                  mbus_ack1_o;  // Main bus1 acknowledge
logic                  mbus_ack0_o;  // Main bus0 acknowledge
endinterface: mbus

interface cbus;
logic                   clk;          // System clock
logic                   rst;          // Active high system reset

logic [`ADDR_WIDTH-1:0]  mbus_addr3_i;  // Coherence bus3 address
logic [`ADDR_WIDTH-1:0]  mbus_addr2_i;  // Coherence bus2 address
logic [`ADDR_WIDTH-1:0]  mbus_addr1_i;  // Coherence bus1 address
logic [`ADDR_WIDTH-1:0]  mbus_addr0_i;  // Coherence bus0 address
logic                   cbus_ack3_i;  // Coherence bus3 acknowledge
logic                   cbus_ack2_i;  // Coherence bus2 acknowledge
logic                   cbus_ack1_i;  // Coherence bus1 acknowledge
logic                   cbus_ack0_i;  // Coherence bus0 acknowledge

logic [`ADDR_WIDTH-1:0] cbus_addr_o;  // Coherence bus address. All busses have the same address
logic [`CBUS_CMD_WIDTH-1:0] cbus_cmd3_o; // Coherence bus3 command
logic [`CBUS_CMD_WIDTH-1:0] cbus_cmd2_o; // Coherence bus2 command
logic [`CBUS_CMD_WIDTH-1:0] cbus_cmd1_o; // Coherence bus1 command
logic [`CBUS_CMD_WIDTH-1:0] cbus_cmd0_o; // Coherence bus0 command

endinterface: cbus

interface tb_bus;
    logic clk;
     logic [3:0] tb_ins_array[3:0];
     logic [3:0] tb_ins_addr[3:0];
     logic [3:0] tb_ins_ack;
     logic [3:0] cpu_busy;

endinterface: tb_bus

