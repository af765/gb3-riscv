DESIGN = hardwareblink
GB3_ROOT = /gb3-resources
sail-nextpnr:
	mkdir -p $(GB3_ROOT)/build
	yosys -l stats.txt -p "synth_ice40 -blif $(DESIGN).blif; write_json $(DESIGN).json" $(DESIGN).v
	nextpnr-ice40 --up5k --package uwg30 --json $(DESIGN).json --pcf $(DESIGN).pcf --asc $(DESIGN).asc
	icepack $(DESIGN).asc design.bin
	icetime -d up5k -mtr design.rpt $(DESIGN).asc
	cp design.bin $(GB3_ROOT)/build/
	cp design.rpt $(GB3_ROOT)/build/
	cp stats.txt $(GB3_ROOT)/build/


clean:
	rm -f *.json *.blif *.asc *.bin *.rpt