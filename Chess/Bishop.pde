public class Bishop extends Piece{
  private int[][] moveMatrices = new int[][]{ {-1, -1}, {1, 1}, {1, -1}, {-1, 1}};
  private ArrayList<int[]> validMoves;
  
  public Bishop(int colour, int r, int c){
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
      
      while (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
        if (colorP == -1){
          whiteThreatMap[rMove][cMove].add(this);
        }else{
          blackThreatMap[rMove][cMove].add(this);
        }
        if (!stopAddingMoves){
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
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
  
  public void display(){
    int[] pos = getPos();
    PImage copy = imageBishop.copy();
    if (getColor() == 1){
      for (int i = 10; i < copy.width - 10; i++){
        for (int j = 8; j < copy.height - 10; j++){
          copy.set(i, j, invertColor(imageBishop.get(i, j)));
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
