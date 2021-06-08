# APCSFinalProject

**Team Name:** Chess Masters

**Team Members:** Kenny Lau, Timothy Sit

**Project Description:** This is just regular chess. There's an 8 by 8 board with all the pieces. The looks will be simplified though with a birds eye view. The pieces will look like simple sprites.

**Link:** https://docs.google.com/document/d/1o0dgqXgDeqktdCHe9d0ZRGArPyJQEDs9bVVidZOPrwI/edit?usp=sharing

**Run Instructions**
1. Install Processing
2. Open ```Chess.pde``` in Processing
3. Press Run

**TIPS**
1. If you want to castle, select the King piece.
2. En Passant is also supported.
3. Stalemates that are supported: basic stalemate (no valid move for King and not in check), 50-move rule, and 3-fold repetition.

## Development Log
### 6/7/21
**Kenny Lau:** Fixed the saving bug that kept saving the same board and a loading bug that would throw an error. Fixed En Passant for timed mode and the "undo" and "redo" buttons will no longer show up for timed mode.

**Timothy Sit:** Tried separating save files between modes. Tried to make time only save the most recent board since not being able to undo or redo makes having a history irrelevant. Did not manage to do it all."

### 6/6/21
**Kenny Lau:** Implemented the redo feature, allowing for redoes. Made a working saving and loading current board feature that also supports redoing and undoing from the saved state.

**Timothy Sit:** Changed some lines to save memory. Looked for the bug in save and load.

### 6/5/21
**Kenny Lau:** Made the Chess 960 mode setup. Spent time fixing the castling for the time. Chess 960 mode is also selectable with the change mode button.

**Timothy Sit:** Created appearance of save, load, and redo buttons.

### 6/4/21
**Kenny Lau:** Fixed the 3-fold repetition stalemate. Implemented the undo feature.

**Timothy Sit:** Fixed undo so it works with the 50 move stalemate.

### 6/3/21
**Kenny Lau:** Updated menu to reflect new stalemate condition. Fixed end game screen so that pieces are no longer selectable after a player has won. Fixed some bugs with the new stalemate. Added the 3-fold repetition stalemate.

**Timothy Sit:** Created auto end button. Started on undo button, which doesn't work yet.

### 6/2/21
**Kenny Lau:** Completed the toggle mode button, which toggles between casual and timed mode now. Completed increase and decrease time button for the timers. Also, a winner will now be determined when a timer runs out. I also implemented the basic stalemate condition (no valid moves left and the king is not in check).

**Timothy Sit:** Changed promotion to work with new code. Started on change time buttons, which Kenny finished. Created a new kind of stalemate which still has bugs.

### 6/1/21
**Kenny Lau:** Finished the timed mode that uses the timers I created today. Pausing is also now a feature that works with the timed mode and timers. These come with their corresponding buttons in the menu.

**Timothy Sit:** Studied for ap exam.

### 5/31/21
**Kenny Lau:** Started the menu design and created a working reset board button, which resets the board.

**Timothy Sit:** Changed transform, actually called promotion, to depend on color of piece being changed. Changed mouseclicks to work as a square.

### 5/30/21
**Kenny Lau:** Increased screen size to 1000x800 (width x height) to prepare for new functions/buttons.

**Timothy Sit:** Out with family. Unable to code.

### 5/29/21
**Kenny Lau:** Added En Passant, a special move, into the game.

**Timothy Sit:** Rest day.

### 5/28/21
**Kenny Lau:** Fixed check error with the Knight where it allowed other Pieces to keep the King in check. Fixed another check error where pieces could not identify a King was being checked by a Pawn. Also added feature where after a Pawn is promoted, the resulting Piece will be able to be identified as a check if there is one. Completed the castling special move for both white and black pieces.

**Timothy Sit:** Finished tranforming.

### 5/27/21
**Kenny Lau:** Created and completed the ```Queen``` class, meaning all Pieces are now made. Also fixed error with pieces being able to make moves that would keep their king in check (from yesterday's code). Implemented a way to determine a checkmate that is now working and displays the winner on the screen. As far as testing goes, the game seems to be functional, not including special moves that may be added later.

**Timothy Sit:** Started on transforming ```Pawn``` when it reaches the end. Not completed yet, but the looks are done.


### 5/26/21
**Kenny Lau:** I created and completed the ``Rook`` class today. I also implemented one of the most crucial functions to a chess game to all the pieces that we currently have: Pieces cannot open its own King to a check anymore! I created new methods that "hypothetically" move the piece to a potential square that helps with the validating moves to see if they open its own king to a check. Also fixed Kings being able to put itself into a check, an error that was from yesterday's code.

**Timothy Sit:** Today was a rest day for me.

### 5/25/21
**Kenny Lau:** I completed the ```Pawn``` class, which now moves correctly. I also implemented the board rotation feature, so after each turn, the board will rotate. The ```King``` class was also completed and moves correctly. The King can now move correctly and also avoid putting itself into a check position by using the "threat maps" that I implemented. The Pawn moves correctly, but it can still make moves that open the King to a check; this will be addressed in later updates (probably).

**Timothy Sit:** I created the ```Knight``` class. The king can still put itself in check with it, so I not done coding it yet. Beside that, I just discussed how code should be implemented with Kenny.

### 5/24/21
**Kenny Lau:** I created the main Processing file, Chess.pde, that draws an 8x8 chess board on a 800x800 screen in Processing. I also created the ```Square``` class that "lights up" the board when pieces are selected by drawing rectangles at the correct location. We also complete the ```Piece``` abstract class (so far, we may need to update it for functions we will implement later, such as rotating the board). The ```Pawn``` class was also created with skeleton code (abstract methods are stated but not implemented, so it can still be compiled). I was able to fix the invertColor() method too.

**Timothy Sit:** In setup, created all the pieces in the board. For now, it's all filled with pawns, we'll need to change it when we create the other pieces. Tried to make the Pawn able to invert but pixels outside the shape aren't actually completely transparent, so we'll have to figure out another way to get a black Pawn. If we can't use a inverse the color, we'll have to add a black Pawn to the library.
