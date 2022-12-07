


 module SpaceGame ( 
	// Clock 
	input 				clock, 
	// GlobalReset 
	input 				globalReset,
	// - Application Reset - for debug 
	output 				resetApp,
	
	input 				forwardButton,
	input 				leftButton,  
	input 				rightButton,
	// LT24 Interface 
	output 				LT24Wr_n, 
	output 				LT24Rd_n, 
	output 				LT24CS_n, 
	output 				LT24RS, 
	output 				LT24Reset_n, 
	output [15:0] 		LT24Data, 
	output 				LT24LCDOn, 
	// Seven Segment Outputs
	output [6:0] 		lifeSeg0, 
	output [6:0] 		lifeSeg1, 
	output [6:0] 		lifeSeg2, 
	output [6:0] 		lifeSeg3, 
	output [6:0] 		lifeSeg4, 
	output [6:0] 		lifeSeg5 
 );
	
	
	wire [8:0] randomx;
	wire [8:0] countValuex;
	//Random Number Generator for fire ball first x coordination location 
	RandomNum  #( 
		.NUM_WIDTH 			(9), //10bit wide 
		.CNT_INCREMENT 	(5), //Value to increment counter by each cycle 
		.MAX_VALUECNT		(4294967295),
		.MAX_VALUE 			(230) //Maximum value default is 2^WIDTH - 1 
	)RandomNumx( 
		.clock 				(clock ), 
		.reset 				(resetApp ),
		/*UpCounterNbit additional part-> starting point */
		.backValue 			(1'b0), 
		.countValue			(countValuex),
		.randomNumValue	(randomx)
	); 
  	wire [8:0] randomy;
	wire [8:0] countValuey;
	//Random Number Generator for fire ball first x coordination location 
	RandomNum  #( 
		.NUM_WIDTH 			(9), //10bit wide 
		.CNT_INCREMENT 	(5), //Value to increment counter by each cycle 
		.MAX_VALUECNT		(4294967295),
		.MAX_VALUE 			(290) //Maximum value default is 2^WIDTH - 1 
	)RandomNumY( 
		.clock 				(clock ), 
		.reset 				(resetApp ),
		/*UpCounterNbit additional part-> starting point */
		.backValue 			(winBorder_Level), 
		.countValue			(countValuey),
		.randomNumValue	(randomy)
	); 
		wire [8:0] random2x;
	wire [8:0] countValue2x;
	//Random Number Generator for fire ball first x coordination location 
	RandomNum  #( 
		.NUM_WIDTH 			(9), //10bit wide 
		.CNT_INCREMENT 	(5), //Value to increment counter by each cycle 
		.MAX_VALUECNT		(4294967295),
		.MAX_VALUE 			(230) //Maximum value default is 2^WIDTH - 1 
	)RandomNum2x( 
		.clock 				(clock ), 
		.reset 				(resetApp ),
		/*UpCounterNbit additional part-> starting point */
		.backValue 			(1'b0), 
		.countValue			(countValue2x),
		.randomNumValue	(random2x)
	); 
  	wire [8:0] random2y;
	wire [8:0] countValue2y;
	//Random Number Generator for fire ball first x coordination location 
	RandomNum  #( 
		.NUM_WIDTH 			(9), //10bit wide 
		.CNT_INCREMENT 	(5), //Value to increment counter by each cycle 
		.MAX_VALUECNT		(4294967295),
		.MAX_VALUE 			(290) //Maximum value default is 2^WIDTH - 1 
	)RandomNum2y( 
		.clock 				(clock ), 
		.reset 				(resetApp ),
		/*UpCounterNbit additional part-> starting point */
		.backValue 			(winBorder_Level), 
		.countValue			(countValue2y),
		.randomNumValue	(random2y)
	); 
	
	
	// LCD Display
	// the variables and some standart values for LT24
	// This part was written same with 5666lecture lab Documents
	localparam 	LCD_WIDTH = 240; 
	localparam 	LCD_HEIGHT = 320;
	
	reg [ 7:0] 	xAddr; 
	reg [ 8:0] 	yAddr; 
	reg [15:0] 	pixelData;
	reg 			pixelWrite;
	reg 			globalResetPressed; 
   
	wire 			pixelReady; 
	
	// LCD Display calling
	LT24Display #( 
		.WIDTH 				(LCD_WIDTH ), 
		.HEIGHT 				(LCD_HEIGHT ), 
		.CLOCK_FREQ 		(50000000 ) 
	) Display ( 
      //Clock and Reset In
		.clock 				(clock ), 
		.globalReset 		(globalResetPressed),
		//Reset for User Logic		
		.resetApp 			(resetApp ),
	    //Pixel Interface	
		.xAddr 				(xAddr ), 
		.yAddr 				(yAddr ), 
		.pixelData 			(pixelData ), 
		.pixelWrite 		(pixelWrite ), 
		.pixelReady 		(pixelReady ),
	    //Use pixel addressing mode
		.pixelRawMode		(1'b0 ), 
		 //Unused Command Interface
		.cmdData 			(8'b0 ), 
		.cmdWrite 			(1'b0 ), 
		.cmdDone 			(1'b0 ), 
		.cmdReady 			( ), 
		//Display Connections		
		.LT24Wr_n 			(LT24Wr_n ), 
		.LT24Rd_n 			(LT24Rd_n ), 
		.LT24CS_n 			(LT24CS_n ), 
		.LT24RS 				(LT24RS ), 
		.LT24Reset_n 		(LT24Reset_n), 
		.LT24Data 			(LT24Data ), 
		.LT24LCDOn 			(LT24LCDOn ) 
	);

	// LCD Display pixelCount with UpCounterNbit
	wire [16:0] pixelCount; 
	UpCounterNbit #( 
		.WIDTH 				(17), 
		.MAX_VALUE			(76799)// 240x320 LCD Display pixel value
	) pixelCounter (
		.clock 				(clock ), 
		.reset 				(resetApp ), 
		.enable 				(pixelReady), 
		/*UpCounterNbit additional part-> starting point */
		.backValue 			(1'b0), 
		.countValue			(pixelCount)
	); 
	 
	// // Y Counter // 
	wire [8:0] yCount; 
	// y cound depend to pixelReady counter
			// this meaning, the code count firs Y, 
			//and than x counter is increased
	// wire yCntEnable = pixelReady && (xCount == (LCD_WIDTH-1)); 
	UpCounterNbit #( 
		.WIDTH 				( 9), 
		.MAX_VALUE			(LCD_HEIGHT-1)
	) yCounter ( 
		.clock 				(clock ), 
		.reset 				(resetApp ), 
		.enable 				(pixelReady), 
		.backValue			 (1'b0),
		.countValue			(yCount ) 
	); 
	// // X Counter // 
	//the code count firs Y, 
			//and than x counter is increased
	wire [7:0] xCount;
	wire xCntEnable = pixelReady && (yCount == (LCD_HEIGHT-1)); 
	UpCounterNbit #( 
		.WIDTH 				( 8), 
		.MAX_VALUE			(LCD_WIDTH-1) 
	)xCounter ( 
		.clock 				(clock ),
		.reset 				(resetApp ),
		.enable 				(xCntEnable),
		.backValue 			(1'b0),
		.countValue			(xCount )
	); 
	// // Pixel Write //-> it was taken from the lab 
	always @ (posedge clock or posedge resetApp) begin 
		if (resetApp) begin 
			pixelWrite <= 1'b0; 
		end else begin 
			//In this example we always set write high, and use pixelReady to detect when 
			//to update the data.
			pixelWrite <= 1'b1; 
			//You could also control pixelWrite and pixelData in a State Machine. 
		end 
	end 
	
	  						  
	// Memory Initialisation Files using part for backgroun 240x320
	(* ram_init_file = "SpaceBackground.mif" *) 
	reg [15:0] SpaceBackground [0:76799]; 
	// Memory Initialisation Files using part for Start Picture 200x200
	(* ram_init_file = "SpaceGameStartSmall.mif" *) 
	reg [15:0] SpaceGameStart [0:39999]; 
	// Memory Initialisation Files using part for Win Picture 200x200
	(* ram_init_file = "spaceWinSmall.mif" *) 
	reg [15:0] spaceWin [0:39999]; 
	// Memory Initialisation Files using part for Game Over Picture 200x200
	(* ram_init_file = "GameOverSmall.mif" *) 
	reg [15:0] GameOver [0:39999]; 
  
	// Memory Initialisation Files using part for ship player picture 30x30
	(* ram_init_file = "ship.mif" *)
	reg [15:0] ship [0:899]; 	
	// Memory Initialisation Files using part for fire ball picture 10x10
	(* ram_init_file = "fire.mif" *) 
	reg [15:0] fire [0:99];  
	
	
	// The SevenSegs_Write module is called to print -> LIFE_life
	SevenSegs_Write(life,lifeSeg0,lifeSeg1,lifeSeg2,
							  lifeSeg3,lifeSeg4,lifeSeg5);
  
  //This part is the button capture part, 
			//there are 3 buttons to be used in the game.

  reg leftB_Pressed,leftButton_Q, // to move the figure to the left
		rightB_Pressed, rightButton_Q, //to move the figure to the right
		forwardB_Pressed, forwardButton_Q, //to start the game and 
													//to move the figure to the forward more fast
		globalReset_Q; 

	always@(posedge clock) begin 
		// left button capture ->KEY3
		leftButton_Q<=leftButton; 
		// right button capture ->KEY2
		rightButton_Q<=rightButton;
		// start or fast button capture ->KEY1
		forwardButton_Q<=forwardButton; 
		globalReset_Q<=globalReset; 
		if (globalReset && !globalReset_Q) begin 
			globalResetPressed <= 1; 
		end else begin 
			globalResetPressed <= 0; 
		end if (forwardButton && !forwardButton_Q) begin
			forwardB_Pressed <=1;
		end else begin
			forwardB_Pressed <=0;
		end if (leftButton && !leftButton_Q) begin 
			leftB_Pressed <= 1; 
		end else begin 
			leftB_Pressed <= 0; 
		end if (rightButton && !rightButton_Q) begin 
			rightB_Pressed = 1; 
		end else begin 
			rightB_Pressed = 0; 
		end 
	end 
  
	
	reg [3:0] winner;// this value for understanding to player win or not
	reg [3:0] life;// Initially, the player is given 3 lives
  				
	
	// Main State-Machine states variable
	reg [5:0] state; 
	localparam START_STATE = 4'b0001; 
	localparam FIREBALL_DEFAULTSTATE = 4'b0010; 
	localparam FIREBALL_RIGHTANDUP = 4'b0011;  
	localparam FIREBALL_LEFTANDUP = 4'b0100; 
	localparam FIREBALL_RIGHTANDDOWN = 4'b0101;  
	localparam FIREBALL_LEFTANDDOWN = 4'b0110; 
	localparam THEEND_STATE = 4'b1000; 
  
	// the location values for ship and two fire 
	integer spaceShipx;  
	integer spaceShipy;
	integer firex; 
	integer firey;
	integer fire2x; 
	integer fire2y;
  
	// The ship has a regular forward movement, 
			//which represents a slower clock than the 50MHz 
			//designed for this forward movement to occur.
	wire shiForward;
	reg firstTimeStart;// to understanding to start game and also forwart moving
  
	// the sizes of the ship and fire can be change with this value.
	localparam fireRange= 5;
	localparam ShipRange = 15;
	localparam winBorder_Level=60;
	
   //It's simply a code block written about using a slower clock by dividing 50MHz
	ShipForward(clock,resetApp,state,firstTimeStart,shiForward) ;
  
	always @ (posedge clock or posedge resetApp) begin 
		if (resetApp) begin 
			// initial values for game
			pixelData <= 16'b0; 
			xAddr <= 8'b0;      		yAddr <= 9'b0;   //pixelcounter
			firex <= randomx;       firey <= randomy;     //the fire ball initial location
			fire2x <= random2x;      fire2y <= random2y;    //the fire ball initial location
			winner<=2'b0;								
			spaceShipy<=310;    		spaceShipx<=120; //the ship initial location
			life <= 4'b0011; 							 //initial 3 lifes
			firstTimeStart<=2'b00;					 //This is actually a flag value 
																//to start its regular forward movement
		
		end else if (forwardB_Pressed==1) begin// to capture the forward button pressed
		//If forward button pressed the ship go to up by 10 pixel on y coordinate
			spaceShipy<=spaceShipy-10; 
		end else if (leftB_Pressed==1) begin// to capture the left button pressed  
		//If left button pressed the ship go to 10 pixel left on x coordinate
			spaceShipx <= spaceShipx-10; 
		end else if (rightB_Pressed==1) begin // to capture the right button pressed 
		//If right button pressed the ship go to 10 pixel right on x coordinate		
			spaceShipx <= spaceShipx+10;
		// if blocks so that the ship does not go out of LCD' x coordinates
		end else if (spaceShipx<10) begin 
			spaceShipx <= 15; 
		end else if (spaceShipx>230) begin 
			spaceShipx <= 225; 
		// If pixel counter ready this block shold start
		end else if (pixelReady) begin 
		
		//Background colour on LT24 screen 
		xAddr <= xCount; 
		yAddr <= yCount; 
		pixelData <= SpaceBackground[pixelCount]; 
		
		//Drawing the safe area line
		if ( (yCount > winBorder_Level) 
		  && (yCount < winBorder_Level+10)) begin 
			if ((spaceShipy-ShipRange > (winBorder_Level-40)) 
			  && (spaceShipy-ShipRange < winBorder_Level+10)) begin
				xAddr <= xCount; 
				yAddr <= yCount; 
				pixelData <= 16'h0000; 
			end else begin
				xAddr <= xCount; 
				yAddr <= yCount; 
				pixelData <= 16'h07FF; //Cyan color
		  end
		end 
		
		
		//Sending pixel of the ship
		if ((xCount >= (spaceShipx-ShipRange)) 
		 && (xCount <= (spaceShipx+ShipRange)) 
		 && (yCount >= (spaceShipy-ShipRange)) 
		 && (yCount <= (spaceShipy+ShipRange))) 
		 begin 
			xAddr <= xCount; 
			yAddr <= yCount; 
			pixelData <= ship[(((yCount-spaceShipy-ShipRange-4)*ShipRange*2)
									+spaceShipx+ShipRange-xCount-4)]; 
		end 
		
		//Sending pixel of fire 1
		if ((xCount > (firex-fireRange)) 
		 && (xCount < (firex+fireRange)) 
		 && (yCount < (firey+fireRange)) 
		 && (yCount > (firey-fireRange))) 
		 begin 
			xAddr <= xCount; 
			yAddr <= yCount; 
			pixelData <= fire[(((yCount-firey-fireRange-4)*fireRange*2)
									+firex+fireRange-xCount-4)];
		end 
		
		//Sending pixel of fire 1
		if ((xCount > (fire2x-fireRange)) 
		 && (xCount < (fire2x+fireRange)) 
		 && (yCount < (fire2y+fireRange)) 
		 && (yCount > (fire2y-fireRange))) 
		 begin 
			xAddr <= xCount; 
			yAddr <= yCount; 
			pixelData <= fire[(((yCount-firey-fireRange-4)*fireRange*2)
									+firex+fireRange-xCount-4)];
      end
		
		//The ship standart movement  
		if(shiForward) begin
			spaceShipy<=spaceShipy-5;
		end
		  
		case (state) 
			START_STATE: begin // begining state 
				xAddr <= xCount; 
				yAddr <= yCount; 
				if (~((yCount >= 60)
				  && (yCount <= 260)
				  && (xCount >= 20)
				  && (xCount <= 220))) begin 
					pixelData <= 16'h0000;
				end else begin
					pixelData <= SpaceGameStart[(((yCount-60)*200)+220-xCount)];
				end
			 
			end 
			FIREBALL_DEFAULTSTATE: begin //defoult state
				if (firstTimeStart==2'b00)begin // to see if you are the first to start the game
					firstTimeStart<=firstTimeStart+2'b01;end
				if ((xCount == (LCD_WIDTH-1)) && (yCount == (LCD_HEIGHT-1))) begin 
					firey <= firey + 1;      firex <= firex + 2; //movement of fire ball for 1 ball
					fire2y <= fire2y + 2;    fire2x <= fire2x + 3; // movement of fire ball
				end 
				//If one checks whether it exceeds the screen limits or not, 
				//the value is reassigned even if it crosses the border.
				if (((firex-fireRange) >= (spaceShipx-ShipRange)) 
				 && ((firex+fireRange) <= (spaceShipx+ShipRange)) 
			    && ((firey-fireRange) >= (spaceShipy-ShipRange)) 
			    && ((firey+fireRange) <= (spaceShipy+ShipRange))) 
			    begin 
					if ( life != 0) begin	//life checking				
						life <= life - 4'b0001;
						spaceShipy<=310;  spaceShipx<=120; 
					end
				end else if (((fire2x-fireRange) >= (spaceShipx-ShipRange)) 
				          && ((fire2x+fireRange) <= (spaceShipx+ShipRange))
				          && ((fire2y-fireRange) >= (spaceShipy-ShipRange)) 
				          && ((fire2y+fireRange) <= (spaceShipy+ShipRange))) 
				          begin 
								if ( life != 0) begin		//life checking			
									life <= life - 4'b0001;
									spaceShipy<=310;  spaceShipx<=120; 
								end 
				end
				if (spaceShipy+ShipRange < winBorder_Level) begin 
					winner <=1;
				end
			end 
			FIREBALL_RIGHTANDUP: begin 
				if ((xCount == (LCD_WIDTH-1)) && (yCount == (LCD_HEIGHT-1))) begin 
				// movement of fire ball
					firey <= firey-1;   firex <= firex + 2; 
					fire2y <= fire2y-2; fire2x <= fire2x + 3; 
				end 
				//If one checks whether it exceeds the screen limits or not, 
				//the value is reassigned even if it crosses the border.
				if (((firex-fireRange) >= (spaceShipx-ShipRange)) 
				 && ((firex+fireRange) <= (spaceShipx+ShipRange)) 
				 && ((firey-fireRange) >= (spaceShipy-ShipRange)) 
			    && ((firey+fireRange) <= (spaceShipy+ShipRange)))  
				 begin 
					if ( life != 0) begin		//life checking			
						life <= life - 4'b0001;//life checking
						spaceShipy<=310; spaceShipx<=120; 
					end
				end else if (((fire2x-fireRange) >= (spaceShipx-ShipRange)) 
				          && ((fire2x+fireRange) <= (spaceShipx+ShipRange)) 
						    && ((fire2y-fireRange) >= (spaceShipy-ShipRange)) 
				          && ((fire2y+fireRange) <= (spaceShipy+ShipRange)))  
				          begin
								if ( life != 0) begin	//life checking					
									life <= life - 4'b0001;
									spaceShipy<=310; spaceShipx<=120; 
								end 
				end										
				if (spaceShipy+ShipRange < winBorder_Level) begin
					winner <=1;
				end
			end 
			FIREBALL_LEFTANDUP: begin 
				if ((xCount == (LCD_WIDTH-1)) && (yCount == (LCD_HEIGHT-1))) begin 
				// movement of fire ball
					firey <= firey-1;   firex <= firex - 2;
					fire2y <= fire2y-2; fire2x <= fire2x - 3; 
				end 
				/If one checks whether it exceeds the screen limits or not, 
				//the value is reassigned even if it crosses the border.
				if (((firex-fireRange) >= (spaceShipx-ShipRange)) 
				  && ((firex+fireRange) <= (spaceShipx+ShipRange)) 
				  && ((firey-fireRange) >= (spaceShipy-ShipRange)) 
				  && ((firey+fireRange) <= (spaceShipy+ShipRange)))  
				  begin
					if ( life != 0) begin			//life checking			
					   life <= life - 4'b0001;
					   spaceShipy<=310;  spaceShipx<=120; 
				    end
				end else if (((fire2x-fireRange) >= (spaceShipx-ShipRange)) 
					&& ((fire2x+fireRange) <= (spaceShipx+ShipRange)) 
					&& ((fire2y-fireRange) >= (spaceShipy-ShipRange)) 
					&& ((fire2y+fireRange) <= (spaceShipy+ShipRange)))  
					begin
				     if ( life != 0) begin		//life checking for begening again
					    life <= life - 4'b0001;
					    spaceShipy<=310; spaceShipx<=120; 
				     end 
				end									
				if (spaceShipy+ShipRange < winBorder_Level) begin
				  winner <=1;
				end
			 end 
			 FIREBALL_RIGHTANDDOWN: begin  
				if ((xCount == (LCD_WIDTH-1)) && (yCount == (LCD_HEIGHT-1))) begin 
				// movement of fire ball
				  firey <= firey + 1;    firex <= firex + 2; 
				  fire2y <= fire2y + 2;  fire2x <= fire2x + 3; 				  
				end 
				//If one checks whether it exceeds the screen limits or not, 
				//the value is reassigned even if it crosses the border.				
				if (((firex-fireRange) >= (spaceShipx-ShipRange)) 
				  && ((firex+fireRange) <= (spaceShipx+ShipRange)) 
				  && ((firey-fireRange) >= (spaceShipy-ShipRange)) 
				  && ((firey+fireRange) <= (spaceShipy+ShipRange))) begin 
				    if ( life != 0) begin		//life checking for begening again			
					   life <= life - 4'b0001;
					   spaceShipy<=310;  spaceShipx<=120; 
				    end
				end else if (((fire2x-fireRange) >= (spaceShipx-ShipRange)) 
				  && ((fire2x+fireRange) <= (spaceShipx+ShipRange)) 
				  && ((fire2y-fireRange) >= (spaceShipy-ShipRange)) 
				  && ((fire2y+fireRange) <= (spaceShipy+ShipRange)))  
				  begin
				    if ( life != 0) begin		//life checking for begening again			
					   life <= life - 4'b0001;
					   spaceShipy<=310; spaceShipx<=120; 
				    end
			   end									
				if (spaceShipy+ShipRange < winBorder_Level) begin
				  winner <=1;
				end
			 end 
			 FIREBALL_LEFTANDDOWN: begin  
			 // movement of fire ball
				if ((xCount == (LCD_WIDTH-1)) && (yCount == (LCD_HEIGHT-1))) begin  
				  firey <= firey + 1;    firex <= firex - 2;
				  fire2y <= fire2y + 2;  fire2x <= fire2x - 3; 				  
				end 
				//If one checks whether it exceeds the screen limits or not, 
				//the value is reassigned even if it crosses the border.				
				if (((firex-fireRange) >= (spaceShipx-ShipRange)) 
				  && ((firex+fireRange) <= (spaceShipx+ShipRange))
				  && ((firey-fireRange) >= (spaceShipy-ShipRange)) 
				  && ((firey+fireRange) <= (spaceShipy+ShipRange))) 
				  begin 
				    if ( life != 0) begin		//life checking for begening again			
					   life <= life - 4'b0001;
					   spaceShipy<=310;  spaceShipx<=120; 
				    end
				end else if (((fire2x-fireRange) >= (spaceShipx-ShipRange)) 
				  && ((fire2x+fireRange) <= (spaceShipx+ShipRange)) 
				  && ((fire2y-fireRange) >= (spaceShipy-ShipRange)) 
				  && ((fire2y+fireRange) <= (spaceShipy+ShipRange)))  
				  begin
				    if ( life != 0) begin		//life checking for begening again			
					   life <= life - 4'b0001;
					   spaceShipy<=310;  spaceShipx<=120; 
				    end
				end		
				if (spaceShipy+ShipRange < winBorder_Level) begin
				  winner <=1;
				end
			 end 
			 THEEND_STATE: begin 
	
			  if ( life == 0) begin //life checking winner or game over
			  		  firstTimeStart<=2'b00;
				 xAddr <= xCount; 
				 yAddr <= yCount; 	
			  if (~((yCount >= 60)
				  && (yCount <= 260)
				  && (xCount >= 20)
				  && (xCount <= 220))) begin 
					  pixelData <= 16'b0000000000000000;
					end else begin
					  pixelData <=  GameOver[(((yCount-60)*200)+220-xCount)];
					end
				end  
				if ( winner == 1) begin 
						  firstTimeStart<=2'b00;
				xAddr <= xCount; 
				yAddr <= yCount; 
				  if (~((yCount >= 60)
				  && (yCount <= 260)
				  && (xCount >= 20)
				  && (xCount <= 220))) begin 
					  pixelData <= 16'b0000000000000000;
					end else begin
					  pixelData <= spaceWin[(((yCount-60)*200)+220-xCount)];
					end
				end
			 end 
		 endcase 
	end 
  end 
	
	// State machine Conditions==>W values
  always @(posedge clock or posedge resetApp) begin 
    if (resetApp) begin 
  	   state <= START_STATE; 
    end else begin 
	   case (state) 
	     START_STATE: begin 
		    if (forwardB_Pressed) begin 
		      state <= FIREBALL_DEFAULTSTATE; 
		    end 
	     end 
	     FIREBALL_DEFAULTSTATE: begin  
		    if ((life == 0)||( winner == 1)) begin 
		      state <= THEEND_STATE; 
		    end else begin
		    if ((firey >= 305 )||(fire2y >= 305 ))begin 
			   state <= FIREBALL_RIGHTANDUP; end  
		    else if ( (firex >= 229)||(fire2x >= 229) ) begin 
		      state <= FIREBALL_LEFTANDDOWN; end 
		    end
			 
	     end 
	     FIREBALL_RIGHTANDUP: begin 
		    if ((life == 0)||( winner == 1))begin 
		      state <= THEEND_STATE; 
		    end else begin
		    if ((firey <= winBorder_Level)||(fire2y <= winBorder_Level ))begin 
			   state <= FIREBALL_RIGHTANDDOWN; end  
		    if ((firex >= 238)||(fire2x >= 238 )) begin 
			   state <= FIREBALL_LEFTANDUP; end 
		    end 
	     end 
	     FIREBALL_LEFTANDUP: begin 
		    if ((life == 0)||( winner == 1)) begin 
		       state <= THEEND_STATE; 
		    end else begin
		    if ((firey <= winBorder_Level)||((fire2y <= winBorder_Level)))begin
			   state <= FIREBALL_LEFTANDDOWN; end  
		    if ((firex <= 1)||(fire2x <= 1)) begin 
			   state <= FIREBALL_RIGHTANDUP; end 
		    end 
	     end 
	     FIREBALL_RIGHTANDDOWN: begin  
		    if ((life == 0)||( winner == 1)) begin 
		      state <= THEEND_STATE; 
		    end else begin		  
		    if ((firey >= 318)||(fire2y >= 318)) begin  
			   state <= FIREBALL_RIGHTANDUP;end 
		    if ( (firex >= 238)||(fire2x >= 238 )) begin  
			   state <= FIREBALL_LEFTANDDOWN; end
		    end 
	     end 
	     FIREBALL_LEFTANDDOWN: begin 
		    if ((life == 0)||( winner == 1)) begin 
		      state <= THEEND_STATE; 
		    end else begin		  
		    if ((firey >= 318)||(fire2y >= 318))begin 
			   state <= FIREBALL_LEFTANDUP; end  
		    if ((firex <= 1)||(fire2x <= 1)) begin 
			   state <= FIREBALL_RIGHTANDDOWN; end 
		    end 
	     end 
	     THEEND_STATE: begin 
		    if (resetApp) begin 
		      state <= START_STATE; 	
		    end
	     end
	   endcase 
    end 
  end 
   
  

							  
							  
  
endmodule 


