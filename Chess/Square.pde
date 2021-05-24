public class Square{
  float x;
  float y;
  color c;
  
  public Square(float x, float y, color colour){
    this.x = x;
    this.y = y;
    c = colour;
  }
  
  public void display(){
      noFill();
      stroke(c);
      strokeWeight(5);
      rect(x, y, 100, 100);
  }
}
