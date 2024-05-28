module PLL (clkin, clkout, lock);
    input clkin;
    output clkout;
    output lock;
 
/* icepll for 26MHz gives
F_PFD: 12.000MHz
F_VCO: 828.000 MHz
DIVR: 4'b0000
DIVF: 7'b1000100
DIVQ: 3'101
FILTER_RANGE: 3'b001
*/

    SB_PLL40_CORE pll(
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clkin),
        .PLLOUTCORE(clkout),
        .LOCK(lock)
    );

defparam pll.FEEDBACK_PATH = "SIMPLE";
defparam pll.DIVR = 4'b0000;
defparam pll.DIVF = 7'b1000100;
defparam pll.DIVQ = 3'b101;
defparam pll.FILTER_RANGE = 3'b001;

endmodule