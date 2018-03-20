/******************************************************************* 
* Name:
*	Error.sv
* Description:
* 	This module turn the led of error
* Inputs:
*	clk,reset,Start
* Outputs:
* 	Shot
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	22/02/2018 
*********************************************************************/
module Error
#(
	parameter WORD_LENGTH = 16
) 
(
	// Input Ports
	input clk,
	input reset,
	input Start,
	input [1:0] Opcode,
	input [(WORD_LENGTH*2)-1:0] Data32,
	input [WORD_LENGTH-1:0] DataY,


	// Output Ports
	output error
);

enum logic [1:0] {MULTIPLIER, DIVISOR, SQUARE_ROOT, ERROR} state;

bit  error_b;

/*------------------------------------------------------------------------------------------*/
/*Asignacion de estado*/
always_ff@(posedge clk or negedge reset) begin

	if(reset == 1'b0)
		state <= state;
	else 
		if (Start == 1'b1) 
			case(Opcode)
			
				MULTIPLIER:
					if(Data32 > 32768)
						state <= ERROR;
					else
						state <= MULTIPLIER;	
					
				DIVISOR:
					if(DataY == 0)
						state <= ERROR;
					else
						state <= DIVISOR;
					
				SQUARE_ROOT:
					if(DataY[WORD_LENGTH-1] == 1'b1)
						state <= ERROR;
					else
						state <= SQUARE_ROOT;
						
				ERROR:	
					if(Start == 1'b0) 
						state <= ERROR;
					else 
						state <= state;
					
		endcase
		
end//end always

/*------------------------------------------------------------------------------------------*/
/*Salida de control, proceso combintorio*/
always_comb begin
	case(state)
		MULTIPLIER: 
				error_b = 1'b0;

		DIVISOR: 
				error_b = 1'b0;

		SQUARE_ROOT: 
				error_b = 1'b0;
				
		ERROR: 
				error_b = 1'b1;
				
	default: 		
				error_b = 1'b0;
				
	endcase
end

assign error = error_b;

endmodule 