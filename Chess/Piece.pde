public abstract class Piece{
  private int colorP; //-1 = white
  private int row;
  private int col;
  private ArrayList<Square> squares;
  private boolean selected;
  
  public Piece(int colour, int r, int c){
    colorP = colour;
    row = r;
    col = c;
    squares = new ArrayList<Square>();
    selected = false;
    //validMoves = new ArrayList<int[]>();
    updateValidMoves();
  }
  
  public int getColor(){
    return colorP;
  }
  
  public int[] getPos(){
    int[] pos = new int[]{row, col};
    
    return pos;
  }
  
  public void setPos(int r, int c){
    row = r;
    col = c;
  }
  
  public void setSelected(boolean b){
    selected = b;
  }
  
  public boolean isSelected(){
    return selected;
  }
  
  public ArrayList<Square> getSquares(){
    return squares;
  }
  
  public void moveTo(int row, int col){
    board[this.row][this.col] = null;
    this.row = row;
    this.col = col;
    board[row][col] = this;
    whosMove = whosMove * -1;
    updateMoves();
  }
  
  abstract void updateValidMoves();
  abstract ArrayList<int[]> getValidMoves();
  abstract void click(int x, int y);
  abstract void display();
}
