public class Pawn extends Piece{
  private boolean firstMove;
  private ArrayList<int[]> validMoves;
  private boolean justMovedTwo;
  private int firstMoveTime;

  public Pawn(int colour, int r, int c){
    super(colour, r, c);
    firstMove = true;
    justMovedTwo = false;
    firstMoveTime = -1;
  }
 
  public void setPos(int r, int c){
    super.setPos(r, c);
    if (firstMoveTime > historyIndex){
      firstMove = true;
      firstMoveTime = -1;
    }
  }
  
  public void updateValidMoves(){
    ArrayList<int[]> moves = new ArrayList<int[]>();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    if (colorP == whosMove){
      justMovedTwo = false;
    }
    
    if (firstMove && board[row + colorP * 2 * orientation][col] == null && board[row + colorP * 1 * orientation][col] == null && hypotheticalMove(row + colorP * 2 * orientation, col)){
      moves.add(new int[]{row + colorP * 2 * orientation, col});
    }
 
    if ((row != 0 && row != 7) && board[row + colorP * orientation][col] == null && hypotheticalMove(row + colorP * orientation, col)){
      moves.add(new int[]{row + colorP * orientation, col});
    }
      
    if ((col != 0 && row != 0 && row != 7) && board[row + colorP * orientation][col - 1] != null && hypotheticalMove(row + colorP * orientation, col - 1)){
      if(board[row + colorP * orientation][col - 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP * orientation, col - 1});
      }
    }
      
    if ((col != 7 && row != 0 && row != 7) && board[row + colorP * orientation][col + 1] != null && hypotheticalMove(row + colorP * orientation, col + 1)){
      if(board[row + colorP * orientation][col + 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP * orientation, col + 1});
      }
    }
    
    //En Passant checks;
    if ((col != 0 && row != 0 && row != 7) && row == 3 && board[row][col - 1] != null && board[row][col - 1].getJustMovedTwo() && hypotheticalMove(row + colorP * orientation, col - 1)){
      if(board[row][col - 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP * orientation, col - 1});
      }
    } 
    
    if ((col != 7 && row != 0 && row != 7) && row == 3 && board[row][col + 1] != null && board[row][col + 1].getJustMovedTwo() && hypotheticalMove(row + colorP * orientation, col + 1)){
      if(board[row][col + 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP * orientation, col + 1});
      }
    }
    
    
    if (col != 0 && row != 0 && row != 7){
      if (getColor() == -1){
        whiteThreatMap[row + colorP * orientation][col - 1].add(this);
      }else{
        blackThreatMap[row + colorP * orientation][col - 1].add(this);
      }
    }
    
    if (col != 7 && row != 0 && row != 7){
      if (getColor() == -1){
        whiteThreatMap[row + colorP * orientation][col + 1].add(this);
      }else{
        blackThreatMap[row + colorP * orientation][col + 1].add(this);
      }
    }
    
    validMoves = moves;
  }
 
  public ArrayList<Piece>[][] rawThreatMap(int row, int col, Piece movedPiece){
    ArrayList<Piece>[][] threatMap = new ArrayList[8][8];
    generateArrayListArray(threatMap);
    int[] coords = getPos();
    int r = coords[0];
    int c = coords[1];
    int colorP = getColor();
    
    if (c != 0 && r != 0 && r != 7){
      threatMap[r + colorP * orientation][c - 1].add(this);
    }
    
    if (c != 7 && r != 0 && r != 7){
      threatMap[r + colorP * orientation][c + 1].add(this);
    }
    
    return threatMap;
  }

  public void moveTo(int row, int col){
    int[] coords = getPos();
    int r = coords[0];
    int c = coords[1];
    if (row == r - 2){
      justMovedTwo = true;
    }
    if (row == r - 1 && col == c - 1 && board[row][col] == null){ //must be en passant to the left
      board[r][c - 1] = null;
    }else if (row == r - 1 && col == c + 1 && board[row][col] == null){ //must be en passant to the right
      board[r][c + 1] = null;
    }
    super.moveTo(row, col);
    firstMove = false;
    if (row==0){
      transforming = this.getPos()[1];
    }
    eaten = 0;
    if (firstMoveTime == -1){
      firstMoveTime = boardHistory.size() - 1;
    }
  }
 
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
 
  public void display(){
    int[] pos = getPos();
    PImage copy = imagePawn.copy();
    if (getColor() == 1){
      for (int i = 0; i < copy.width; i++){
        for (int j = 10; j < copy.height; j++){
          copy.set(i, j, invertColor(imagePawn.get(i, j)));
        }
      }
    }
    image(copy, pos[1] * 100, pos[0] * 100);
    
    if (isSelected()){
      for (Square s : getSquares()){
        s.display();
      }
    }
  }
  
  public boolean getJustMovedTwo(){
    return justMovedTwo;
  }
}
