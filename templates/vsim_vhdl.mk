VCOM_LIB   ?= $(shell find ./lib/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VCOM_SRC   += $(shell find ./src/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VHDL_SRC   ?= $(VCOM_LIB)
VHDL_SRC   += $(VCOM_SRC)
VHDL_TB    ?= $(shell find ./bench/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VSIM_FLAGS ?= -quiet -64 -work $(TOP)

vsim:
	make vsim_common
	make vsim_vcom
	cd build && \
	vsim $(VSIM_FLAGS) $(TOP).tb_$(TOP) -title $(TOP) -runinit -do ../vsim.do

vsim_common:
	vlib build
	vmap $(TOP) build
	
vsim_vcom: $(VHDL_SRC)
	vcom $(VSIM_FLAGS) -2008  $^

vsim_batch:
	cd build && vsim $(VSIM_FLAGS) $(TOP).tb_$(TOP) -c -runinit -do ../vsim.do

vsim_clean:
	rm build/*
	
.PHONY: vsim_clean vsim vsim_batch
