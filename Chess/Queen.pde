public class Queen extends Piece{
  private int[][] moveMatrices = new int[][]{{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {1, 1}, {1, -1}, {-1, 1}};
  private ArrayList<int[]> validMoves;
  
  public Queen(int colour, int r, int c){
    super(colour, r, c);
  }
  
  public void updateValidMoves(){
    ArrayList<int[]> moves = new ArrayList<int[]>();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    for (int[] move : moveMatrices){
      int rMove = row + move[0];
      int cMove = col + move[1];
      
      boolean stopAddingMoves = false;
      boolean stopAddingThreats = false;
      
      while (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
        if (!stopAddingThreats){
          if (colorP == -1){
            whiteThreatMap[rMove][cMove].add(this);
          }else{
            blackThreatMap[rMove][cMove].add(this);
          }
        }
        if (board[rMove][cMove] != null){
          Piece piece = board[rMove][cMove];
          if (piece != whiteKing && piece != blackKing){
            stopAddingThreats = true;
          }
        }
        if (!stopAddingMoves && (board[rMove][cMove] == null || board[rMove][cMove].getColor() != colorP) && hypotheticalMove(rMove, cMove)){
          moves.add(new int[]{rMove, cMove});
        }
        if (board[rMove][cMove] != null){
          stopAddingMoves = true;
        }
        rMove += move[0];
        cMove += move[1];
      }
    }
    
    validMoves = moves;
  }
  
  public ArrayList<Piece>[][] rawThreatMap(int r, int c, Piece movedPiece){
    ArrayList<Piece>[][] threatMap = new ArrayList[8][8];
    generateArrayListArray(threatMap);
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    
    for (int[] move : moveMatrices){
      int rMove = row + move[0];
      int cMove = col + move[1];
      
      boolean stopAddingThreats = false;
      
      while (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
        if (!stopAddingThreats){
            threatMap[rMove][cMove].add(this);
        }
        if (board[rMove][cMove] != null){
          Piece piece = board[rMove][cMove];
          if (piece != whiteKing && piece != blackKing && piece != movedPiece){
            stopAddingThreats = true;
          }
        }
        if (board[rMove][cMove] == null && rMove == r && cMove == c){
          stopAddingThreats = true;
        }
        
        rMove += move[0];
        cMove += move[1];
      }
    }
    
    return threatMap;
  }
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
  
  public void display(){
    int[] pos = getPos();
    PImage copy = imageQueen.copy();
    if (getColor() == 1){
      for (int i = 10; i < copy.width - 10; i++){
        for (int j = 10; j < copy.height - 10; j++){
          copy.set(i, j, invertColor(imageQueen.get(i, j)));
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
  
  public String toString(){
    return "Queen";
  }
}
