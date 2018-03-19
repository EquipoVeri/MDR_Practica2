timeunit 10ps; //It specifies the time unit that all the delay will take in the simulation.
timeprecision 1ps;// It specifies the resolution in the simulation.

module Load_TB;

parameter WORD_LENGTH = 16;

bit clk = 0;
bit reset;
bit Start;
bit Load;
bit Ready;
bit Load_x;
bit Load_y;
bit flagStart;

logic [WORD_LENGTH-1:0] Data;
logic [WORD_LENGTH-1:0] DataX;
logic [WORD_LENGTH-1:0] DataY;

LoadData
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
DUV
(	
	.clk(clk),
	.reset(reset),
	.Data(Data),
	.Start(Start),
	.Load(Load),
	.Ready(Ready),
	.Load_x(Load_x),
	.Load_y(Load_y),
	.flagStart(flagStart),
	.DataX(DataX),
	.DataY(DataY)
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
	#1 Data = -60;
	#1 Load = 1;
	#2 Load = 0;
	#6 Load = 1;
	#2 Data = -2;
	#4 Data = 15;
	#10 Load = 0;

end

/*********************************************************/
endmodule 