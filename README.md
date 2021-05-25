# APCSFinalProject

Team Name: Chess Masters

Team Members: Kenny Lau, Timothy Sit

Project Description: This is just regular chess. There's an 8 by 8 board with all the pieces. The looks will be simplified though with a birds eye view. The pieces will look like simple sprites.

Link: https://docs.google.com/document/d/1o0dgqXgDeqktdCHe9d0ZRGArPyJQEDs9bVVidZOPrwI/edit?usp=sharing

Instructions: press run and play normally.

## Development Log
### 5/24/21
**Kenny Lau:** I created the main Processing file, Chess.pde, that draws an 8x8 chess board on a 800x800 screen in Processing. I also created the ```Square``` class that "lights up" the board when pieces are selected by drawing rectangles at the correct location. We also complete the ```Piece``` abstract class (so far, we may need to update it for functions we will implement later, such as rotating the board). The ```Pawn``` class was also created with skeleton code (abstract methods are stated but not implemented, so it can still be compiled).

**Timothy Sit:** In setup, created all the pieces in the board. For now, it's all filled with pawns, we'll need to change it when we create the other pieces. Tried to make the Pawn able to invert but pixels outside the shape aren't actually completely transparent, so we'll have to figure out another way to get a black Pawn. If we can't use a inverse the color, we'll have to add a black Pawn to the library.
