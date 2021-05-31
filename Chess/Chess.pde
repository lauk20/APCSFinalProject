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
int transforming = -1;


PImage imagePawn; //https://www.clipartmax.com/middle/m2H7N4K9A0d3K9d3_chess-piece-pawn-queen-knight-chess-piece-pawn-queen-knight/
PImage imageKnight; //https://www.clipartmax.com/middle/m2i8H7i8i8d3A0d3_this-free-icons-png-design-of-chess-tile-knight-chess-piece/
PImage imageBishop;
PImage imageKing; //https://www.clipartmax.com/middle/m2i8H7d3G6K9N4H7_chess-piece-king-queen-pawn-chess-white-king-icon/
PImage imageRook;
PImage imageQueen; //https://www.clipartmax.com/download/m2i8i8d3d3m2i8Z5_free-vector-portablejim-chess-tile-queen-clip-art-chess-queen-clip-art/

void setup(){
  size(1000, 800);
  imagePawn = loadImage("Pawn.png");
  imageKnight = loadImage("Knight.png");
  imageBishop = loadImage("Bishop.png");
  imageKing = loadImage("King.png");
  imageRook = loadImage("Rook.png");
  imageQueen = loadImage("Queen.png");
  createBoard();
}

void createBoard(){
  board = new Piece[8][8];
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 8; j++){
      whiteThreatMap[i][j] = new ArrayList<Piece>();
      blackThreatMap[i][j] = new ArrayList<Piece>();
    }
  }
  
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
  rectMode(CORNER);
  int counterx = 0;
  int countery = 0;
  for (int i = 0; i < width && i < 800; i = i + 100){
    for (int j = 0; j < height && j < 800; j = j + 100){;
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
  updateMenu();
  drawSquares();
  for (int i = 0; i < board.length; i++){
    for (int j = 0; j < board[0].length; j++){
      if (board[i][j] != null){
        board[i][j].display();
      }
    }
  }
  
  if (transforming != -1){
    fill(100, 97, 97, 150);
    rect(0, 0, 800, 800);
    fill(255);
    rect(800*1/4, 800*3/8, 400, 200);
    stroke(0);
    for (int i = 0; i < 4; i++){
      rect(i*100+200, 400, 100, 100);
    }
    noStroke();
    fill(0);
    textAlign(CENTER);
    textSize(64);
    text("PROMOTE", 800*1/2, 800*5/11);
    image(imageQueen.copy(), 200, 400);
    image(imageBishop.copy(), 300, 400);
    image(imageRook.copy(), 400, 400);
    image(imageKnight.copy(), 500, 400);
    transformation = true;
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
  updateBoard();
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
    
    if (mouseX >= 850 && mouseX <= 950 && mouseY >= 100 && mouseY <= 150){ //AREA OF RESET BOARD BUTTON
      whosMove = -1;
      orientation = 1;
      createBoard();
    }
  }
  else if (mouseY/100 == 4 && mouseX/100>=2 && mouseX/100<=5){
    Piece newPiece;
    if (mouseX/100 == 2){
      newPiece = new Queen(whosMove*-1, 7, transforming);
    }
    else if (mouseX/100 == 3){
      newPiece = new Bishop(whosMove*-1, 7, transforming);
    }
    else if (mouseX/100 == 4){
      newPiece = new Rook(whosMove*-1, 7, transforming);
    }
    else{
      newPiece = new Knight(whosMove*-1, 7, transforming);
    }
    board[7][transforming] = newPiece;
    newPiece.updateValidMoves();
    transforming = -1;
    transformation = false;
    updateMoves();
  }

  //updateBoard(); not needed if is called in draw();
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
  text(text, 800/2, 800/2);
}

void updateMenu(){
  background(45,45,45);
  rectMode(CENTER);
  noStroke();
  fill(56, 75, 87);
  if (mouseX >= 850 && mouseX <= 950 && mouseY >= 100 && mouseY <= 150){ //AREA OF RESET BOARD BUTTON
    fill(56, 75, 150);
  }
  rect(900, 125, 100, 50);
  fill(255);
  textAlign(CENTER);
  textSize(48);
  text("MENU", 900, 75);
  textSize(15);
  text("RESET\nBOARD", 900, 118);
}
