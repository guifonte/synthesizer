# create work library
# vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/frame_decoder.vhd
vcom -2008 -explicit -work work ../../source/p2s_register.vhd
vcom -2008 -explicit -work work ../../source/s2p_register.vhd
vcom -2008 -explicit -work work ../../source/bclk_gen.vhd
vcom -2008 -explicit -work work ../../source/i2s_master_top.vhd
vcom -2008 -explicit -work work ../../source/testbench_milestone2_top.vhd

# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_milestone2_top
do ../scripts/wave.do
run 1500.0 us
