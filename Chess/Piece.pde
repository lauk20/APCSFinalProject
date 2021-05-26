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
      if (rawMap[kRow][kCol].size() > 0){
        println(kRow + " " + kCol);
        return false;
      }
    }
    
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
  
  public void generateArrayListArray(ArrayList<Piece>[][] map){
    for (int i = 0; i < 8; i++){
      for (int j = 0; j < 8; j++){
        map[i][j] = new ArrayList<Piece>();
      }
    }
  }
  
  abstract void updateValidMoves();
  abstract ArrayList<Piece>[][] rawThreatMap(int row, int col, Piece movedPiece);
  abstract ArrayList<int[]> getValidMoves();
  abstract void display();
}
