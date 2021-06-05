import java.util.*;

public class King extends Piece{
  private int[][] moveMatrices = new int[][]{{1,0}, {-1,0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
  private ArrayList<int[]> validMoves;
  private boolean firstMove;
  private int firstMoveTime;
  
  public King(int colour, int r, int c){
    super(colour, r, c);
    firstMove = true;
    firstMoveTime = -1;
  }
  
  public void setPos(int r, int c){
    super.setPos(r, c);
    if (firstMoveTime > boardHistory.size() - 1){
      firstMove = true;
      firstMoveTime = -1;
    }
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
        if (row >= 0 && row < 8 && col == 4){ //0, 6 right side castle
          //piece obstruction test!!!
          boolean canCastleRight = true;
          if (whiteRightRook == null && !whiteRightRook.isFirstMove()){
            canCastleRight = false;
          }
          for (int i = col + 1; canCastleRight && i < whiteRightRook.getPos()[1]; i++){
            //if statements are split up for readability
            if (board[row][i] != null){
              canCastleRight = false;
            }else if (blackThreatMap[row][i].size() != 0){
              canCastleRight = false;
            }
          }
          if (canCastleRight && whiteRightRook.hypotheticalMove(row, 5)){
            moves.add(new int[]{row, 6});
          }
          //old castling code
          /*if (board[row][col + 1] == null && board[row][col + 2] == null && blackThreatMap[row][col + 1].size() == 0 && blackThreatMap[row][col + 2].size() == 0 && blackThreatMap[row][col].size() == 0 && whiteRightRook != null && whiteRightRook.isFirstMove() && whiteRightRook.hypotheticalMove(row, col + 1)){
            moves.add(new int[]{row, col + 2});
          }*/
          boolean canCastleLeft = true;
          if (whiteLeftRook == null && !whiteLeftRook.isFirstMove()){
            canCastleLeft = false;
          }
          for (int i = col - 1; canCastleLeft && i > whiteLeftRook.getPos()[1]; i--){
            //if statements are split up for readability
            if (board[row][i] != null){
              canCastleLeft = false;
            }else if (blackThreatMap[row][i].size() != 0){
              canCastleLeft = false;
            }
          }
          if (canCastleLeft && whiteLeftRook.hypotheticalMove(row, 3)){
            moves.add(new int[]{row, 2});
          }
          //old castling code
          /*if (board[row][col - 1] == null && board[row][col - 2] == null && blackThreatMap[row][col - 1].size() == 0 && blackThreatMap[row][col - 2].size() == 0 && blackThreatMap[row][col].size() == 0 && whiteLeftRook != null && whiteLeftRook.isFirstMove() && whiteLeftRook.hypotheticalMove(row, col - 1)){
            moves.add(new int[]{row, col - 2});
          }*/
        }
      }else{
        if (row >= 0 && row < 8 && col == 3){
          boolean canCastleRight = true;
          if (blackRightRook == null && !blackRightRook.isFirstMove()){
            canCastleRight = false;
          }
          for (int i = col + 1; canCastleRight && i < blackRightRook.getPos()[1]; i++){
            //if statements are split up for readability
            if (board[row][i] != null){
              canCastleRight = false;
            }else if (whiteThreatMap[row][i].size() != 0){
              canCastleRight = false;
            }
          }
          if (canCastleRight && blackRightRook.hypotheticalMove(row, 4)){
            moves.add(new int[]{row, 5});
          }
          boolean canCastleLeft = true;
          if (blackLeftRook == null && !blackLeftRook.isFirstMove()){
            canCastleLeft = false;
          }
          for (int i = col - 1; canCastleLeft && i > blackLeftRook.getPos()[1]; i--){
            //if statements are split up for readability
            if (board[row][i] != null){
              canCastleLeft = false;
            }else if (whiteThreatMap[row][i].size() != 0){
              canCastleLeft = false;
            }
          }
          if (canCastleLeft && blackLeftRook.hypotheticalMove(row, 2)){
            moves.add(new int[]{row, 1});
          }
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
      }else{
        rookInQuestion = blackRightRook;
        rookInQuestion.setPos(r, c + 1);
        board[r][c + 4] = null;
        board[r][c + 1] = rookInQuestion;
      }
    }else if (firstMove && col == c - 2){
      if (colorP == -1){
        rookInQuestion = whiteLeftRook;
        rookInQuestion.setPos(r, c - 1);
        board[r][c - 4] = null;
        board[r][c - 1] = rookInQuestion;
      }else{
        rookInQuestion = blackLeftRook;
        rookInQuestion.setPos(r, c - 1);
        board[r][c - 3] = null;
        board[r][c - 1] = rookInQuestion;        
      }
    }
    super.moveTo(row, col);
    firstMove = false;
    if (firstMoveTime == -1){
      firstMoveTime = boardHistory.size() - 1;
    }
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
