public class Pawn extends Piece{
  private boolean firstMove;
  private ArrayList<int[]> validMoves;

  public Pawn(int colour, int r, int c){
    super(colour, r, c);
    firstMove = true;
  }
  
  public void updateValidMoves(){
    ArrayList<int[]> moves = new ArrayList<int[]>();
    int[] coords = getPos();
    int row = coords[0];
    int col = coords[1];
    int colorP = getColor();
    
    if (firstMove && board[row + colorP * 2 * orientation][col] == null && board[row + colorP * 1 * orientation][col] == null && hypotheticalMove(row + colorP * 2 * orientation, col)){
      moves.add(new int[]{row + colorP * 2 * orientation, col});
    }
  
    if ((row != 0 && row != 7) && board[row + colorP * orientation][col] == null && hypotheticalMove(row + colorP * orientation, col)){
      moves.add(new int[]{row + colorP * orientation, col});
    }
      
    if ((col != 0 && row != 0 && row != 7) && board[row + colorP * orientation][col - 1] != null && hypotheticalMove(row + colorP * orientation, col - 1)){
      if(board[row + colorP * orientation][col - 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP * orientation, col - 1});
      }
    }
      
    if ((col != 7 && row != 0 && row != 7) && board[row + colorP * orientation][col + 1] != null && hypotheticalMove(row + colorP * orientation, col + 1)){
      if(board[row + colorP * orientation][col + 1].getColor() != getColor()){
        moves.add(new int[]{row + colorP * orientation, col + 1});
      }
    }
    
    if (col != 0 && row != 0 && row != 7){
      if (getColor() == -1){
        whiteThreatMap[row + colorP * orientation][col - 1].add(this);
      }else{
        blackThreatMap[row + colorP * orientation][col - 1].add(this);
      }
    }
    
    if (col != 7 && row != 0 && row != 7){
      if (getColor() == -1){
        whiteThreatMap[row + colorP * orientation][col + 1].add(this);
      }else{
        blackThreatMap[row + colorP * orientation][col + 1].add(this);
      }
    }
    
    validMoves = moves;
  }
  
  public ArrayList<Piece>[][] rawThreatMap(int row, int col, Piece movedPiece){
    ArrayList<Piece>[][] threatMap = new ArrayList[8][8];
    generateArrayListArray(threatMap);
    int colorP = getColor();
    
    if (col != 0 && row != 0 && row != 7){
      threatMap[row + colorP * orientation][col - 1].add(this);
    }
    
    if (col != 7 && row != 0 && row != 7){
      threatMap[row + colorP * orientation][col + 1].add(this);
    }
    
    return threatMap;
  }

  public void moveTo(int row, int col){
    super.moveTo(row, col);
    firstMove = false;
  }
  
  public void transform(){
    fill(100, 97, 97, 150);
    rect(0, 0, 800, 800);
    fill(255);
    rect(width*1/4, height*3/8, 400, 200);
    stroke(0);
    for (int i = 0; i < 4; i++){
      rect(i*100+200, 400, 100, 100);
    }
    noStroke();
    fill(0);
    textAlign(CENTER);
    textSize(64);
    text("Transform", width*1/2, height*5/11);
    image(imageQueen.copy(), 200, 400);
    image(imageBishop.copy(), 300, 400);
    image(imageRook.copy(), 400, 400);
    image(imageBishop.copy(), 500, 400);
    transformation = true;
  }
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
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
