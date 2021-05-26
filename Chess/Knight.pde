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
      int rMove = move[0];
      int cMove = move[1];
      
      if (row + rMove >= 0 && row + rMove < 8 && col + cMove >= 0 && col + cMove < 8){
        if (board[row + rMove][col + cMove] == null || board[row + rMove][col + cMove].getColor() != colorP){
          if (colorP == -1){
            moves.add(new int[]{row + rMove, col + cMove});
            whiteThreatMap[row + rMove][col + cMove].add(this);
          }else{
            moves.add(new int[]{row + rMove, col + cMove});
            blackThreatMap[row + rMove][col + cMove].add(this);
          }
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
