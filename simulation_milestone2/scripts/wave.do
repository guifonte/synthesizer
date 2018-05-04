onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_milestone2_top/tb_clk_12m
add wave -noupdate -radix binary /testbench_milestone2_top/tb_data
add wave -noupdate -expand -group clk_gen -color {Dark Orchid} -itemcolor {Dark Orchid} /testbench_milestone2_top/DUT/inst_bclk_gen/clk_12M_i
add wave -noupdate -expand -group clk_gen -color {Dark Orchid} -itemcolor {Dark Orchid} /testbench_milestone2_top/DUT/inst_bclk_gen/bclk_o
add wave -noupdate -expand -group clk_gen -color {Dark Orchid} -itemcolor {Dark Orchid} /testbench_milestone2_top/DUT/inst_bclk_gen/reset_n
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} /testbench_milestone2_top/DUT/inst_frame_decoder/bclk
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} /testbench_milestone2_top/DUT/inst_frame_decoder/init_n
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} /testbench_milestone2_top/DUT/inst_frame_decoder/shift_L
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} /testbench_milestone2_top/DUT/inst_frame_decoder/shift_R
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} /testbench_milestone2_top/DUT/inst_frame_decoder/strobe
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} /testbench_milestone2_top/DUT/inst_frame_decoder/WS_o
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} -radix unsigned /testbench_milestone2_top/DUT/inst_frame_decoder/count
add wave -noupdate -expand -group {frame_decoder
} -color {Slate Blue} -itemcolor {Slate Blue} -radix unsigned /testbench_milestone2_top/DUT/inst_frame_decoder/next_count
add wave -noupdate -expand -group {s2p_left
} -color {Lime Green} -itemcolor {Lime Green} /testbench_milestone2_top/DUT/inst_s2p_left/reset_n
add wave -noupdate -expand -group {s2p_left
} -color {Lime Green} -itemcolor {Lime Green} /testbench_milestone2_top/DUT/inst_s2p_left/enable
add wave -noupdate -expand -group {s2p_left
} -color {Lime Green} -itemcolor {Lime Green} /testbench_milestone2_top/DUT/inst_s2p_left/shift
add wave -noupdate -expand -group {s2p_left
} -color {Lime Green} -itemcolor {Lime Green} /testbench_milestone2_top/DUT/inst_s2p_left/ser_i
add wave -noupdate -expand -group {s2p_left
} -color {Lime Green} -itemcolor {Lime Green} -radix binary -childformat {{/testbench_milestone2_top/DUT/inst_s2p_left/par_o(15) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(14) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(13) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(12) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(11) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(10) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(9) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(8) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(7) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(6) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(5) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(4) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(3) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(2) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(1) -radix binary} {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(0) -radix binary}} -subitemconfig {/testbench_milestone2_top/DUT/inst_s2p_left/par_o(15) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(14) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(13) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(12) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(11) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(10) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(9) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(8) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(7) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(6) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(5) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(4) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(3) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(2) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(1) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary} /testbench_milestone2_top/DUT/inst_s2p_left/par_o(0) {-color {Lime Green} -height 15 -itemcolor {Lime Green} -radix binary}} /testbench_milestone2_top/DUT/inst_s2p_left/par_o
add wave -noupdate -expand -group {s2p_right
} -color {Violet Red} -itemcolor {Violet Red} /testbench_milestone2_top/DUT/inst_s2p_right/reset_n
add wave -noupdate -expand -group {s2p_right
} -color {Violet Red} -itemcolor {Violet Red} /testbench_milestone2_top/DUT/inst_s2p_right/enable
add wave -noupdate -expand -group {s2p_right
} -color {Violet Red} -itemcolor {Violet Red} /testbench_milestone2_top/DUT/inst_s2p_right/shift
add wave -noupdate -expand -group {s2p_right
} -color {Violet Red} -itemcolor {Violet Red} /testbench_milestone2_top/DUT/inst_s2p_right/ser_i
add wave -noupdate -expand -group {s2p_right
} -color {Violet Red} -itemcolor {Violet Red} /testbench_milestone2_top/DUT/inst_s2p_right/par_o
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/clk_12M
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/reset_n
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/enable
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/shift
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/load
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/par_i
add wave -noupdate -expand -group {p2s_left
} -color {Cadet Blue} -itemcolor {Cadet Blue} /testbench_milestone2_top/DUT/inst_p2s_left/ser_o
add wave -noupdate -expand -group p2s_right -color {Cornflower Blue} -itemcolor {Cornflower Blue} /testbench_milestone2_top/DUT/inst_p2s_right/reset_n
add wave -noupdate -expand -group p2s_right -color {Cornflower Blue} -itemcolor {Cornflower Blue} /testbench_milestone2_top/DUT/inst_p2s_right/enable
add wave -noupdate -expand -group p2s_right -color {Cornflower Blue} -itemcolor {Cornflower Blue} /testbench_milestone2_top/DUT/inst_p2s_right/shift
add wave -noupdate -expand -group p2s_right -color {Cornflower Blue} -itemcolor {Cornflower Blue} /testbench_milestone2_top/DUT/inst_p2s_right/load
add wave -noupdate -expand -group p2s_right -color {Cornflower Blue} -itemcolor {Cornflower Blue} /testbench_milestone2_top/DUT/inst_p2s_right/par_i
add wave -noupdate -expand -group p2s_right -color {Cornflower Blue} -itemcolor {Cornflower Blue} /testbench_milestone2_top/DUT/inst_p2s_right/ser_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22773 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 370
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {29520 ns} {36912 ns}
