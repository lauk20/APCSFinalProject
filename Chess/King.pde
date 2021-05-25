import java.util.*;

public class King extends Piece{
  private int[][] moveMatrix = new int[][]{{1,0}, {-1,0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
  private ArrayList<int[]> validMoves;
  
  public King(int colour, int r, int c){
    super(colour, r, c);
    updateValidMoves();
  }
  
  public void updateValidMoves(){
    ArrayList<int[]> moves = new ArrayList<int[]>();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
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
     
  }
}
