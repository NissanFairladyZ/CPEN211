onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_task1/testtask1/taskcpu/control/clk
add wave -noupdate /tb_task1/testtask1/taskcpu/control/rst_n
add wave -noupdate /tb_task1/testtask1/taskcpu/control/state
add wave -noupdate /tb_task1/testtask1/taskcpu/ram_r_data
add wave -noupdate /tb_task1/testtask1/ram_addr
add wave -noupdate /tb_task1/testtask1/taskcpu/pc
add wave -noupdate /tb_task1/testtask1/taskcpu/decode/ir
add wave -noupdate /tb_task1/testtask1/taskram/ram_w_data
add wave -noupdate /tb_task1/testtask1/taskcpu/newdatapath/reg_B
add wave -noupdate /tb_task1/testtask1/taskcpu/newdatapath/reg_C
add wave -noupdate /tb_task1/testtask1/taskcpu/newdatapath/en_C
add wave -noupdate -divider {New Divider}
add wave -noupdate {/tb_task1/testtask1/taskram/m[48]}
add wave -noupdate {/tb_task1/testtask1/taskram/m[49]}
add wave -noupdate -divider {New Divider}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[0]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[1]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[2]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[3]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[4]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[5]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[6]}
add wave -noupdate {/tb_task1/testtask1/taskcpu/newdatapath/register/m[7]}
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_task1/testtask1/taskcpu/control/ram_w_en
add wave -noupdate /tb_task1/testtask1/taskcpu/control/sel_addr
add wave -noupdate /tb_task1/testtask1/taskcpu/control/load_pc
add wave -noupdate /tb_task1/testtask1/taskcpu/control/clear_pc
add wave -noupdate /tb_task1/testtask1/taskcpu/control/load_addr
add wave -noupdate /tb_task1/testtask1/taskcpu/control/load_ir
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1484 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1763 ps} {1881 ps}
