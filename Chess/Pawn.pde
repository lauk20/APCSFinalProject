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
    int[] pos = getPos();
    PImage copy = imagePawn.copy();
    if (getColor() == 1){
      for (int i = 0; i < copy.width; i++){
        for (int j = 10; j < copy.height; j++){
          copy.set(i, j, invertColor(imagePawn.get(i, j)));
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
