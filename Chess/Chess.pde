import java.util.*;

Piece[][] board = new Piece[8][8];
ArrayList<Piece>[][] whiteThreatMap = new ArrayList[8][8]; //squares white pieces threaten
ArrayList<Piece>[][] blackThreatMap = new ArrayList[8][8]; //squares black pieces threaten
int whosMove = -1; // -1 is white
int orientation = 1; //orientation of the board. 1 is white on bottom of screen, -1 is black on bottom of screen
King whiteKing;
King blackKing;
Rook whiteRightRook;
Rook whiteLeftRook;
Rook blackRightRook;
Rook blackLeftRook;
int winner = 0; //0 is no winner, -1 is white, 1 is black.
boolean transformation = false;
Piece transforming;


PImage imagePawn; //https://www.clipartmax.com/middle/m2H7N4K9A0d3K9d3_chess-piece-pawn-queen-knight-chess-piece-pawn-queen-knight/
PImage imageKnight; //https://www.clipartmax.com/middle/m2i8H7i8i8d3A0d3_this-free-icons-png-design-of-chess-tile-knight-chess-piece/
PImage imageBishop;
PImage imageKing; //https://www.clipartmax.com/middle/m2i8H7d3G6K9N4H7_chess-piece-king-queen-pawn-chess-white-king-icon/
PImage imageRook;
PImage imageQueen; //https://www.clipartmax.com/download/m2i8i8d3d3m2i8Z5_free-vector-portablejim-chess-tile-queen-clip-art-chess-queen-clip-art/

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
  imageBishop = loadImage("Bishop.png");
  imageKing = loadImage("King.png");
  imageRook = loadImage("Rook.png");
  imageQueen = loadImage("Queen.png");
  
  for (int i = 0; i < board[0].length; i++){
    board[1][i] = new Pawn(1, 1, i);
    board[6][i] = new Pawn(-1, 6, i);
  }
  
  board[0][1] = new Knight(1,0,1);
  board[0][6] = new Knight(1,0,6);
  board[7][1] = new Knight(-1,7,1);
  board[7][6] = new Knight(-1,7,6);
  
  board[0][2] = new Bishop(1,0,2);
  board[0][5] = new Bishop(1,0,5);
  board[7][2] = new Bishop(-1,7,2);
  board[7][5] = new Bishop(-1,7,5);
  
  whiteKing = new King(-1, 7, 4);
  board[7][4] = whiteKing;
  blackKing = new King(1, 0, 4);
  board[0][4] = blackKing;
  
  whiteLeftRook = new Rook(-1, 7, 0);
  board[7][0] = whiteLeftRook;
  whiteRightRook = new Rook(-1, 7, 7);
  board[7][7] = whiteRightRook;
  blackRightRook = new Rook(1, 0, 0);
  board[0][0] = blackRightRook;
  blackLeftRook = new Rook(1, 0, 7);
  board[0][7] = blackLeftRook;
  
  board[7][3] = new Queen(-1, 7, 3);
  board[0][3] = new Queen(1, 0, 3);
  
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
  
  for (int i = 0; i < 7; i++){
    if (board[7][i] instanceof Pawn){
      transforming = board[7][i];
      board[7][i].transform();
    }
  }
  
  if (winner != 0){
    fill(100, 97, 97, 150);
    rect(0, 0, 800, 800);
  }
  if (winner == -1){
    displayMessage("WHITE WINS", color(255,255,255,255));
  }else if (winner == 1){
    displayMessage("BLACK WINS", color(0, 0, 0, 255));
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
  if (transformation == false){
    for (int i = 0; i < board.length; i++){
      for (int j = 0; j < board[0].length; j++){
        if (board[i][j] != null){
          board[i][j].click();
        }
      }
    }
  }
  else for (int i = 0; i < 4; i++){
    if (dist(mouseX, mouseY, (2+i) * 100 + 50, 4 * 100 + 50) < 50){
      if (i == 0)  transforming = new Queen(transforming.getColor(), transforming.row, transforming.col);
    }
  }
  
  
  updateBoard();
}

//UML: "isCheck()"
boolean isCheckmate(){
  if (whiteKing.getValidMoves().size() == 0){
    for (int i = 0; i < board.length; i++){
      for (int j = 0; j < board[0].length; j++){
        if (board[i][j] != null && board[i][j].getColor() == -1){
          if (board[i][j].getValidMoves().size() > 0){
            return false;
          }
        }
      }
    }
    //println("BLACK WINS");
    winner = 1;
    return true;
  }else if (blackKing.getValidMoves().size() == 0){
    for (int i = 0; i < board.length; i++){
      for (int j = 0; j < board[0].length; j++){
        if (board[i][j] != null && board[i][j].getColor() == 1){
          if (board[i][j].getValidMoves().size() > 0){
            return false;
          }
        }
      }
    }
    //println("WHITE WINS");
    winner = -1;
    return true;
  }
  
  return false;
}

void displayMessage(String text, color c){
  fill(c);
  textAlign(CENTER);
  textSize(64);
  text(text, width/2, height/2);
}
