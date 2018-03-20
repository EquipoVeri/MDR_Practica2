module CounterWithFunction_SQR
#(
	// Parameter Declarations
	parameter MAXIMUM_VALUE = 9,
	parameter NBITS_FOR_COUNTER = CeilLog2(MAXIMUM_VALUE)
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	
	// Output Ports
	output flag0,
	output flag8,
	//output flag9,
	output [NBITS_FOR_COUNTER-1 : 0] count
);

bit MaxValue_Bit;
bit Zero_Bit;
//bit R_bit;

logic [NBITS_FOR_COUNTER-1 : 0] Count_logic;

always_ff@(posedge clk or negedge reset) begin
	if (reset == 1'b0)
		Count_logic <= 4'b1001;
	else begin
			if(enable == 1'b1)
				if(Count_logic == 0)
					Count_logic <= 4'b1001;
				else
					Count_logic <= Count_logic - 1'b1;
	end
end

//--------------------------------------------------------------------------------------------

always_comb begin
	if(Count_logic == MAXIMUM_VALUE-1)
		Zero_Bit = 1;
	else
		Zero_Bit = 0;
	if(Count_logic == 0)
		MaxValue_Bit = 1; 
	else
		MaxValue_Bit = 0;
//	if(Count_logic == MAXIMUM_VALUE)
//		R_bit = 1;
//	else
//		R_bit = 0;
end
		
//---------------------------------------------------------------------------------------------
assign flag8 = MaxValue_Bit;
//assign flag9 = R_bit;
assign flag0 = Zero_Bit;
assign count = Count_logic;
//----------------------------------------------------------------------------------------------

/*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
   
 /*Log Function*/
     function integer CeilLog2;
       input integer data;
       integer i,result;
       begin
          for(i=0; 2**i <= data; i=i+1)
             result = i + 1;
          CeilLog2 = result;
       end
    endfunction

/*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
endmodule
