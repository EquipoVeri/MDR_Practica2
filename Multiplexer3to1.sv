module Multiplexer3to1
#(
	parameter NBits=16
)
(
	input [1:0] Selector,
	input [NBits-1:0] MUX_DataMult,
	input [NBits-1:0] MUX_DataDiv,
	input [NBits-1:0] MUX_DataSQR,

	output reg [NBits-1:0] MUX_Output
);

	always@(*) begin
		case(Selector)
			2'b00: MUX_Output = MUX_DataMult;
			2'b01: MUX_Output = MUX_DataDiv;
			2'b10: MUX_Output = MUX_DataSQR;
			default: MUX_Output = {NBits{1'b0}};
		endcase
		
	/*always@(Selector,MUX_Data3,MUX_Data2,MUX_Data1,MUX_Data0) begin
		if(Selector)
			MUX_Output = MUX_Data0;
		else
			MUX_Output = MUX_Data1;
	end	*/
		
	end

endmodule