abstract class Piece{
  private int row,col, colorP;
  private boolean selected, available;
  
  abstract ArrayList<int[]> getValidMoves();
  
  
}
