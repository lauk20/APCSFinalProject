import java.util.*;

public class King extends Piece{
  private int[][] moveMatrices = new int[][]{{1,0}, {-1,0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
  private ArrayList<int[]> validMoves;
  boolean firstMove;
  
  public King(int colour, int r, int c){
    super(colour, r, c);
    firstMove = true;
  }
  
  public void updateValidMoves(){
    ArrayList<int[]> moves = new ArrayList<int[]>();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    for (int[] move : moveMatrices){
      int rMove = row + move[0];
      int cMove = col + move[1];
      
      if (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
         if (colorP == -1){
            whiteThreatMap[rMove][cMove].add(this);
         }else{
            blackThreatMap[rMove][cMove].add(this);
         }
        if (board[rMove][cMove] == null || board[rMove][cMove].getColor() != colorP){
          if (colorP == -1){
            if (blackThreatMap[rMove][cMove].size() == 0){
              moves.add(new int[]{rMove, cMove});
            }
          }else{
            if (whiteThreatMap[rMove][cMove].size() == 0){
              moves.add(new int[]{rMove, cMove});
            }
          }
        }
      }
    }
    
    if (firstMove){
      if (colorP == -1){
        if (row >= 0 && row < 8 && col == 4){
          if (board[row][col + 1] == null && board[row][col + 2] == null && blackThreatMap[row][col + 1].size() == 0 && blackThreatMap[row][col + 2].size() == 0 && blackThreatMap[row][col].size() == 0 && whiteRightRook.isFirstMove() && whiteRightRook.hypotheticalMove(row, col + 1)){
            moves.add(new int[]{row, col + 2});
          }
          if (board[row][col - 1] == null && board[row][col - 2] == null && blackThreatMap[row][col - 1].size() == 0 && blackThreatMap[row][col - 2].size() == 0 && blackThreatMap[row][col].size() == 0 && whiteLeftRook.isFirstMove() && whiteLeftRook.hypotheticalMove(row, col + 3)){
            moves.add(new int[]{row, col - 2});
          }
        }
      }else{
        if (board[row][col - 1] == null && board[row][col - 2] == null && board[row][col + 1] == null && board[row][col + 2] == null && whiteThreatMap[row][col + 1].size() == 0 && whiteThreatMap[row][col + 2].size() == 0 && whiteThreatMap[row][col].size() == 0 && blackRightRook.isFirstMove() && blackRightRook.hypotheticalMove(row, col + 1)){
          moves.add(new int[]{row, col + 2});
        }
        if (whiteThreatMap[row][col - 1].size() == 0 && whiteThreatMap[row][col - 2].size() == 0 && whiteThreatMap[row][col].size() == 0 && blackLeftRook.isFirstMove() && blackLeftRook.hypotheticalMove(row, col + 3)){
          moves.add(new int[]{row, col - 2});
        }   
      }
    }
    
    validMoves = moves;
  }
  
  public ArrayList<Piece>[][] rawThreatMap(int row, int col, Piece movedPiece){
    ArrayList<Piece>[][] threatMap = new ArrayList[8][8];
    generateArrayListArray(threatMap);
    
    for (int[] move : moveMatrices){
      int rMove = row + move[0];
      int cMove = col + move[1];
      
      if (rMove >= 0 && rMove < 8 && cMove >= 0 && cMove < 8){
        threatMap[rMove][cMove].add(this);
      }
    }
    
    return threatMap;
  }
  
  public void moveTo(int row, int col){
    int[] coords = getPos();
    int r = coords[0];
    int c = coords[1];
    int colorP = getColor();
    Rook rookInQuestion;
    if (firstMove && col == c + 2){
      if (colorP == -1){
        rookInQuestion = whiteRightRook;
        rookInQuestion.setPos(r, c + 1);
        board[r][c + 3] = null;
        board[r][c + 1] = rookInQuestion;
      }
      else{
        rookInQuestion = blackRightRook;
      }
    }else if (firstMove && col == c - 2){
      if (colorP == -1){
        rookInQuestion = whiteLeftRook;
        rookInQuestion.setPos(r, c + 3);
        board[r][c - 4] = null;
        board[r][c - 1] = rookInQuestion;
      }
    }
    super.moveTo(row, col);
    firstMove = false;
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
