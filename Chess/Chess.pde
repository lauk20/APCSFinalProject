import java.util.*;

Piece[][] board = new Piece[8][8];

int orientation = 1;
PImage imagePawn; //https://www.clipartmax.com/middle/m2H7N4K9A0d3K9d3_chess-piece-pawn-queen-knight-chess-piece-pawn-queen-knight/

void setup(){
  size(800, 800);
  imagePawn = loadImage("Pawn.png");
  int testx = 0;
  int testy = 0;
  System.out.print(alpha(imagePawn.get(testx,testy))+", "+(red(imagePawn.get(testx,testy)))+", "+(green(imagePawn.get(testx,testy)))+", "+(blue(imagePawn.get(testx,testy)))+", ");//looks at values of a pixel
  drawSquares();
  for (int x = 0; x < board.length; x++){//for width
    for (int y = 0; y < 2; y++){//top player
      board[x][y] = new Pawn(0,x,y, loadImage("Pawn.png"));//everything is pawn right now. We have to change it later.
      image(board[x][y].getImage(), x*100, y*100);
    }
    for (int y = board.length-2; y < board.length; y++){//bottom player
      board[x][y] = new Pawn(-1,x,y, loadImage("Pawn.png"));//everything is pawn right now. We have to change it later.
      image(board[x][y].getImage(), x*100, y*100);
    }
  }
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
  if (alpha(c)==0){//if transparent, return the same color. But apparently, the stuff outside the pawn isn't all transparent.
    return c;
  }
  float red = red(c);
  float green = green(c);
  float blue = blue(c);
  
  if (red >= 200 && green >= 200 && blue >= 200){
    return color(0,0,0);
  }
  return c;
}

int whosMove = -1; // -1 is white
void draw(){//draw the pieces. Change to only drawing after moving or selecting
  for (int i = 0; i<0; i++){
  }
}

void mouseClicked(){

}
