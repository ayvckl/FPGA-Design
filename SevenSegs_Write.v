	
	/*
 * 
 * ---------------------
 * Date: 14.04.2022
 *
 * Seven Segment written code. 
 * It designed for only the space game.
 * It includes the one sub-module, 
 *       which basiclly general using design and was designed with logical gates.   
 * It is for write life for gamer on the Seven Segment
 * ------------
 
 *
 */

 module SevenSegs_Write(
	
	//the input, which showing how much playing life the player has left 
	input  [3:0] life,
	// They are for the seven segment
	output [6:0] lifeSeg0,
	output [6:0] lifeSeg1,
	output [6:0] lifeSeg2,
	output [6:0] lifeSeg3,
	output [6:0] lifeSeg4,
	output [6:0] lifeSeg5

 );
 
	// According to DE1-SoC_User_manual
	// 'L' value for seven segment
	reg [6:0] letter_L = 7'b0111000; 
	// 'I' value for seven segment
	reg [6:0] letter_I = 7'b0110000; 
	// 'F' value for seven segment
	reg [6:0] letter_F = 7'b1110001;
	// 'E' value for seven segment
	reg [6:0] letter_E = 7'b1111001; 
	// '_' value for seven segment
	reg [6:0] tire = 7'b0001000; 

	//If we use the BCD MOdule we should use next wire values.
	//wire hundreds_level,tens_level, ones_level, hundreds_life,tens_life, ones_life;
	 	 
	assign lifeSeg5=~letter_L;
	assign lifeSeg4=~letter_I;	
	assign lifeSeg3=~letter_F;
	assign lifeSeg2=~letter_E;
	assign lifeSeg1=~tire;
	
	//BCD BCD_life(life,hundreds_life,tens_life, ones_life);
	//Normally BDC converter should be used firstly; 
	//however, life weight is 4 bit since it can be input directly for SevenSeg Module.
	SevenSeg seg_life(life,lifeSeg0);
	
 endmodule
	
