module dsp(A, B, out, clk, add_sub);
    input [31:0] A;
    input [31:0] B;
    input clk;
    input add_sub;
    output [31:0] out;

    wire [31:0] DSP_input1;

    mux2to1 muxy(.input0(B), .input1(~B), .select(add_sub), .out(DSP_input1));

    SB_MAC16 i_sbmac16_adder(
        .A(A[31:16]),
        .B(A[15:0]),
        .C(DSP_input1[31:16]),
        .D(DSP_input1[15:0]),
        .O(out),
        .CLK(clk),
        .CE(1'b1),
        .IRSTTOP(1'b0),
        .IRSTBOT(1'b0),
        .ORSTTOP(1'b0),
        .ORSTBOT(1'b0),
        .AHOLD(1'b0),
        .BHOLD(1'b0),
        .CHOLD(1'b0),
        .DHOLD(1'b0),
        .OHOLDTOP(1'b0),
        .OHOLDBOT(1'b0),
        .OLOADTOP(1'b0),
        .OLOADBOT(1'b0),
        .ADDSUBTOP(1'b0), //0 for add
        .ADDSUBBOT(1'b0), //0 for add
        .CO(),
        .CI(add_sub), //no carry in
        //MAC cascading ports.
        .ACCUMCI(1'b0),
        .ACCUMCO(),
        .SIGNEXTIN(1'b0),
        .SIGNEXTOUT()
    );
// mult_8x8_all_pipelined_unsigned [24:0] = 001_0000010_0000010_0111_0110
// Read configuration settings [24:0] from left to right while filling the instance parameters.
defparam i_sbmac16_adder.B_SIGNED = 1'b0;
defparam i_sbmac16_adder.A_SIGNED = 1'b0;
defparam i_sbmac16_adder.MODE_8x8 = 1'b1; //1 for low power multiply disable
defparam i_sbmac16_adder.BOTADDSUB_CARRYSELECT = 2'b00; //00 for 0 carry in
defparam i_sbmac16_adder.BOTADDSUB_UPPERINPUT = 1'b1;// 1 for input from register D
defparam i_sbmac16_adder.BOTADDSUB_LOWERINPUT = 2'b00;//00 for input from register B
defparam i_sbmac16_adder.BOTOUTPUT_SELECT = 2'b00; //00 for output from lower add/sub
defparam i_sbmac16_adder.TOPADDSUB_CARRYSELECT = 2'b10;// 10 for cascade with lower adder
defparam i_sbmac16_adder.TOPADDSUB_UPPERINPUT = 1'b1; // 1 for input from register
defparam i_sbmac16_adder.TOPADDSUB_LOWERINPUT = 2'b00; //00 for input from registers
defparam i_sbmac16_adder.TOPOUTPUT_SELECT = 2'b00; //00 for add/subtract
defparam i_sbmac16_adder.PIPELINE_16x16_MULT_REG2 = 1'b0; //0 for low power as not using 16x16 multiply
defparam i_sbmac16_adder.PIPELINE_16x16_MULT_REG1 = 1'b0; //same as above
defparam i_sbmac16_adder.BOT_8x8_MULT_REG = 1'b0 ; //0 as not using multiply
defparam i_sbmac16_adder.TOP_8x8_MULT_REG = 1'b0 ;//0 as not using multiply
defparam i_sbmac16_adder.D_REG = 1'b0 ;
defparam i_sbmac16_adder.B_REG = 1'b0 ;
defparam i_sbmac16_adder.A_REG = 1'b0 ;
defparam i_sbmac16_adder.C_REG = 1'b0 ;
defparam i_sbmac16_adder.NEG_TRIGGER = 1'b0;

endmodule