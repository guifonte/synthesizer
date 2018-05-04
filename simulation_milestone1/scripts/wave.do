onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_audio_synth_top/tb_clock_50
add wave -noupdate /testbench_audio_synth_top/tb_reset_n
add wave -noupdate /testbench_audio_synth_top/tb_init_n
add wave -noupdate /testbench_audio_synth_top/tb_sw
add wave -noupdate /testbench_audio_synth_top/tb_aud_xck
add wave -noupdate /testbench_audio_synth_top/tb_i2c_sclk
add wave -noupdate /testbench_audio_synth_top/tb_i2c_sdat
add wave -noupdate /testbench_audio_synth_top/tb_reg0_up
add wave -noupdate /testbench_audio_synth_top/tb_reg0_lo
add wave -noupdate /testbench_audio_synth_top/DUT/inst_infrastructure_block/inst_takt_teiler/clk_slow_o
add wave -noupdate /testbench_audio_synth_top/DUT/inst_infrastructure_block/inst_sync_block_1/syncd_o
add wave -noupdate /testbench_audio_synth_top/DUT/inst_infrastructure_block/inst_sync_block_2/syncd_o
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/fsm_state
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/reg
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/reset_n
add wave -noupdate -expand -group {FSM
} -color Cyan -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/write_done_i
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/event_control_i
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/initialize_n
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/ack_error_i
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/write_o
add wave -noupdate -expand -group {FSM
} -itemcolor Orange /testbench_audio_synth_top/DUT/inst_codec_control/write_data_o
add wave -noupdate /testbench_audio_synth_top/DUT/inst_i2c_master/write_done
add wave -noupdate -expand -group {IC2MASTER
} /testbench_audio_synth_top/DUT/inst_i2c_master/write_i
add wave -noupdate -expand -group {IC2MASTER
} /testbench_audio_synth_top/DUT/inst_i2c_master/write_data_i
add wave -noupdate -expand -group {IC2MASTER
} /testbench_audio_synth_top/DUT/inst_i2c_master/next_data
add wave -noupdate -expand -group {IC2MASTER
} /testbench_audio_synth_top/DUT/inst_i2c_master/data
add wave -noupdate -expand -group {IC2MASTER
} /testbench_audio_synth_top/DUT/inst_i2c_master/next_write_done
add wave -noupdate -expand -group {IC2MASTER
} /testbench_audio_synth_top/DUT/inst_i2c_master/write_done_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {799837 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {822 ns}
