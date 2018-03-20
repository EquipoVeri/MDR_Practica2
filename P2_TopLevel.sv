/******************************************************************* 
* Name:
*	P2.sv
* Description:
* 	This module is the top level of the project
* Inputs:
* Outputs:
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	19/03/2018 
*********************************************************************/
module P2_TopLevel
#(
	parameter WORD_LENGTH = 16
)
(
	input clk,
	input reset,
	input Start,
	input [WORD_LENGTH-1:0] Data,
	input Load,
	input [1:0] Op,
	output LoadX,
	output LoadY,
	output Sign,
	output Ready,
	
	//output Error,
	/* Result*/
	output [6:0] units,
	output [6:0] hundreds,
	output [6:0] tens,
	output [6:0] onethousand,
	output [6:0] tenthousands,
	output [WORD_LENGTH-1:0] Remainder
);

bit Sign_b, LoadX_b, LoadY_b, Ready_b;
wire [WORD_LENGTH-1:0] Result_w;
wire [WORD_LENGTH-1:0] Remainder_w;

assign Remainder = Remainder_w;
assign Sign = ~Sign_b;
assign LoadX = LoadX_b;
assign LoadY = LoadY_b;
assign Ready = Ready_b;

P2
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
P2_module
(
	.clk(clk),
	.reset(reset),
	.data(Data),
	.op(Op),
	.load(~Load),
	.start(Start),
	.loadX(LoadX_b),
	.loadY(LoadY_b),
	.ready(Ready_b),
	.result(Result_w),
	.remainder(Remainder_w),
	.sign(Sign_b)
);

DecoderBinarytoBCD decoder
(
	.binary_input(Result_w),
	.units(units),
	.hundreds(hundreds),
	.tens(tens),
	.onethousand(onethousand),
	.tenthousands(tenthousands)
);

endmodule 