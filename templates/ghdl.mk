VCOM_LIB ?= $(shell find ./lib/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VCOM_SRC += $(shell find ./src/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VHDL_SRC ?= $(VCOM_LIB)
VHDL_SRC += $(VCOM_SRC)
VHDL_TB  ?= $(shell find ./bench/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
GHDL_SIM_FLAGS = --std=08 --workdir=build --work=$(TOP) 

analyse_src: $(VHDL_SRC)
	ghdl -a --std=08 --workdir=build --work=$(TOP) $^

analyse_bench: $(VHDL_TB)
	ghdl -a $(GHDL_SIM_FLAGS) $^

elaborate_bench:	
	ghdl -e $(GHDL_SIM_FLAGS) tb_blink


sim_vhdl:
	make analyse_src
	make analyse_bench
	make elaborate_bench
	ghdl -r $(GHDL_SIM_FLAGS) tb_$(TOP) --wave=sim/tb_$(TOP).vcd

ghdl_clean:
	rm *.o
	rm tb_$(TOP)
	
