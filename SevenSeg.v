	
	
/*
 * 
 * ---------------------
 * Autor: Beyza AYVACIKLI
 
 * Date: 14.03.2022
 *
 * Seven Segment written code. 
 * It designed with logical gates. 
 * Firstly Mantisa detected for decided the logical gates.
 * ------------
 
 *
 */
	
	module SevenSeg( 
	
	////pull-down light the sevenseg.
	
	 input [4:0] out1,
	 output [6:0] segment );

assign segment[0]=(~out1[3]&~out1[2]&~out1[1]&out1[0])|| (out1[2]&~out1[1]&~out1[0]);
assign segment[1]=(out1[2]&~out1[1]&out1[0])||(out1[2]&out1[1]&~out1[0]);
assign segment[2]=(~out1[2]&out1[1]&~out1[0]);
assign segment[3]=(~out1[3]&~out1[2]&~out1[1]&out1[0])|| (out1[2]&~out1[1]&~out1[0])||(out1[2]&out1[1]&out1[0]);
assign segment[4]=(out1[0])||(out1[2]&~out1[1]);
assign segment[5]=(~out1[3]&~out1[2]&out1[0])||(~out1[2]&out1[1])||(out1[1]&out1[0]);
assign segment[6]=(~out1[3]&~out1[2]&~out1[1])||(out1[2]&out1[1]&out1[0]);

	endmodule
	