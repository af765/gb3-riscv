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

module adder_1_bit(input1, input2, cin, out, cout);
	input input1;
	input input2;
	input cin;
	output out;
	output cout;

	assign {cout, out} = input1 + input2 + cin;
endmodule

module adder_4_bit(input1, input2, cin, out, cout, g, p);
	input [3:0] input1;
	input [3:0] input2;
	input cin;
	output [3:0] out;
	output cout;
 
	wire [4:0] c;
	output [3:0] g, p;

	assign g = input1 & input2; //bitwise and

	assign p = input1 | input2; //bitwise or

	assign c[0] = cin;
	assign c[1] = g[0] | (p[0] & cin); 
	assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin); 
	assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin); 
	assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin); 

	adder_1_bit a0 (input1[0], input2[0], c[0], out[0]);
	adder_1_bit a1 (input1[1], input2[1], c[1], out[1]);
	adder_1_bit a2 (input1[2], input2[2], c[2], out[2]);
	adder_1_bit a3 (input1[3], input2[3], c[3], out[3]);
	assign cout = c[4];
endmodule

module adder_16_bit(input1, input2, cin, out, cout);
	input [15:0] input1;
	input [15:0] input2;
	input cin;
	output [15:0] out;
	output cout;

	wire[4:0] C;
	wire [3:0] G, P;
	wire [15:0] g, p;

	assign G[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
	assign G[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
	assign G[2] = g[11] | (p[11] & g[10]) | (p[11] & p[10] & g[9]) | (p[11] & p[10] & p[9] & g[8]);
	assign G[3] = g[15] | (p[15] & g[14]) | (p[15] & p[14] & g[13]) | (p[15] & p[14] & p[13] & g[12]);

	assign P[0] = p[0] & p[1] & p[2] & p[3]; 
	assign P[1] = p[4] & p[5] & p[6] & p[7]; 
	assign P[2] = p[8] & p[9] & p[10] & p[11]; 
	assign P[3] = p[12] & p[13] & p[14] & p[15]; 

	assign C[0] = cin;
	assign C[1] = G[0] | (P[0] & cin); 
	assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin); 
	assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin); 
	assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin); 
	
	adder_4_bit a0 (.input1(input1[3:0]), .input2(input2[3:0]), .cin(C[0]), .out(out[3:0]), .g(g[3:0]), .p(p[3:0]));
	adder_4_bit a1 (.input1(input1[7:4]), .input2(input2[7:4]), .cin(C[1]), .out(out[7:4]), .g(g[7:4]), .p(p[7:4]));
	adder_4_bit a2 (.input1(input1[11:8]), .input2(input2[11:8]), .cin(C[2]), .out(out[11:8]), .g(g[11:8]), .p(p[11:8]));
	adder_4_bit a3 (.input1(input1[15:12]), .input2(input2[15:12]), .cin(C[3]), .out(out[15:12]), .g(g[15:12]), .p(p[15:12]));
	assign cout = C[4];
endmodule

module adder(input1, input2, out, cin);
	input [31:0] input1;
	input [31:0] input2;
	input cin;
	output [31:0] out;

	wire c1;

	adder_16_bit a0 (input1[15:0], input2[15:0], cin, out[15:0], c1);
	adder_16_bit a1 (input1[31:16], input2[31:16], c1, out[31:16]);
endmodule

module adder_1cla(input1, input2, out, cin);
	input [31:0] input1;
	input [31:0] input2;
	input cin;
	output [31:0] out;

	wire c1, c2, c3, c4, c5, c6, c7;

	adder_4_bit a0 (.input1(input1[3:0]), .input2(input2[3:0]), .cin(cin), .out(out[3:0]), .cout(c1));
	adder_4_bit a1 (.input1(input1[7:4]), .input2(input2[7:4]), .cin(c1), .out(out[7:4]), .cout(c2));
	adder_4_bit a2 (.input1(input1[11:8]), .input2(input2[11:8]), .cin(c2), .out(out[11:8]), .cout(c3));
	adder_4_bit a3 (.input1(input1[15:12]), .input2(input2[15:12]), .cin(c3), .out(out[15:12]), .cout(c4));
	adder_4_bit a4 (.input1(input1[19:16]), .input2(input2[19:16]), .cin(c4), .out(out[19:16]), .cout(c5));
	adder_4_bit a5 (.input1(input1[23:20]), .input2(input2[23:20]), .cin(c5), .out(out[23:20]), .cout(c6));
	adder_4_bit a6 (.input1(input1[27:24]), .input2(input2[27:24]), .cin(c6), .out(out[27:24]), .cout(c7));
	adder_4_bit a7 (.input1(input1[31:28]), .input2(input2[31:28]), .cin(c7), .out(out[31:28]));
endmodule