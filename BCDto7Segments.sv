/******************************************************************* 
* Name:
*	BCDto7Segments.sv
* Description:
* 	This module assign the segments of the transistors
* Inputs:
*	in
* Outputs:
* 	segments
* Versión:  
*	1.0
* Author: 
*	Felipe Garcia & Diego Reyna
* Fecha: 
*	10/02/2018 
*********************************************************************/
module BCDto7Segments(
    input [3:0] in,
    output [6:0] segments // segments[6]-> a, segments[0]->g
    );
	 
	 assign segments =
		(in==0)? 'b1000000: // abcdefg
		(in==1)? 'b1111001:
		(in==2)? 'b0100100:
		(in==3)? 'b0110000:
		(in==4)? 'b0011001:
		(in==5)? 'b0010010:
		(in==6)? 'b0000010:
		(in==7)? 'b1111000:
		(in==8)? 'b0000000:
		(in==9)? 'b0011000:
  					'b0000000;
endmodule
