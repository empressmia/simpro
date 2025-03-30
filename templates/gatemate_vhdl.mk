VCOM_LIB ?= $(shell find ./lib/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VCOM_SRC += $(shell find ./src/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))
VHDL_SRC ?= $(VCOM_LIB)
VHDL_SRC += $(VCOM_SRC)
GHDL_OPTIONS = --std=08 --warn-no-binding -C --ieee=synopsys --workdir=build --work=$(TOP)
GATEMATE_PR = $(HOME)/Downloads/cc-toolchain-linux/bin/p_r/p_r
PRFLAGS += -uCIO -ccf constraint/gatemate_$(TOP).ccf -cCP

gatemate_synth: $(VHDL_SRC)
	yosys -ql log/synth.log -m ghdl -p 'ghdl $(GHDL_OPTIONS) $^ -e $(TOP)_top; synth_gatemate -top $(TOP)_top -nomx8 -vlog net/$(TOP)_psn.v'
	
gatemate_pnr:
	$(GATEMATE_PR) -i net/$(TOP)_psn.v -o $(TOP) $(PRFLAGS) > log/$@.log
	
gatemate_clean:
	$(RM) log/gatemate_*
	$(RM) net/gate_mate*
	$(RM) *.history
	$(RM) *.txt
	$(RM) *.refwire
	$(RM) *.refparam
	$(RM) *.refcomp
	$(RM) *.pos
	$(RM) *.pathes
	$(RM) *.path_struc
	$(RM) *.net
	$(RM) *.id
	$(RM) *.prn
	$(RM) *_00.v
	$(RM) *.used
	$(RM) *.sdf
	$(RM) *.place
	$(RM) *.pin
	$(RM) *.cfg*
	$(RM) *.cdf
#	$(RM) sim/*.vcd
#	$(RM) sim/*.vvp
#	$(RM) sim/*.gtkw
