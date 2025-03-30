VCOM_LIB ?= $(shell find ./lib/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VCOM_SRC += $(shell find ./src/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VHDL_SRC ?= $(VCOM_LIB)
VHDL_SRC += $(VCOM_SRC)
GHDL_OPTIONS = --std=08 --warn-no-binding -C --ieee=synopsys --workdir=build --work=$(TOP)

ice40_synth: $(VHDL_SRC)
	yosys -qql log/ice40_synth_$(TOP).log -m ghdl -p 'ghdl $(GHDL_OPTIONS) $^ -e $(TOP)_top; synth_ice40 -top $(TOP)_top -json build/ice40_$(TOP).json'

ice40_pnr:
	nextpnr-ice40 --hx1k --json build/ice40_$(TOP).json --pcf constraint/ice40_$(TOP).pcf --asc build/ice40_$(TOP).asc --package tq144 --pcf-allow-unconstrained
	
ice40_timing:
	icetime -d hx1k -mtr log/ice40_timing_$(TOP).rpt build/ice40_$(TOP).asc

ice40_prog:
	iceprog build/ice40_$(TOP).bin
