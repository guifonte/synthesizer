onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /midi_testbench/DUT/CLOCK_50
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(9)
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(8)
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(4)
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(3)
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(2)
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(1)
add wave -noupdate -expand -group SW /midi_testbench/tb_sw(0)
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
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/CLOCK_50
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/RESET_N
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/GPIO_1
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/DATA_VALID_O
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/DATA_O
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/sync2fsm
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/sync2rx
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/tick_top
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/activator_top
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/halfsize_top
add wave -noupdate -group UART -color Cyan /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/mod_clk
add wave -noupdate -expand -group UART_sync_n_edge -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_sync_n_edgeDetector/data_in
add wave -noupdate -expand -group UART_sync_n_edge -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_sync_n_edgeDetector/clock
add wave -noupdate -expand -group UART_sync_n_edge -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_sync_n_edgeDetector/reset_n
add wave -noupdate -expand -group UART_sync_n_edge -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_sync_n_edgeDetector/data_out
add wave -noupdate -expand -group UART_sync_n_edge -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_sync_n_edgeDetector/rise
add wave -noupdate -expand -group UART_sync_n_edge -color Yellow /midi_testbench/DUT/inst_digital_audio_interface_driver_top/inst_dds_top/inst_uart_rx_only_top/inst_sync_n_edgeDetector/fall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
WaveRestoreZoom {1475274 ns} {2458794 ns}
