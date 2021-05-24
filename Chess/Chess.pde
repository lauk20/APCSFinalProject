Piece[][] board = new Piece[8][8];

int orientation = 1;
PImage imagePawn; //https://www.clipartmax.com/middle/m2H7N4K9A0d3K9d3_chess-piece-pawn-queen-knight-chess-piece-pawn-queen-knight/

void setup(){
  size(800, 800);
  imagePawn = loadImage("Pawn.png");
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


int whosMove = -1; // -1 is white
void draw(){
  
}

void mouseClicked(){

}
