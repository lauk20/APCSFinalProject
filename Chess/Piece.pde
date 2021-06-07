public abstract class Piece{
  private int colorP; //-1 = white
  private int row;
  private int col;
  private ArrayList<Square> squares;
  private boolean selected;
 
  public Piece(int colour, int r, int c){
    colorP = colour;
    row = r;
    col = c;
    squares = new ArrayList<Square>();
    selected = false;
  }
 
  public int getColor(){
    return colorP;
  }
 
  public int[] getPos(){
    int[] pos = new int[]{row, col};
    
    return pos;
  }
 
  public void setPos(int r, int c){
    row = r;
    col = c;
  }
 
  public void setSelected(boolean b){
    selected = b;
  }
 
  public boolean isSelected(){
    return selected;
  }
 
  public ArrayList<Square> getSquares(){
    return squares;
  }
 
  public void moveTo(int row, int col){
    if (madeMove){
      return;
    }
    //printBoard(board);
    Piece pieceThere = board[row][col];
    if (pieceThere == whiteRightRook && colorP == 1){
      whiteRightRook = null;
    }else if (pieceThere == whiteLeftRook && colorP == 1){
      whiteLeftRook = null;
    }else if (pieceThere == blackRightRook && colorP == -1){
      blackRightRook = null;
    }else if (pieceThere == blackLeftRook && colorP == -1){
      blackLeftRook = null;
    }
    if (board[row][col] != null){
      eaten = 0;
    }
    else{
      eaten++;
    }
    if (board[this.row][this.col] != null && board[this.row][this.col].getColor() != colorP){
      board[this.row][this.col] = null;
    }else if (board[this.row][this.col] == this){
      board[this.row][this.col] = null;
    }
    this.row = row;
    this.col = col;
    board[row][col] = this;
    //printBoard(board);
    setSelected(false); //unselect after move
    for (int i = boardHistory.size() - 1; i > historyIndex; i--){
      boardHistory.remove(i);
      eatenHistory.remove(eatenHistory.size() - 1);
    }
    if (!mode.equals("timed") || auto){
      endTurn();
      madeMove = false;
    }else{
      madeMove = true;
      updateMoves();
      updateMoves(); // called a second time because for example: if a black queen just checked the king in a previous move and we have some white pieces that is past the black queen, their valid moves would not be correct because the queen's threat map has not been updated since the last move yet and the white pieces past the queen think that there's no check.
    }
  }
 
  public boolean hypotheticalMove(int r, int c){
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    ArrayList<Piece>[][] map = whiteThreatMap;
    if (colorP == -1){
      map = blackThreatMap;
    }
    
    ArrayList<Piece> ALP = map[row][col];
    for (Piece p : ALP){
      ArrayList<Piece>[][] rawMap = p.rawThreatMap(r, c, this);
      int[] kingCoords = whiteKing.getPos();
      int kRow = kingCoords[0];
      int kCol = kingCoords[1];
      if (colorP == 1){
        kingCoords = blackKing.getPos();
        kRow = kingCoords[0];
        kCol = kingCoords[1];
      }
      if (rawMap[kRow][kCol].size() > 0 && board[r][c] != p){ //board[r][c] != p : if board[r][c] == p, then it means that the move we are hypothetically making will capture the threat of that piece.
        //println(kRow + " " + kCol);
        return false;
      }
    }
    
    if (colorP == -1){
      int[] kingCoords = whiteKing.getPos();
      row = kingCoords[0];
      col = kingCoords[1];
    }else{
      int[] kingCoords = blackKing.getPos();
      row = kingCoords[0];
      col = kingCoords[1];
    }
    
    for (Piece p : map[row][col]){
      ArrayList<Piece>[][] rawMap = p.rawThreatMap(r, c, this);
      int[] kingCoords = whiteKing.getPos();
      int kRow = kingCoords[0];
      int kCol = kingCoords[1];
      if (colorP == 1){
        kingCoords = blackKing.getPos();
        kRow = kingCoords[0];
        kCol = kingCoords[1];
      }
      if (rawMap[kRow][kCol].size() > 0 && board[r][c] != p){
        //println(kRow + " " + kCol);
        return false;
      }
    }
    
    return true;
  }
 
  public void click(){
    if (whosMove != getColor() || (paused && mode.equals("timed")) || winner != 0) return;
    int[] pos = getPos();
    if (isSelected()){
      for (int[] move : getValidMoves()){
        if (move[1] == mouseX / 100 && move[0] == mouseY / 100){
          moveTo(move[0], move[1]);
          clickFound = true;
        }
      }
    }
    if (mouseX/100 == pos[1] && mouseY/100 == pos[0]){
      setSelected(!isSelected());
      ArrayList<int[]> moves = getValidMoves();
      if (!isSelected()){
        getSquares().clear();
      }else{
        for (int[] coord : moves){
          getSquares().add(new Square(coord[1] * 100, coord[0] * 100, color(0, 255, 0, 100)));
        }
      }
    }else{
      setSelected(false);
      getSquares().clear();
    }
  }
 
  public void generateArrayListArray(ArrayList<Piece>[][] map){
    for (int i = 0; i < 8; i++){
      for (int j = 0; j < 8; j++){
        map[i][j] = new ArrayList<Piece>();
      }
    }
  }
  
  public boolean getJustMovedTwo(){
    return false;
  }
  
  public String toString(){
    return "Piece";
  }
  
  public boolean isFirstMove(){
    return false;
  }
  
  public int firstTurnTime(){
    return -1;
  }
  
  abstract void updateValidMoves();
  abstract ArrayList<Piece>[][] rawThreatMap(int row, int col, Piece movedPiece);
  abstract ArrayList<int[]> getValidMoves();
  abstract void display();
}
