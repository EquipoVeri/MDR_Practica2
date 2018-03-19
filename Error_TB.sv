timeunit 10ps; //It specifies the time unit that all the delay will take in the simulation.
timeprecision 1ps;// It specifies the resolution in the simulation.

module Error_TB;

parameter WORD_LENGTH = 16;

bit clk = 0;
bit reset;
bit Start;
bit Load;
bit Ready;
logic [1:0] Opcode;

logic [WORD_LENGTH-1:0] Data;

Error
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
DUV
(	
	.clk(clk),
	.reset(reset),
	.Start(Start),
	.LoadData(Load),
	.Ready(Ready),
	.Opcode(Opcode),
	.Data(Data),
	.error(error)
);


/*********************************************************/
initial // Clock generator
  begin
    forever #1 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#0 reset = 1;
end

/*********************************************************/

initial begin 
	#0 Start = 0;
	#1 Start = 1;
	#1 Ready = 1;	
	#1 Opcode = 2;
	#1 Load = 1;
	#2 Data = -60;
	#5 Opcode = 1;
	#7 Data = 80;
	#9 Opcode = 2;
	#11 Opcode = 0;
	#15 Data = 32770;
	#18 Opcode = 1;
	#19 Data = 0;
	#20 Opcode = 2;
	#21 Data = -1;

end

/*********************************************************/
endmodule 