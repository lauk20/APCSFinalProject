public abstract class Piece{
  private int colorP; //-1 = white
  private PImage image;
  private int row;
  private int col;
  private ArrayList<Square> squares;
  private boolean selected;
  ArrayList<int[]> validMoves;
  
  public Piece(int colour, int r, int c, PImage i){
    colorP = colour;
    row = r;
    col = c;
    if (colour != -1){
      for (int x = 0; x < i.width; x++){
        for (int y = 0; y < i.height; y++){
          i.set(x,y, invertColor(color(i.get(x,y))));
        }
      }
    }
    image = i;
    squares = new ArrayList<Square>();
    selected = false;
  }
  
  public int getColor(){
    return colorP;
  }
  
  public int[] getPos(){
    int[] pos = new int[]{row, col};
    
    return pos;
  }
  
  public PImage getImage(){
    return image;
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
  
  public ArrayList<int[]> getValidMoves(){
    return validMoves;
  }
  
  public void moveTo(int row, int col){
    board[this.row][this.col] = null;
    this.row = row;
    this.col = col;
    board[row][col] = this;
    whosMove = whosMove * -1;
  }
  
  abstract void updateValidMoves();
  abstract void click(int x, int y);
  abstract void display();
}
