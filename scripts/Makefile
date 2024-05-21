.PHONY:sim

sim:
	cd ../vfy
	vlib work
	vmap work work
	vlog -sv -work work ../pkg/definitions.sv
	vlog -sv -work work ../src/precompute.sv -cover bescfx
	vlog -sv -work work ../sim/tb_precompute.sv -cover bescfx
	vsim -voptargs=+acc work.tb_precompute
	add wave *
	run -all