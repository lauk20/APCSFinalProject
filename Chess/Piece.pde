abstract class Piece{
  private int row,col, colorP;
  private boolean selected, available;
  private ArrayList<int[]> validMoves;
  
  abstract void updateValidMoves();//updates validMoves after moving. So, selecting and deselecting only uses getValidMoves.
  
  ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
}
