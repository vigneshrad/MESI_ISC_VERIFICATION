# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the sources.
vlog ../rtl/mesi_isc_basic_fifo.v ../rtl/mesi_isc_breq_fifos_cntl.v ../rtl/mesi_isc_breq_fifos.v ../rtl/mesi_isc_broad_cntl.v ../rtl/mesi_isc_broad.v ../rtl/mesi_isc_define.v ../rtl/mesi_isc.v
vlog ../tb/mesi_isc_tb_define.v ../tb/mesi_isc_tb_cpu.v 
#../tb/mesi_isc_tb_sanity_check.v
vlog +cover -sv ../tb/interfaces.sv ../tb/sequences.sv ../tb/coverage.sv ../tb/scoreboard.sv ../tb/modules.sv ../tb/tests.sv  ../tb/top.sv

#Simulate the design.
vsim -c mesi_isc_tb -permit_unmatched_virtual_intf
run -all
#exit
