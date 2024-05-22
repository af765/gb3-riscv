/*
	Authored 2018-2019, Ryan Voo.

	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:

	*	Redistributions of source code must retain the above
		copyright notice, this list of conditions and the following
		disclaimer.

	*	Redistributions in binary form must reproduce the above
		copyright notice, this list of conditions and the following
		disclaimer in the documentation and/or other materials
		provided with the distribution.

	*	Neither the name of the author nor the names of its
		contributors may be used to endorse or promote products
		derived from this software without specific prior written
		permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/



/*
 *	Description:
 *
 *		This module implements an adder for use by the branch unit
 *		and program counter increment among other things.
 */


/*
module adder(input1, input2, out);
	input [31:0]	input1;
	input [31:0]	input2;
	output [31:0]	out;

	assign		out = input1 + input2;
endmodule
*/
module adder_1_bit(input1, input2, cin, out, cout);
	input input1;
	input input2;
	input cin;
	output out;
	output cout;

	assign out = input1 ^ input2 ^ cin;
	assign cout = (input1 && input2) || (input1 && cin) || (input2 && cin);
endmodule

module adder_8_bit(input1, input2, cin, out, cout);
	input [7:0] input1;
	input [7:0] input2;
	input cin;
	output [7:0] out;
	output cout;

	wire c1, c2, c3, c4, c5, c6, c7;

	adder_1_bit a0 (input1[0], input2[0], cin, out[0], c1);
	adder_1_bit a1 (input1[1], input2[1], c1, out[1], c2);
	adder_1_bit a2 (input1[2], input2[2], c2, out[2], c3);
	adder_1_bit a3 (input1[3], input2[3], c3, out[3], c4);
	adder_1_bit a4 (input1[4], input2[4], c4, out[4], c5);
	adder_1_bit a5 (input1[5], input2[5], c5, out[5], c6);
	adder_1_bit a6 (input1[6], input2[6], c6, out[6], c7);
	adder_1_bit a7 (input1[7], input2[7], c7, out[7], cout);
endmodule

module adder(input1, input2, out);
	input [31:0] input1;
	input [31:0] input2;
	output [31:0] out;

	wire[4:0] C;
	wire [3:0] G, P;

	assign G = input1 & input2; //bitwise and

	assign P = input1 | input2; //bitwise or

	assign C[0] = 1'b0;
	assign C[1] = G[0] | (P[0] & C[0]); 
	assign C[2] = G[1] | (P[1] & C[1]); 
	assign C[3] = G[2] | (P[2] & C[2]); 
	//assign C[4] = G[3] | (P[3] & C[3]); Carry out is ignored as in orginal adder

	adder_8_bit a0 (input1[7:0], input2[7:0], C[0], out[7:0]);
	adder_8_bit a1 (input1[15:8], input2[15:8], C[1], out[15:8]);
	adder_8_bit a2 (input1[23:16], input2[23:16], C[2], out[23:16]);
	adder_8_bit a3 (input1[31:24], input2[31:24], C[3], out[31:24]);
endmodule