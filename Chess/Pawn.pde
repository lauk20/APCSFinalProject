public class Pawn extends Piece{
  private boolean firstMove;

  public Pawn(int colour, int r, int c){
    super(colour, r, c);
    firstMove = true;
    updateValidMoves();
  }
  
  public void updateValidMoves(){
    ArrayList<int[]> moves = getValidMoves();
    moves.clear();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    if (firstMove && board[row + colorP * 2][col] == null){
      moves.add(new int[]{row + colorP * 2, col});
    }
  
    if ((row != 0 && row != 7) && board[row + colorP][col] == null){
      moves.add(new int[]{row + colorP, col});
    }
      
    if ((col != 0 && row != 0 && row != 7) && board[row + colorP][col - 1] != null){
      if(board[row + colorP][col - 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP, col - 1});
      }
    }
      
    if ((col != 7 && row != 0 && row != 7) && board[row + colorP][col + 1] != null){
      if(board[row + colorP][col + 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP, col + 1});
      }
    }
  }

  public void moveTo(int row, int col){
    super.moveTo(row, col);
    firstMove = false;
  }
  
  public void click(int x, int y){
    if (whosMove != getColor()) return;
    int[] pos = getPos();
    if (isSelected()){
      for (int[] move : getValidMoves()){
        if (move[1] == mouseX / 100 && move[0] == mouseY / 100){
          moveTo(move[0], move[1]);
        }
      }
    }
    if (dist(mouseX, mouseY, pos[1] * 100 + 50, pos[0] * 100 + 50) < 50){
      setSelected(!isSelected());
      ArrayList<int[]> moves = getValidMoves();
      if (!isSelected()){
        getSquares().clear();
      }else{
        for (int[] coord : moves){
          getSquares().add(new Square(coord[1] * 100, coord[0] * 100, color(0, 255, 0, 100)));
        }
      }
    }else{
      setSelected(false);
      getSquares().clear();
    }
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
