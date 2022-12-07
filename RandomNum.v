
/*
 * 
 * ---------------------
 
 * Date: 1.05.2022
 *
 *this module for create new random number
 *initial value, increment value and max value are importand
 * ------------
 
 *
 */

module RandomNum  #( 
	parameter NUM_WIDTH = 8, //8bit wide 
	parameter MAX_VALUECNT=4294967295,//Maximum value for counter
	parameter CNT_INCREMENT = 5, //Value to increment counter by each cycle 
	parameter MAX_VALUE = (2**NUM_WIDTH)-1 //Maximum value default is 2^WIDTH - 1 
 )( 
	input clock, 
	input reset,  
	input backValue, // The startin value can be different with this value(maybe it can be use for delay)
	output reg [31:0] countValue,
	output reg [(NUM_WIDTH-1):0] randomNumValue //countValue //Output is declared as "WIDTH" bits wide 
 ); 
 
 
	always @ (posedge clock) begin 	
		//Otherwise counter is not in reset 
		if (countValue >= MAX_VALUE[NUM_WIDTH-1:0]) begin 
			//If the counter value is equal or exceeds the maximum value 
			countValue <= {(NUM_WIDTH){backValue}};// 1'b0}}; 
		end else begin 
			//Otherwise increment 
			countValue <= countValue + CNT_INCREMENT[NUM_WIDTH-1:0]; 
			randomNumValue<=countValue % MAX_VALUE;// mod for generate less den max value
			if(randomNumValue<backValue)begin//random value shoudnt be less than backvalue
				randomNumValue<={(NUM_WIDTH){backValue}}+randomNumValue;
			end
		end  
	end
endmodule
