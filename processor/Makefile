DESIGN	= sail
GB3_ROOT = /gb3-resources

sail-nextpnr:
	mkdir -p $(GB3_ROOT)/build
	cp programs/data.hex verilog/
	cp programs/program.hex verilog/
	yosys -l yosysstats.txt -q $(GB3_ROOT)/processor/yscripts/$(DESIGN).ys
	nextpnr-ice40 -l nextpnrstats.txt --up5k --package uwg30 --json $(DESIGN).json --pcf pcf/$(DESIGN).pcf --asc $(DESIGN).asc
	icetime -p pcf/sail.pcf -P uwg30 -d up5k -r timing.txt sail.asc
	icepack $(DESIGN).asc design.bin
	cp design.bin $(GB3_ROOT)/build/
	cp yosysstats.txt $(GB3_ROOT)/build/
	cp timing.txt $(GB3_ROOT)/build/
	cp nextpnrstats.txt $(GB3_ROOT)/build/


clean:
	rm -f *.json *.blif *.asc *.bin
	rm -f programs/*.hex
	rm -f verilog/*.hex
	rm -f timing.txt
	rm -f yosysstats.txt
	rm -f nextpnrstats.txt