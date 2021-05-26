public class Rook extends Piece{
  private int[][] moveMatrices = new int[][]{ {-1, 0}, {1, 0}, {0, -1}, {-1, 0}};
  private ArrayList<int[]> validMoves;
  
  public Rook(int colour, int r, int c){
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
      
      while (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8 && board[rMove][cMove] == null ){
        if (colorP == -1){
          moves.add(new int[]{rMove, cMove});
          whiteThreatMap[rMove][cMove].add(this);
        }else{
          moves.add(new int[]{rMove, cMove});
          blackThreatMap[rMove][cMove].add(this);
        }
        rMove += move[0];
        cMove += move[1];
      }
      if (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8 && board[rMove][cMove].getColor() != colorP){
        if (colorP == -1){
          moves.add(new int[]{rMove, cMove});
          whiteThreatMap[rMove][cMove].add(this);
        }else{
          moves.add(new int[]{rMove, cMove});
          blackThreatMap[rMove][cMove].add(this);
        }
      }
    }
    
    validMoves = moves;
  }
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
  
  public void display(){
    int[] pos = getPos();
    PImage copy = imageRook.copy();
    if (getColor() == 1){
      for (int i = 12; i < copy.width - 14; i++){
        for (int j = 14; j < copy.height - 10; j++){
          copy.set(i, j, invertColor(imageRook.get(i, j)));
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
