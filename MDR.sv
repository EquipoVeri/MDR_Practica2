module MDR
#(
	parameter WORD_LENGTH = 16
)
(
	//input ports
	input clk,
	input reset,
	input [WORD_LENGTH-1:0] dataX,
	input [WORD_LENGTH-1:0] dataY,
	input [1:0] op,
	input start,
	input flush,
	
	//output ports
	output ready,
	output [WORD_LENGTH-1:0] result,
	output [WORD_LENGTH-1:0] remainder,
	output sign
);

bit sign_mult_bit;
bit sign_div_bit;
bit sign_out_bit;

bit sel_adder_mult_bit;
bit sel_adder_div_bit;
bit sel_adder_sqr_bit;
bit sel_adder_out_bit;

bit ready_mult_bit;
bit ready_div_bit;
bit ready_sqr_bit;
bit ready_out_bit;

wire [WORD_LENGTH-1:0] partial1_out_mult_w;
wire [(WORD_LENGTH*2)-1:0] partial1_out_div_w;
wire [WORD_LENGTH-1:0] partial1_out_sqr_w;

wire [WORD_LENGTH-1:0] partial2_out_mult_w;
wire [(WORD_LENGTH*2)-1:0] partial2_out_div_w;
wire [WORD_LENGTH-1:0] partial2_out_sqr_w;

wire [WORD_LENGTH-1:0] result_mult_w;
wire [WORD_LENGTH-1:0] result_div_w;
wire [WORD_LENGTH-1:0] result_sqr_w;
wire [WORD_LENGTH-1:0] result_out_w;

wire [WORD_LENGTH-1:0] remainder_div_w;
wire [WORD_LENGTH-1:0] remainder_sqr_w;
wire [WORD_LENGTH-1:0] remainder_out_w;

wire [(WORD_LENGTH*2)-1:0] adder1_w;
wire [(WORD_LENGTH*2)-1:0] adder2_w;
wire [(WORD_LENGTH*2)-1:0] adder_out_w;

assign result = result_out_w;
assign remainder = remainder_out_w;
assign ready = ready_out_bit;
assign sign = sign_out_bit;

SquareRoot
#(
	.WORD_LENGTH(WORD_LENGTH)
)
SQR 
(	
	.clk(clk),
	.reset(reset),
	.enable(start & ~op[0] & op[1]),
	.DataInput(dataX),
	.partial_in(adder_out_w[WORD_LENGTH-1:0]),
	.sel_adder(sel_adder_sqr_bit),
	.partial1_out(partial1_out_sqr_w),
	.partial2_out(partial2_out_sqr_w),
	.result(result_sqr_w),
	.residue(remainder_sqr_w),
	.ready(ready_sqr_bit)
);

Divider
#(
	.WORD_LENGTH(WORD_LENGTH)
)
div
(
	.clk(clk),
	.reset(reset),
	.enable(start & op[0] & ~op[1]),
	.dividend(dataX),
	.divisor(dataY),
	.partial_in(adder_out_w),
	.sel_adder(sel_adder_div_bit),
	.partial1_out(partial1_out_div_w),
	.partial2_out(partial2_out_div_w),
	.result(result_div_w),
	.remainder(remainder_div_w),
	.sign(sign_div_bit),
	.ready(ready_div_bit)
);

Multiplier
#(
	.WORD_LENGTH(WORD_LENGTH)
)
mult 
(	
	.clk(clk),
	.reset(reset),
	.enable(start& ~op[0] & ~op[1]),
	.flush(flush),
	.Multiplier(dataY),
	.Multiplicand(dataX),
	.partial_in(adder_out_w[WORD_LENGTH-1:0]),
	.sel_adder(sel_adder_mult_bit),
	.partial1_out(partial1_out_mult_w),
	.partial2_out(partial2_out_mult_w),
	.ready(ready_mult_bit),
	.sign(sign_mult_bit),
	.Result(result_mult_w)
);


Multiplexer3to1
#(
	.NBits(1)
)
mux_SelAdder
(
	.Selector(op),
	.MUX_DataMult(sel_adder_mult_bit),
	.MUX_DataDiv(sel_adder_div_bit),
	.MUX_DataSQR(sel_adder_sqr_bit),
	.MUX_Output(sel_adder_out_bit)
);


Multiplexer3to1
#(
	.NBits(WORD_LENGTH*2)
)
mux_Adder1
(
	.Selector(op),
	.MUX_DataMult({16'b0, partial1_out_mult_w}),
	.MUX_DataDiv(partial1_out_div_w),
	.MUX_DataSQR({16'b0, partial1_out_sqr_w}),
	.MUX_Output(adder1_w)
);

Multiplexer3to1
#(
	.NBits(WORD_LENGTH*2)
)
mux_Adder2
(
	.Selector(op),
	.MUX_DataMult({16'b0, partial2_out_mult_w}),
	.MUX_DataDiv(partial2_out_div_w),
	.MUX_DataSQR({16'b0, partial2_out_sqr_w}),
	.MUX_Output(adder2_w)
);

Adder
#(
	.WORD_LENGTH(WORD_LENGTH*2)
)
adder
(
	.selector(sel_adder_out_bit),
	.Data1(adder1_w),
	.Data2(adder2_w),
	.result(adder_out_w)
);

Multiplexer3to1
#(
	.NBits(1)
)
mux_ready
(
	.Selector(op),
	.MUX_DataMult(ready_mult_bit),
	.MUX_DataDiv(ready_div_bit),
	.MUX_DataSQR(ready_sqr_bit),
	.MUX_Output(ready_out_bit)
);

Multiplexer3to1
#(
	.NBits(1)
)
mux_sign
(
	.Selector(op),
	.MUX_DataMult(sign_mult_bit),
	.MUX_DataDiv(sign_div_bit),
	.MUX_DataSQR(1'b0),
	.MUX_Output(sign_out_bit)
);

Multiplexer3to1
#(
	.NBits(WORD_LENGTH)
)
mux_result
(
	.Selector(op),
	.MUX_DataMult(result_mult_w),
	.MUX_DataDiv(result_div_w),
	.MUX_DataSQR(result_sqr_w),
	.MUX_Output(result_out_w)
);


Multiplexer3to1
#(
	.NBits(WORD_LENGTH)
)
mux_remainder
(
	.Selector(op),
	.MUX_DataMult({WORD_LENGTH{1'b0}}),
	.MUX_DataDiv(remainder_div_w),
	.MUX_DataSQR(remainder_sqr_w),
	.MUX_Output(remainder_out_w)
);


endmodule
