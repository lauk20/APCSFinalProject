public class Knight extends Piece{
  private int[][] moveMatrices = new int[][]{{2,-1}, {2,1}, {1, -2}, {-1, -2}, {-2, -1}, {-2, 1}, {1, 2}, {-1, 2}};
  private ArrayList<int[]> validMoves;
  
  public Knight(int colour, int r, int c){
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
      
      if (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
         if (colorP == -1){
            whiteThreatMap[rMove][cMove].add(this);
         }else{
            blackThreatMap[rMove][cMove].add(this);
         }
        if ((board[rMove][cMove] == null || board[rMove][cMove].getColor() != colorP) && hypotheticalMove(rMove, cMove)){
          moves.add(new int[]{rMove, cMove});
        }
      }
    }
    
    validMoves = moves;
  }
  
  public ArrayList<Piece>[][] rawThreatMap(int row, int col, Piece movedPiece){
    ArrayList<Piece>[][] threatMap = new ArrayList[8][8];
    generateArrayListArray(threatMap);
    
    for (int[] move : moveMatrices){
      int rMove = row + move[0];
      int cMove = col + move[1];
      
      if (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
        threatMap[rMove][cMove].add(this);
      }
    }
    
    return threatMap;
  }
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
  
  public void display(){
    int[] pos = getPos();
    PImage copy = imageKnight.copy();
    if (getColor() == 1){
      for (int i = 10; i < copy.width - 10; i++){
        for (int j = 14; j < copy.height - 10; j++){
          copy.set(i, j, invertColor(imageKnight.get(i, j)));
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
}
