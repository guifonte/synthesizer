onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /midi_testbench/DUT/CLOCK_50
add wave -noupdate -group SW /midi_testbench/tb_sw(9)
add wave -noupdate -group SW /midi_testbench/tb_sw(8)
add wave -noupdate -group SW /midi_testbench/tb_sw(4)
add wave -noupdate -group SW /midi_testbench/tb_sw(3)
add wave -noupdate -group SW /midi_testbench/tb_sw(2)
add wave -noupdate -group SW /midi_testbench/tb_sw(1)
add wave -noupdate -group SW /midi_testbench/tb_sw(0)
add wave -noupdate /midi_testbench/tb_gpio_0(0)
add wave -noupdate -group {DDS_TOP
} -color {Medium Orchid} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/midi_serial_i
add wave -noupdate -group {DDS_TOP
} -color {Medium Orchid} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/wave_ctrl
add wave -noupdate -group {DDS_TOP
} -color {Medium Orchid} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/clock
add wave -noupdate -group {DDS_TOP
} -color {Medium Orchid} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/strobe_i
add wave -noupdate -group {DDS_TOP
} -color {Medium Orchid} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/rst_n
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/CLOCK_50
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/RESET_N
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/GPIO_1
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/DATA_VALID_O
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/DATA_O
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/sync2fsm
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/sync2rx
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/tick_top
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/activator_top
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/halfsize_top
add wave -noupdate -expand -group {UART
} -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/mod_clk
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/width
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/clk
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/reset_n
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/ativo
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/half
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/tick_o
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/count
add wave -noupdate -group UART_Tick_gen -color {Sky Blue} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_tick_generator/next_count
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/clk
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/reset_n
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/tick
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/fall
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/tick_halfsize
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/tick_activator
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/s_state
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/s_nextstate
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/count
add wave -noupdate -group {UART_FSM
} -color Pink /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_fsm/next_count
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/clk
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/reset_n
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/activator
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/midi_o
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/data_valid_out
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/ser_i
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/shiftreg
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/next_shiftreg
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/count
add wave -noupdate -group UART_S2P -color {Violet Red} /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_rx_register_s2p/next_count
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/rx_data_valid_in
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/rx_data_in
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/clk
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/reset_n
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/midi_cmds
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/midi_state
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/next_midi_state
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/note_action
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/next_note_action
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/num_buf
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/next_num_buf
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/vel_buf
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/next_vel_buf
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/midi_regs
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/next_midi_regs
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/note_update
add wave -noupdate -expand -group MIDI_CONTROLLER /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_midi_controller/next_note_update
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8170067 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 199
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
WaveRestoreZoom {7131312 ns} {9098352 ns}
