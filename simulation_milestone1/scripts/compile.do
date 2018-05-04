# create work library
# vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/reg_table_pkg.vhd
vcom -2008 -explicit -work work ../../source/codec_control.vhd
vcom -2008 -explicit -work work ../../source/i2c_master.vhd
vcom -2008 -explicit -work work ../../source/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../source/sync_block.vhd
vcom -2008 -explicit -work work ../../source/takt_teiler.vhd
vcom -2008 -explicit -work work ../../source/infrastructure_block.vhd
vcom -2008 -explicit -work work ../../source/Milestone1_infrastructure_block.vhd
vcom -2008 -explicit -work work ../../source/testbench_audio_synth_top.vhd

# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_audio_synth_top
do ../scripts/wave.do
run 1500.0 us
