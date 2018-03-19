module MooreStateMachine_load
(
	// Input Ports
	input clk,
	input reset,
	input Start,
	input Load,
	input Ready,

	// Output Ports
	output Load_ch1,
	output Load_ch2,
	output Enable1,
	output Enable2,
	output flagStart
);

enum logic [2:0] {IDLE,LOAD_CH1,LOAD_CH2,FINISH} state; 

bit load1_b; /* This is the bit of the led 1*/
bit load2_b; /* This is the bit of the led 2*/
bit enable1_b; /* This is the bit to charge the channel 1*/
bit enable2_b; /* This is the bit to charge the channel 2*/
bit start_b; /* This is the bit to start the MDR */

/*------------------------------------------------------------------------------------------*/
/*Asignacion de estado, proceso secuencial*/
always_ff@(posedge clk, negedge reset) begin

	if(reset == 1'b0)
			state <= IDLE;
	else 
	case(state)
		
		IDLE:
			if(Start)
				state <= LOAD_CH1;
			else
				state <= IDLE;	
				
		LOAD_CH1:
			if(Load)
				state <= LOAD_CH2;
			else
				state <= LOAD_CH1;
				
		LOAD_CH2:
			if(Load)
				state <= FINISH;
			else
				state <= LOAD_CH2;	
				
		FINISH:
			if(Ready)
				state <= IDLE;
			else
				state <= FINISH;	
				
		default:
				state <= IDLE;

		endcase
end//end always

/*------------------------------------------------------------------------------------------*/
/*Asignación de salidas,proceso combintorio*/
always_comb begin
	 case(state)
		IDLE: 
			begin
				load1_b = 1'b0;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end	
		LOAD_CH1: 
			begin
				load1_b = 1'b1;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end
		LOAD_CH2:
			begin
				load1_b = 1'b0;
				load2_b = 1'b1;
				start_b = 1'b0;
				enable1_b = 1'b1;
				enable2_b = 1'b0;
			end
		FINISH:
			begin
				load1_b = 1'b0;
				load2_b = 1'b0;
				start_b = 1'b1;
				enable1_b = 1'b0;
				enable2_b = 1'b1;
			end
			
		default: 		
			begin
				load1_b = 1'b0;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end

	endcase
end//end always

// Asingnación de salidas

assign Load_ch1 = load1_b;
assign Load_ch2 = load2_b;
assign Enable1 = enable1_b;
assign Enable2 = enable2_b;
assign flagStart = start_b;


endmodule 