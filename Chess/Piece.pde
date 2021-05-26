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
    board[this.row][this.col] = null;
    this.row = row;
    this.col = col;
    board[row][col] = this;
    whosMove = whosMove * -1;
    board = getRotatedBoard();
    orientation = orientation * -1;
    newThreatMaps();
    updateMoves();
  }
  
  public boolean hypotheticalMove(int r, int c){
    Piece[][] originalBoard = board.clone();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    board[row][col] = null;
    board[r][c] = this;
    
    newThreatMaps();
    updateMoves();
    
    if (colorP == -1){
      int[] kingCoords = whiteKing.getPos();
      int kRow = kingCoords[0];
      int kCol = kingCoords[1];
      
      if (blackThreatMap[kRow][kCol].size() > 0){
        return false;
      }
    }else{
      int[] kingCoords = blackKing.getPos();
      int kRow = kingCoords[0];
      int kCol = kingCoords[1];
      
      if (whiteThreatMap[kRow][kCol].size() > 0){
        return false;
      }
    }
    
    board = originalBoard;
    newThreatMaps();
    updateMoves();
    
    return true;
  }
  
  public void click(){
    if (whosMove != getColor()) return;
    int[] pos = getPos();
    if (isSelected()){
      for (int[] move : getValidMoves()){
        if (move[1] == mouseX / 100 && move[0] == mouseY / 100){
          moveTo(move[0], move[1]);
        }
      }
    }
    if (dist(mouseX, mouseY, pos[1] * 100 + 50, pos[0] * 100 + 50) < 50){
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
  
  abstract void updateValidMoves();
  abstract ArrayList<int[]> getValidMoves();
  abstract void display();
}
