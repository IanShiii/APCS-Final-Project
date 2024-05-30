public class Slider {
  private String description;
  private int value;
  private int min;
  private int max;
  private int x;
  private int y;
  private int sliderHeight;
  private int sliderLength;
  
  public Slider(String description, int min, int max, int sliderHeight, int sliderLength) {
    this.description = description;
    this.min = min;
    this.max = max;
    this.value = (min + max)/2; // default value is the average
    this.x = 0;
    this.y = 0;
    this.sliderHeight = sliderHeight;
    this.sliderLength = sliderLength;
  }
  
  public int getValue() {
    return value;
  }
  
  private void setValueBasedOnMouse() {
    if (mousePressed && (mouseButton == LEFT)) {
      if (mouseY > y && mouseY < y + sliderHeight) {
        if(mouseX > x && mouseX < x + sliderLength) {
          this.value = round((float)(mouseX - x) / sliderLength * (max - min)) + min;
        }
      }
    } 
    
    // safety
    this.value = constrain(value, min, max);
  }
  
  public void update() {
    setValueBasedOnMouse();
  }
  
  public void show(int x, int y) {
    this.x = x;
    this.y = y;
    // background
    noFill();
    strokeWeight(3);
    rect(x, y, sliderLength, sliderHeight);
    fill(255, 255, 255);
    rect(x, y, (float)sliderLength * (value - min) / (max - min), sliderHeight); 
    textSize(30);
    textAlign(LEFT);
    text(description, x - textWidth(description) - 5, y + sliderHeight);
    text(value, x + sliderLength + 5, y + sliderHeight);
  }
}
