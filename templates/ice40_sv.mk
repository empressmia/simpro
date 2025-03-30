VLOG_LIB ?= $(shell find ./lib/ -type f \( -iname \*.v -o -iname \*.sv \))
VLOG_SRC += $(shell find ./src/ -type f \( -iname \*.v -o -iname \*.sv \))
SV_SRC   ?= $(VLOG_LIB)
SV_SRC   += $(VLOG_SRC)

ice40_synth: $(SV_SRC)
	yosys -qql log/ice40_synth_$(TOP).log -p 'read_verilog -sv $^; synth_ice40 -top $(TOP) -json build/ice40_$(TOP).json
	
ice40_pnr:
	nextpnr-ice40 --hx1k --json build/ice40_$(TOP).json --pcf constraint/ice40_$(TOP).pcf --asc build/ice40_$(TOP).asc --package tq144 --pcf-allow-unconstrained
	
ice40_timing:
	icetime -d hx1k -mtr log/ice40_timing_$(TOP).rpt build/ice40_$(TOP).asc
	
ice40_prog:
	iceprog build/ice40_$(TOP).bin
