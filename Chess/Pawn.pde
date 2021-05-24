public class Pawn extends Piece{
  private boolean firstMove;

  public Pawn(int colour, int r, int c){
    super(colour, r, c);
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
