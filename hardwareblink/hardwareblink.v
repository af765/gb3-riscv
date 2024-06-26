`define	kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz	2500

module blink(led);
	output		led;

	wire		clk;
	reg		LEDstatus = 1;
	reg [12:0]	count = 0;

	/*
	 *	Creates a 10 KHz clock signal from
	 *	internal oscillator of the iCE40
	 */
	SB_LFOSC OSCInst1 (
		.CLKLFPU(1'b1),
		.CLKLFEN(1'b1),
		.CLKLF(clk)
	);

	// defparam OSCInst0.CLKHF_DIV = "0b01"; Not needed for the LF clock
	/*
	 *	Blinks LED at approximately 2Hz. The constant kFofE_CLOCK_DIVIDER_FOR_1Hz
	 *	(defined above) is calibrated to yield a blink rate of about 2Hz.
	 */
	always @(posedge clk) begin
		if (count > `kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz) begin
			LEDstatus <= !LEDstatus;
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end


	/*
	 *	Assign output led to value in LEDstatus register
	 */
	assign	led = LEDstatus;
endmodule
