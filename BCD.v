
/*
 * 
 * ---------------------
 * Autor: Beyza AYVACIKLI
 
 * Date: 14.03.2022
 *
 * Binary 8 bit value can be converted to Decimal vulue, as hunderds, tens, ones values. 
 * This code is written for 7-segment display using for demical number.
 *  Treshold for this code is FF.
 * ------------
 
 *
 */

module BCD(



	input [7:0] binary ,
	output reg [3:0] hundreds,
	output reg [3:0] tens,
	output reg [3:0] ones,
	input clock
	
	);
 integer i;
 
 always @(binary)
 begin
	
	hundreds=4'd0;
	tens=4'd0;
	ones=4'd0;
	
	
	for(i=7;i>=0;i=i-1)
	
	begin 
	
	if(hundreds>=5)
	   hundreds=hundreds+3;
	
	if(tens>=5)
	   tens=tens+3;
	
	if(ones>=5)
	   ones=ones+3;
	
	
	hundreds=hundreds << 1;
	hundreds[0]=tens[3];
	tens=tens << 1;
	tens[0]=ones[3];
	ones=ones <<1;
	ones[0]=binary[i];
	
	end
	
	end
	endmodule
	