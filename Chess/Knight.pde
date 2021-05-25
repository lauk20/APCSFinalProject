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
      
    }
  }
}
