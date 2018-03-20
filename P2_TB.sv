timeunit 10ps; //It specifies the time unit that all the delay will take in the simulation.
timeprecision 1ps;// It specifies the resolution in the simulation.

module P2_TB;

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

P2
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
	#20 start = 0;
	#0 op = 2'b10;
	#0 data = 2;
	#20 load = 1;
	#20 load = 0;
	#20 data = 40;
	#0 load = 1;	
	#20 load = 0;
	
	#100

	#0 start = 0;
	#1 start = 1;
	#20 start = 0;
	#0 op = 2'b10;
	#0 data = 300;
	#20 load = 1;
	#20 load = 0;
	#20 data = 100;
	#0 load = 1;	
	#20 load = 0;

	#100

	#0 start = 0;
	#1 start = 1;
	#20 start = 0;
	#0 op = 2'b10;
	#0 data = 2132;
	#20 load = 1;
	#20 load = 0;
	#20 data = 40;
	#0 load = 1;	
	#20 load = 0;

end

/*********************************************************/
endmodule 