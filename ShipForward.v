/*
 * 
 * ---------------------
 * Date: 16.04.2022
 *
 * Description
 * ------------
 * This code was written for this game, but it can be use as a clock divider
 * It's simply a code block written about using a slower clock by dividing 50MHz.
 *       Actually, UpCounterNbit could have been used for this, but at this point some adjustments were made to see 
 *       if the game had passed the starting point.
 *
 */
 

 module ShipForward(
 
	input clock,
	input reset,
	//
	input state,
	input firstTimeStart,
	output reg forwardTrue
 );
	
	// this value weight can be 20'b->but when writing the code, it was written to 50MHz, so it was 26'b to be replaceable.
	parameter oneSecond =26'b00000011110100001001000000; //50000000/50= 1000000 (11110100001001000000)
	reg [25:0] cnt;
	
	 always@(posedge clock)begin
	 
		// if the game start state the counter shoudednt be start
		if(reset||(firstTimeStart==2'b00))begin
			cnt<=0;
			forwardTrue<=0;//=> value for making squar wave
		end else begin
			if(cnt==oneSecond)begin
				forwardTrue<=1;//=> value for making squar wave
				cnt<=0;
			end else begin
				cnt<=cnt+1;
				forwardTrue<=0;//=> value for making squar wave
			end
		end
	
	 end

 endmodule

