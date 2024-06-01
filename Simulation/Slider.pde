public class Slider {
  private String description;
  private float value;
  private int min;
  private int max;
  private int x;
  private int y;
  private int sliderHeight;
  private int sliderLength;
  private boolean isDiscrete;
  private boolean isHidden;
  
  public Slider(String description, int min, int max) {
    this.description = description;
    this.min = min;
    this.max = max;
    this.value = (min + max)/2; // default value is the average
    this.x = 0;
    this.y = 0;
    this.sliderHeight = 30;
    this.sliderLength = 400;
    this.isDiscrete = true;
    this.isHidden = false;
  }
  
  public float getValue() {
    return value;
  }
  
  public Slider makeDiscrete() {
    this.isDiscrete = true;
    return this;
  }
  
  public Slider makeNotDiscrete() {
    this.isDiscrete = false;
    return this;
  }
  
  public void hide() {
    this.isHidden = true;
  }
  
  public void unhide() {
    this.isHidden = false;
  }
  
  private void setValueBasedOnMouse() {
    if (mousePressed && (mouseButton == LEFT)) {
      if (mouseY > y && mouseY < y + sliderHeight) {
        if(mouseX > x && mouseX < x + sliderLength) {
          value = (float)(mouseX - x) / sliderLength * (max - min) + min;
          if (isDiscrete) {
            value = round(value);
          }
        }
      }
    } 
    
    // safety
    this.value = constrain(value, min, max);
  }
  
  private void update() {
    setValueBasedOnMouse();
  }
  
  public void show(int x, int y) {
    this.x = x;
    this.y = y;
    if (!isHidden) {
      noFill();
      strokeWeight(3);
      stroke(color(0,0,0));
      rect(x, y, sliderLength, sliderHeight);
      fill(255, 255, 255);
      rect(x, y, (float)sliderLength * (value - min) / (max - min), sliderHeight); 
      textSize(30);
      textAlign(LEFT);
      text(description, x - textWidth(description) - 5, y + sliderHeight);
      if (isDiscrete) {
        text((int)value, x + sliderLength + 5, y + sliderHeight);
      }
      else {
        text(value, x + sliderLength + 5, y + sliderHeight);
      }
      update();
    }
  }
}
