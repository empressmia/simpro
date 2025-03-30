VLOG_LIB ?= $(shell find ./lib/ -type f \( -iname \*.v -o -iname \*.sv \))
VLOG_SRC += $(shell find ./src/ -type f \( -iname \*.v -o -iname \*.sv \))
SV_SRC   ?= $(VLOG_LIB)
SV_SRC   += $(VLOG_SRC)

gatemate_synth: $(SV_SRC)
	yosys -qql log/gatemate_synth_$(TOP).log -p 'read_verilog -sv $^; synth_gatemate -top $(TOP) -nomx8 -vlog net/$(TOP)_psn.v'
