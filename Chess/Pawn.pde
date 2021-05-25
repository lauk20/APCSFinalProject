public class Pawn extends Piece{
  private boolean firstMove;

  public Pawn(int colour, int r, int c, PImage i){
    super(colour, r, c, i);
    firstMove = true;
    updateValidMoves();
  }
  
  public void updateValidMoves(){
  
  }

  public void moveTo(int row, int col){
    super.moveTo(row, col);
    firstMove = false;
  }
  
  public void click(int x, int y){
    
  }
  
  public void display(){
    
  }
}
