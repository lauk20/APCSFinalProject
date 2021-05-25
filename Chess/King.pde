import java.util.*;

public class King extends Piece{
  private int[][] moveMatrices = new int[][]{{1,0}, {-1,0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
  private ArrayList<int[]> validMoves;
  
  public King(int colour, int r, int c){
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
          moves.add(new int[]{row + rMove, col + cMove});
        }
      }
    }
    
    validMoves = moves;
  }
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
  
  public void click(int x, int y){
    if (whosMove != getColor()) return;
    int[] pos = getPos();
    if (isSelected()){
      for (int[] move : validMoves){
        if (move[1] == mouseX / 100 && move[0] == mouseY / 100){
          moveTo(move[0], move[1]);
        }
      }
    }
    if (dist(mouseX, mouseY, pos[1] * 100 + 50, pos[0] * 100 + 50) < 50){
      setSelected(!isSelected());
      ArrayList<int[]> moves = validMoves;
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
    PImage copy = imageKing.copy();
    if (getColor() == 1){
      for (int i = 15; i < copy.width - 10; i++){
        for (int j = 14; j < copy.height - 10; j++){
          copy.set(i, j, invertColor(imageKing.get(i, j)));
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
