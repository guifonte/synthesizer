# create work library
# vlib work

# compile project files


vcom -2008 -explicit -work work ../../source/audio_filter_pkg.vhd
vcom -2008 -explicit -work work ../../source/reg_table_pkg.vhd
vcom -2008 -explicit -work work ../../source/tone_gen_pkg.vhd

vcom -2008 -explicit -work work ../../source/bclk_gen.vhd
vcom -2008 -explicit -work work ../../source/codec_control.vhd
vcom -2008 -explicit -work work ../../source/DDS.vhd
vcom -2008 -explicit -work work ../../source/fir_core.vhd
vcom -2008 -explicit -work work ../../source/frame_decoder.vhd
vcom -2008 -explicit -work work ../../source/i2c_master.vhd
vcom -2008 -explicit -work work ../../source/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../source/midi_controler.vhd
vcom -2008 -explicit -work work ../../source/p2s_register.vhd

vcom -2008 -explicit -work work ../../source/s2p_register.vhd
vcom -2008 -explicit -work work ../../source/single_port_ram.vhd
vcom -2008 -explicit -work work ../../source/sync_block.vhd
vcom -2008 -explicit -work work ../../source/takt_teiler.vhd
vcom -2008 -explicit -work work ../../source/tone_decoder.vhd
vcom -2008 -explicit -work work ../../source/UART_fsm.vhd
vcom -2008 -explicit -work work ../../source/UART_modulo_divider.vhd
vcom -2008 -explicit -work work ../../source/UART_rx_register_s2p.vhd
vcom -2008 -explicit -work work ../../source/UART_sync_n_edgeDetector.vhd
vcom -2008 -explicit -work work ../../source/UART_tick_generator.vhd
vcom -2008 -explicit -work work ../../source/UART__rx_only_top.vhd

vcom -2008 -explicit -work work ../../source/i2s_master_top.vhd
vcom -2008 -explicit -work work ../../source/infrastructure_block.vhd
vcom -2008 -explicit -work work ../../source/dds_top.vhd
vcom -2008 -explicit -work work ../../source/digital_audio_interface_driver_top.vhd
vcom -2008 -explicit -work work ../../source/Milestone3_infrastructure_block.vhd
vcom -2008 -explicit -work work ../../source/midi_testbench.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.midi_testbench
do ../scripts/wave.do
run 9000.0 us