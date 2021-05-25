import java.util.*;

Piece[][] board = new Piece[8][8];

int orientation = 1;
PImage imagePawn; //https://www.clipartmax.com/middle/m2H7N4K9A0d3K9d3_chess-piece-pawn-queen-knight-chess-piece-pawn-queen-knight/

void setup(){
  size(800, 800);
  imagePawn = loadImage("Pawn.png");
  
  for (int i = 0; i < board[0].length; i++){
    board[1][i] = new Pawn(1, 1, i);
    board[6][i] = new Pawn(-1, 6, i);
  }
  updateBoard();
}

void drawSquares(){
  int counterx = 0;
  int countery = 0;
  for (int i = 0; i < width; i = i + 100){
    for (int j = 0; j < height; j = j + 100){;
      if (counterx % 2 == countery % 2){
        fill(185, 167, 116);
        noStroke();
        rect(i, j, 100, 100);
      }else{
        fill(158, 124, 29);
        rect(i, j, 100, 100);
      }
      counterx++;
    }
    countery++;
  }
}

/*change white to black, does not have to be pure white.
  this is so that we don't have to find white and black images
  for the pieces, just white and then convert to black
*/
color invertColor(color c){
  float red = red(c);
  float green = green(c);
  float blue = blue(c);
  
  if (red >= 200 && green >= 200 && blue >= 200){
    return color(0,0,0);
  }
  return c;
}

void updateBoard(){
  clear();
  drawSquares();
  for (int i = 0; i < board.length; i++){
    for (int j = 0; j < board[0].length; j++){
      if (board[i][j] != null){
        board[i][j].display();
      }
    }
  }
}

int whosMove = -1; // -1 is white
void draw(){
  
}

void mouseClicked(){
  for (int i = 0; i < board.length; i++){
    for (int j = 0; j < board[0].length; j++){
      if (board[i][j] != null){
        board[i][j].click(mouseX, mouseY);
      }
    }
  }
  
  updateBoard();
}
