import java.util.*;

//board
Piece[][] board = new Piece[8][8];
ArrayList<Piece[][]> boardHistory = new ArrayList<Piece[][]>();
int historyIndex = 0;
ArrayList<Integer> eatenHistory;

//basic threat maps
ArrayList<Piece>[][] whiteThreatMap = new ArrayList[8][8]; //squares white pieces threaten
ArrayList<Piece>[][] blackThreatMap = new ArrayList[8][8]; //squares black pieces threaten

//whosMove and orientation
int whosMove = -1; // -1 is white
int orientation = 1; //orientation of the board. 1 is white on bottom of screen, -1 is black on bottom of screen

//Kings
King whiteKing;
King blackKing;

//Rooks
Rook whiteRightRook;
Rook whiteLeftRook;
Rook blackRightRook;
Rook blackLeftRook;

//winner
int winner = 0; //0 is no winner, -1 is white, 1 is black, 2 is stalemate

//pawn promotion variables
boolean transformation = false;
int transforming = -1;

//mode based variables (timers)
String mode = "casual"; //timed for timers, anything else for non-timed...
float[] whiteTime = new float[] {0, 600000}; //[0] = start/time checkpoint, [1] = current time left in millis
float[] blackTime = new float[] {0, 600000};
float timerAmount = 600000; // 10 minutes in millis
boolean paused = true;
boolean madeMove = false;
boolean changeTime = true;
boolean auto = false;

//moves since last captured piece or last pawn moved, 50-move rule variable
int eaten;

//PImage variables
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
  whiteTime = new float[] {0, timerAmount}; 
  blackTime = new float[] {0, timerAmount};  
  changeTime = true;
  paused = true;
  madeMove = false;
  eaten = 0;
  eatenHistory = new ArrayList<Integer>();
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
  
  boardHistory.clear();
  boardHistory.add(copyArray(board));
  historyIndex = 0;
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
  if (mode.equals("timed") && paused && winner == 0){
    fill(23,23,23);
    rect(800/2, 800/2, 800, 800);
    fill(255);
    textSize(48);
    textAlign(CENTER);
    text("CLICK SCREEN TO BEGIN/RESUME", 400, 400);
    return;
  }
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
    noStroke();
  }
  if (winner == -1){
    displayMessage("WHITE WINS", color(255,255,255,255));
  }else if (winner == 1){
    displayMessage("BLACK WINS", color(0, 0, 0, 255));
  }else if (winner == 2){
    displayMessage("STALEMATE", color(255, 255, 255, 255));
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

void updateBoardHistory(){
  Piece[][] addBoard = copyArray(board);
  if (orientation == -1){
    Piece[][] newBoard = new Piece[8][8];
    int originalRow = 0;
    int originalCol = 0;
    for (int i = 7; i >= 0 && originalRow < 8; i--){
      for (int j = 7; j >= 0 && originalCol < 8; j--){
        newBoard[i][j] = addBoard[originalRow][originalCol];
        originalCol = originalCol + 1;
      }
      originalCol = 0;
      originalRow = originalRow + 1;
    }
    addBoard = newBoard;
  }
  
  int counter = 0;
  for (Piece[][] oldBoard : boardHistory){
    if (isEqualBoard(oldBoard, addBoard)){
      counter = counter + 1;
    }//else{
      //printBoard(oldBoard);
      //printBoard(addBoard);
    //}
  }
  
  if (counter >= 2){
    winner = 2;
  }

  boardHistory.add(addBoard);
  historyIndex = historyIndex + 1;
}

Piece[][] copyArray(Piece[][] arr){ //make our own copy
  Piece[][] newCopy = new Piece[8][8];
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 8; j++){
      newCopy[i][j] = arr[i][j];
    }
  }
  return newCopy;
}

boolean isEqualBoard(Piece[][] arr1, Piece[][] arr2){ //check if the boards are equal
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 8; j++){
      if (arr1[i][j] != arr2[i][j]){
        return false;
      }
    }
  }
  
  return true;
}

