/******************************************************************* 
* Name:
*	LoadData.sv
* Description:
* 	This module realize the load of the registers and turn 
* Inputs:
*	clk,reset,Start,Data,Load,Ready
* Outputs:
* 	Load_x,Load_y,flagStart,DataX,DataY
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	18/03/2018 
*********************************************************************/
module LoadData
#(
	parameter WORD_LENGTH = 16
) 
(
	// Input Ports
	input clk,
	input reset,
	input [WORD_LENGTH-1:0] Data,
	input Start,
	input Load,
	input Ready,

	// Output Ports
	output Load_x,
	output Load_y,
	output flagStart,
	output [WORD_LENGTH-1:0] DataX,
	output [WORD_LENGTH-1:0] DataY
);

//bit ready_flag;
bit LoadX_b;
bit LoadY_b;
bit enableX_flag; /* This is the bit to charge the channel 1*/
bit enableY_flag; /* This is the bit to charge the channel 2*/
bit start_flag; /* This is the bit to start the MDR */

wire [WORD_LENGTH-1:0] DataX_w;
wire [WORD_LENGTH-1:0] DataY_w;

MooreStateMachine_load Load_SM
(
	.clk(clk),
	.reset(reset),
	.Start(Start),
	.Load(Load),
	.Ready(Ready),
	.Load_ch1(LoadX_b),
	.Load_ch2(LoadY_b),
	.Enable1(enableX_flag),
	.Enable2(enableY_flag),
	.flagStart(start_flag)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)
X_reg
(
	.clk(clk),
	.reset(reset),
	.enable(enableX_flag),
	.Data_Input(Data),
	.Data_Output(DataX_w)
);

Register
#(
	.Word_Length(WORD_LENGTH)
)
Y_reg
(
	.clk(clk),
	.reset(reset),
	.enable(enableY_flag),
	.Data_Input(Data),
	.Data_Output(DataY_w)
);

assign Load_x = LoadX_b;
assign Load_y = LoadY_b;
assign flagStart = start_flag;
assign DataX = DataX_w;
assign DataY = DataY_w;

endmodule 