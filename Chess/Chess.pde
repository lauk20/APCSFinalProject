import java.util.*;

Piece[][] board = new Piece[8][8];
ArrayList<Piece>[][] whiteThreatMap = new ArrayList[8][8]; //squares white pieces threaten
ArrayList<Piece>[][] blackThreatMap = new ArrayList[8][8]; //squares black pieces threaten
int whosMove = -1; // -1 is white
int orientation = 1; //orientation of the board. 1 is white on bottom of screen, -1 is black on bottom of screen
King whiteKing;
King blackKing;


PImage imagePawn; //https://www.clipartmax.com/middle/m2H7N4K9A0d3K9d3_chess-piece-pawn-queen-knight-chess-piece-pawn-queen-knight/
PImage imageKnight; 
PImage imageKing; //https://www.clipartmax.com/middle/m2i8H7d3G6K9N4H7_chess-piece-king-queen-pawn-chess-white-king-icon/

void setup(){
  size(800, 800);
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 8; j++){
      whiteThreatMap[i][j] = new ArrayList<Piece>();
      blackThreatMap[i][j] = new ArrayList<Piece>();
    }
  }
  imagePawn = loadImage("Pawn.png");
  imageKnight = loadImage("Knight.png");
  imageKing = loadImage("King.png");
  
  for (int i = 0; i < board[0].length; i++){
    board[1][i] = new Pawn(1, 1, i);
    board[6][i] = new Pawn(-1, 6, i);
  }
  
  board[0][1] = new Knight(1,0,1);
  board[0][6] = new Knight(1,0,6);
  board[7][1] = new Knight(-1,7,1);
  board[7][6] = new Knight(-1,7,6);
  
  whiteKing = new King(-1, 7, 4);
  board[7][4] = whiteKing;
  blackKing = new King(1, 0, 4);
  board[0][4] = blackKing;
  
  updateBoard();
  updateMoves();
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

void updateMoves(){
  for (Piece[] row : board){
    for (Piece p : row){
      if (p != null){
        p.updateValidMoves();
      }
    }
  }
  
  whiteKing.updateValidMoves();
  blackKing.updateValidMoves();
  whiteKing.updateValidMoves();
}

//Rotates the board, MUST change orientation to preserve direction of moves
Piece[][] getRotatedBoard(){
  Piece[][] rotated = new Piece[8][8];
  int originalRow = 0;
  int originalCol = 0;
  
  for (int i = 7; i >= 0 && originalRow < 8; i--){
    for (int j = 7; j >= 0 && originalCol < 8; j--){
      rotated[i][j] = board[originalRow][originalCol];
      if (board[originalRow][originalCol] != null){
        board[originalRow][originalCol].setPos(i, j);
      }
      originalCol = originalCol + 1;
    }
    originalCol = 0;
    originalRow = originalRow + 1;
  }
  
  return rotated;
}

void newThreatMaps(){
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 8; j++){
      whiteThreatMap[i][j] = new ArrayList<Piece>();
      blackThreatMap[i][j] = new ArrayList<Piece>();
    }
  }
}

void draw(){
  
}

void mouseClicked(){
  for (int i = 0; i < board.length; i++){
    for (int j = 0; j < board[0].length; j++){
      if (board[i][j] != null){
        board[i][j].click();
      }
    }
  }
  
  updateBoard();
}
