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

enum logic [2:0] {IDLE, START1, START0, LOAD_CH1, CH1_LOADED, LOAD_CH2, CH2_LOADED} state; 

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
				state <= START1;
			else
				state <= IDLE;	
				
		START1:
			if(Start == 0)
				state <= START0;
			else
				state <= START1;
	
		START0:
			if(Load)
				state <= LOAD_CH1;
			else
				state <= START0;
					
		LOAD_CH1:
			if(Load == 0)
				state <= CH1_LOADED;
			else
				state <= LOAD_CH1;

		CH1_LOADED:
			if(Load)
				state <= LOAD_CH2;
			else
				state <= CH1_LOADED;
		
		LOAD_CH2:
			if(Load == 0)
				state <= CH2_LOADED;
			else
				state <= LOAD_CH2;
	
		CH2_LOADED:
			if(Ready)
				state <= IDLE;
			else
				state <= CH2_LOADED;
				
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
		START1: 
			begin
				load1_b = 1'b0;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end	
		START0: 
			begin
				load1_b = 1'b1;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end	
		LOAD_CH1: 
			begin
				load1_b = 1'b0;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b1;
				enable2_b = 1'b0;
			end
		CH1_LOADED: 
			begin
				load1_b = 1'b0;
				load2_b = 1'b1;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end
		LOAD_CH2:
			begin
				load1_b = 1'b0;
				load2_b = 1'b0;
				start_b = 1'b0;
				enable1_b = 1'b0;
				enable2_b = 1'b0;
			end
			
		CH2_LOADED:
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