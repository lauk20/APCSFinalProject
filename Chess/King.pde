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
          if (colorP == -1){
            if (blackThreatMap[row + rMove][col + cMove].size() == 0){
              whiteThreatMap[row + rMove][col + cMove].add(this);
              moves.add(new int[]{row + rMove, col + cMove});
            }
          }else{
            if (whiteThreatMap[row + rMove][col + cMove].size() == 0){
              blackThreatMap[row + rMove][col + cMove].add(this);
              moves.add(new int[]{row + rMove, col + cMove});
            }
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