void printBoard(Piece[][] b){ //for debug purposes only
  for (Piece[] row : b){
    for (Piece p : row){
      print(p + " ");
    }
    println();
  }
  
  println();
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
        board[originalRow][originalCol].setSelected(false); //when we rotate, we don't want and pieces to be selected
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

public void endTurn(){
  whosMove = whosMove * -1;
  board = getRotatedBoard();
  orientation = orientation * -1;
  newThreatMaps();
  updateMoves();
  updateMoves(); // called a second time because for example: if a black queen just checked the king in a previous move and we have some white pieces that is past the black queen, their valid moves would not be correct because the queen's threat map has not been updated since the last move yet and the white pieces past the queen think that there's no check.
  isCheckmate(); 
  updateBoardHistory();
  madeMove = false;
  if (mode.equals("timed")){
    if (blackTime[0] == 0){
      blackTime[0] = millis();
    }
    if (whosMove == -1){
      blackTime[1] = blackTime[1] - (millis() - blackTime[0]); //changing the time left for black because if it's white's move, it means that black just ended. so, we subtract the timeleft for black by (the current time minus the last time checkpoint), which will give us the new time left
      whiteTime[0] = millis(); //this sets the new time checkpoint for white, which will be used later when the move is ended to set the current time leftw
    }else{
      whiteTime[1] = whiteTime[1] - (millis() - whiteTime[0]);
      blackTime[0] = millis();
    }
  }
}

void draw(){
  if (whiteTime[1] <= 0 || (whiteTime[1] - (millis() - whiteTime[0]))/1000 == 0){
    whiteTime[1] = 0;
    winner = 1;
    paused = true;
    updateBoard();
  }else if (blackTime[1] <= 0 || (blackTime[1] - (millis() - blackTime[0]))/1000 == 0){
    blackTime[1] = 0;
    winner = -1;
    paused = true;
    updateBoard();
  }
  if (eaten >= 100){
    winner = 2;
  }
  updateMenu();
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
      winner = 0;
      createBoard();
    }
    
    if (mouseX >= 850 && mouseX <= 950 && mouseY >= 162 && mouseY <= 187 && boardHistory.size() >= 2 && !mode.equals("timed")){// AREA OF UNDO BOARD BUTTON
      boardHistory.remove(boardHistory.size()-1);
      board = copyArray(boardHistory.get(boardHistory.size()-1));
      //printBoard(board);
      Piece[][] changeBoard = copyArray(board);
      if (whosMove == 1){
        Piece[][] newBoard = new Piece[8][8];
        int originalRow = 0;
        int originalCol = 0;
        for (int i = 7; i >= 0 && originalRow < 8; i--){
          for (int j = 7; j >= 0 && originalCol < 8; j--){
            newBoard[i][j] = changeBoard[originalRow][originalCol];
            originalCol = originalCol + 1;
          }
          originalCol = 0;
          originalRow = originalRow + 1;
        }
        changeBoard = newBoard; 
      }
      board = changeBoard;
      for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
          if (board[i][j] != null){
            board[i][j].setPos(i, j);
          }
        }
      }
      eaten = eatenHistory.remove(eatenHistory.size()-1);
      whosMove *= -1;
      orientation = orientation * -1;
      board = getRotatedBoard();
      newThreatMaps();
      updateMoves();
      updateMoves();
    }
    
    if (mouseX >= 850 && mouseX <= 950 && mouseY >= 350 && mouseY <= 400 && mode.equals("timed") && madeMove && !paused){ //AREA OF END TURN BUTTON, ONLY WORKS WHEN TIMED MODE
      endTurn();
      
      //Not needed since endTurn has this portion of code now
      /*if (blackTime[0] == 0){
        blackTime[0] = millis();
      }
      if (whosMove == -1){
        blackTime[1] = blackTime[1] - (millis() - blackTime[0]); //changing the time left for black because if it's white's move, it means that black just ended. so, we subtract the timeleft for black by (the current time minus the last time checkpoint), which will give us the new time left
        whiteTime[0] = millis(); //this sets the new time checkpoint for white, which will be used later when the move is ended to set the current time leftw
      }else{
        whiteTime[1] = whiteTime[1] - (millis() - whiteTime[0]);
        blackTime[0] = millis();
      }*/
    }
    
    if (mouseX >= 810 && mouseX <= 840 && mouseY >= 360 && mouseY <= 390 && mode.equals("timed") && paused){// AREA OF AUTO END TURN BUTTON
      auto = !auto;
    }
    
    if (mouseX >= 815 && mouseX <= 835 && mouseY >= 200 && mouseY <= 230){ //white time decrease
      whiteTime[1] = whiteTime[1] - 10 * 1000;
    }else if (mouseX >= 965 && mouseX <= 985 && mouseY >= 200 && mouseY <= 230){ //white time increase
      whiteTime[1] = whiteTime[1] + 10 * 1000;
    }else if (mouseX >= 815 && mouseX <= 835 && mouseY >= 280 && mouseY <= 310){ //black time decrease
      blackTime[1] = blackTime[1] - 10 * 1000;
    }else if (mouseX >= 965 && mouseX <= 985 && mouseY >= 280 && mouseY <= 310){ //black time increase
      blackTime[1] = blackTime[1] + 10 * 1000;
    }
    
    if (mouseX >= 850 && mouseX <= 950 && mouseY >= 425 && mouseY <= 475 && !paused && mode.equals("timed")){ //AREA OF PAUSE GAME BUTTON
      paused = true;
      changeTime = true;
      if (whiteTime[0] != 0 && whosMove == -1){
        whiteTime[1] = whiteTime[1] - (millis() - whiteTime[0]); //we set the current time left because once we unpause, the time checkpoint will be updated to reflect the time that has passed. no need to update the checkpoint because the unpause will handle it correctly
      }
      if (blackTime[0] != 0 && whosMove == 1){
        blackTime[1] = blackTime[1] - (millis() - blackTime[0]);
      }
    }
    
    if (mouseX >= 850 && mouseX <= 950 && mouseY >= 535 && mouseY <= 585){ //AREA OF TOGGLE MODE BUTTON
      if (mode.equals("timed")){
        mode = "casual";
      }else{
        mode = "timed";
      }
      whosMove = -1;
      orientation = 1;
      winner = 0;
      createBoard();
    }
    
    if (mouseX <= 800 && mode.equals("timed") && paused){ //Start screen for timed mode
      if (whiteTime[0] == 0){
        whiteTime[0] = millis();
      }else{
        if (whosMove == -1){ //we only update the time checkpoint for white/black because end move will set a new checkpoint for the other to start counting
          whiteTime[0] = millis();
        }else{
          blackTime[0] = millis();
        }
      }
      paused = false;
      changeTime = false;
    }
  }
  else{ 
    if (mode.equals("timed")){
      if (mouseY/100 == 4 && mouseX/100>=2 && mouseX/100<=5){ // area of tranformation
        Piece newPiece;
        if (mouseX/100 == 2){
          newPiece = new Queen(whosMove, 0, transforming);
        }
        else if (mouseX/100 == 3){
          newPiece = new Bishop(whosMove, 0, transforming);
        }
        else if (mouseX/100 == 4){
          newPiece = new Rook(whosMove, 0, transforming);
        }
        else{
          newPiece = new Knight(whosMove, 0, transforming);
        }
        board[0][transforming] = newPiece;
        newPiece.updateValidMoves();
        transforming = -1;
        transformation = false;
        updateMoves();
      }
    }else{
      if (mouseY/100 == 4 && mouseX/100>=2 && mouseX/100<=5){
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
    }
  }

  updateBoard(); //not needed if is called in draw();
}

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
    int[] coords = whiteKing.getPos();
    if (blackThreatMap[coords[0]][coords[1]].size() > 0){ // is in check? diff between checkmate and stalemate: checkmate, king in check and no valid moves. stalemate, king not in check and no valid moves
      winner = 1;
    }else{
      winner = 2; //stalemate because king not in check but also no valid moves
    }
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
    int[] coords = blackKing.getPos();
    if (whiteThreatMap[coords[0]][coords[1]].size() > 0){
      winner = -1;
    }else{
      winner = 2; //stalemate because king not in check but also no valid moves
    }
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
  rectMode(CORNER);
  fill(45,45,45);
  noStroke();
  rect(800, 0, 200, 800);
  
  rectMode(CENTER);
  
  //title
  fill(255,255,255);
  textSize(48);
  text("MENU", 900, 75);
  
  //reset board button
  fill(56, 75, 87);
  if (mouseX >= 850 && mouseX <= 950 && mouseY >= 100 && mouseY <= 150){ //AREA OF RESET BOARD BUTTON
    fill(56, 75, 150);
  }
  rect(900, 125, 100, 50);
  fill(255);
  textAlign(CENTER);
  textSize(15);
  text("RESET\nBOARD", 900, 118);
  
  //undo button
  fill(56, 75, 87);
  if (mouseX >= 850 && mouseX <= 950 && mouseY >= 162 && mouseY <= 187 && !mode.equals("timed")){ //AREA OF UNDO BOARD BUTTON
    fill(56, 75, 150);
  }
  rect(900, 175, 100, 25);
  fill(255);
  text("UNDO", 900, 180);
  
  //timers
  textSize(25);
  if (mode.equals("timed")){
    if (paused || winner != 0){
      text(round(whiteTime[1]/1000), 900, 215);
      text(round(blackTime[1]/1000), 900, 295);
    }else{
      if (whosMove == -1){
        if (whiteTime[0] == 0){
          text(round(timerAmount/1000), 900, 215);
          text(round(timerAmount/1000), 900, 295);
        }else{
          text(round((whiteTime[1] - (millis() - whiteTime[0]))/1000), 900, 215); //calculate but dont set the time until turn is ended
          text(round(blackTime[1]/1000), 900, 295);
        }
      }
      if (whosMove == 1){
        if (blackTime[0] == 0){
          text(round(timerAmount/1000), 900, 215);
        }else{
          text(round(whiteTime[1]/1000), 900, 215);
          text(round((blackTime[1] - (millis() - blackTime[0]))/1000), 900, 295);
        }
      }
    }
    if (changeTime == true){
      text("<", 825, 215);
      text(">", 975, 215);
      text("<", 825, 295);
      text(">", 975, 295);
    }
  }else{
    text("OFF", 900, 215);
    text("OFF", 900, 295);
  }
  textSize(15);
  text("WHITE TIME", 900, 250);
  text("BLACK TIME", 900, 325);
  
  //End move button
  fill(56,75,87);
  if (mouseX >= 850 && mouseX <= 950 && mouseY >= 350 && mouseY <= 400){ //AREA OF END TURN BUTTON
    fill(56, 75, 150);
  }
  rect(900, 375, 100, 50);
  textSize(15);
  fill(255,255,255);
  text("END\nTURN", 900, 368);
  
  //auto end move button
  if (paused && mode.equals("timed")){
    if (auto){
      fill(56,75,87);
    }
    else{
      fill(255);
    }
    if (mouseX >= 810 && mouseX <= 840 && mouseY >= 360 && mouseY <= 390){ //AREA OF AUTO END TURN BUTTON
      fill(56, 75, 150);
    }
    rect(825, 375, 30, 30);
    textSize(10);
    fill(255);
    text("AUTO", 825, 355);
  }
  
  //Pause button
  fill(56, 76, 87);
  if (mouseX >= 850 && mouseX <= 950 && mouseY >= 425 && mouseY <= 475){ //AREA OF PAUSE GAME BUTTON
    fill(56, 75, 150);
  }
  rect(900, 450, 100, 50);
  textSize(15);
  fill(255);
  text("PAUSE\nGAME", 900, 443);
  
  //Mode text
  String modeText = "CASUAL";
  if (mode.equals("timed")){
    modeText = "TIMED";
  }
  text("MODE: " + modeText, 900, 525);
  
  //Mode toggle button
  fill(56, 76, 87);
  if (mouseX >= 850 && mouseX <= 950 && mouseY >= 535 && mouseY <= 585){ //AREA OF TOGGLE MODE BUTTON
    fill(56, 75, 150);
  }
  rect(900, 560, 100, 50);
  fill(255);
  text("TOGGLE\nMODE", 900, 553);
  textSize(10);
  text("TOGGLING MODE RESETS THE BOARD", 900, 600);
  
  //noteaten
  textSize(15);
  text(eaten/2, 900, 650);
  textSize(10);
  text("ROUNDS WITHOUT CAPTURES\nOR PAWN MOVEMENT ON BOTH SIDES", 900, 675);
  text("STALEMATE AT 50: 50-MOVE RULE", 900, 710);
}
