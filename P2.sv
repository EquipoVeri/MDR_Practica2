module P2
#(
	parameter WORD_LENGTH = 16
)
(
	//input ports
	input clk,
	input reset,
	input [WORD_LENGTH-1:0] data,
	input [1:0] op,
	input load,
	input start,
	
	//output ports
	output loadX,
	output loadY,
	output ready,
	output error,
	output [WORD_LENGTH-1:0] result,
	output [WORD_LENGTH-1:0] remainder,
	output sign
);

bit error_bit;
bit ready_bit;
bit loadX_bit;
bit loadY_bit;
bit enable_bit;
bit enableReg_bit;
bit sign_bit;
bit flush_bit;
bit ready_out_bit;

wire [WORD_LENGTH-1:0] dataX_w;
wire [WORD_LENGTH-1:0] dataY_w;
wire [WORD_LENGTH-1:0] result_w;
wire [WORD_LENGTH-1:0] remainder_w;
wire [(WORD_LENGTH*2)-1:0] result32_w;

assign loadX = loadX_bit;
assign loadY = loadY_bit;
assign result = result_w;
assign remainder = remainder_w;
assign sign = sign_bit;
assign ready = ready_out_bit;
assign error = error_bit;

LoadData
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
load_data
(
	.clk(clk),
	.reset(reset),
	.Data(data),
	.Start(start),
	.Load(load),
	.Ready(ready_bit),
	.Load_x(loadX_bit),
	.Load_y(loadY_bit),
	.flagStart(enable_bit),
	.flagFlush(flush_bit),
	.ready_out(ready_out_bit),
	.DataX(dataX_w),
	.DataY(dataY_w)
);

MDR
#(
	.WORD_LENGTH(WORD_LENGTH)
)
MDR_module
(
	.clk(clk),
	.reset(reset),
	.dataX(dataX_w),
	.dataY(dataY_w),
	.op(op),
	.start(enable_bit),
	.flush(flush_bit),
	.ready(ready_bit),
	.result(result_w),
	.result32(result32_w),
	.remainder(remainder_w),
	.sign(sign_bit)
);

Error
#(
	.WORD_LENGTH(WORD_LENGTH)
) 
error_module
(
	.clk(clk),
	.reset(reset),
	.Start(enable_bit),
	.Opcode(op),
	.Data32(result32_w),
	.DataY(dataY_w),
	.error(error_bit)
);

endmodule 