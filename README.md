# ELEC5566M-Mini-Project-ayvckl
ELEC5566M-Mini-Project-ayvckl created by GitHub Classroom
15/04/2022

ASSIGNMENT 3: MINI PROJECT REPORT


Basic Space Game (2D) Verilog Design on the DE1-SoC Development Board and LT24 LCD Module


      This report is on a design game’s Verilog HDL code and how these codes work on the DE1 SoC board and LT24 display module. This game design is based on a two-dimension spaceship-enemy basic game logic design. It includes, how the game and its purpose will be mentioned in this report. A summary of how the game is played is given and then the main task of the game, the state machine, is mentioned. Some errors encountered while writing the code are given with error codes. 
Finally, an evaluation of the project is presented in the conclusion part. The codes of the mini project are shared in the appendix section of this report.
  o The game is played by the data from 4 buttons (KEY 0,1,2, and 3).
  o The game starts with the Start button in the starting state. The start button is used as a forward button in other states.
  o In other states, it provides the movements of the main figure with the right, left and forward buttons.
  o In the game, the player tries to reach the reserved area specified on the screen by avoiding two obstacles moving according to the state machine in the game. At the beginning of the game, the player is given 3 lives and these lives are shown on the seven segments.
  o Each time the player collides with an obstacle, they lose one life.
  o Each time a life is lost during the game, the figure returns to the starting point and the player starts over.
  o If the player loses all 3 lives, the game is over. If the player reaches the designated area without finishing 3 lives, he wins.



KEY3-> Left Button
KEY2 ->Right Button
KEY1 -> Fast/Forward Button 
KEY0 -> Reset Button
