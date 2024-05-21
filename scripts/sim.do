cd ../vfy
##1 建立库(物理目录)
vlib work
##2 映射库到物理目录
vmap work work
##3 编译源代码（源代码+仿真tb）
vlog -sv -work work ../pkg/definitions.sv
vlog -sv -work work ../src/precompute.sv -cover bescfx
vlog -sv -work work ../sim/tb_precompute.sv -cover bescfx
##4 启动仿真器
#evoke the simulation
vsim -voptargs=+acc work.tb_precompute
##5添加需要观测的变量
add wave *
##6 执行仿真
run -all