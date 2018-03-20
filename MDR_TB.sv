timeunit 10ps; //It specifies the time unit that all the delay will take in the simulation.
timeprecision 1ps;// It specifies the resolution in the simulation.

module MDR_TB;

parameter WORD_LENGTH = 16;

bit clk = 0;
bit reset;
bit start;
bit load;
logic [1:0] op;
logic [WORD_LENGTH-1:0] data;

bit loadX;
bit loadY;
bit ready;
logic [WORD_LENGTH-1:0] result;
logic [WORD_LENGTH-1:0] remainder;
bit sign;

MDR
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
DUV
(	
	.clk(clk),
	.reset(reset),
	.start(start),
	.load(load),
	.op(op),
	.data(data),
	.loadX(loadX),
	.loadY(loadY),
	.ready(ready),
	.result(result),
	.remainder(remainder),
	.sign(sign)
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
	#0 start = 0;
	#1 start = 1;	

	#1 op = 0;
	#1 load = 1;
	#2 data = -60;
	#3 load = 0;
	#4 load = 1;
	#4 data = 40;

	#5 op = 1;
	#5 load = 1;
	#5 data = 10;
	#8 load = 0;
	#8 load = 1;
	#8 data = 40;
	
	#9 op = 2;
	#9 load = 1;
	#9 data = 50;
	#11 load = 0;
	#11 load = 1;
	#11 data = 4;
end

/*********************************************************/
endmodule 