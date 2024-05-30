public class Button {
  private String text;
  private color buttonColor;
  private color hoverColor;
  private int x;
  private int y;
  private int buttonWidth;
  private int buttonHeight;
  private Procedure onClick;
  private boolean isAlreadyClicked;
  
  public Button(String text, int buttonWidth, int buttonHeight, Procedure onClick) {
    this.x = 0;
    this.y = 0;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.text = text;
    
    this.buttonColor = color(163, 177, 199);
    int hoverDimLevel = 25;
    this.hoverColor = color(constrain(red(buttonColor) - hoverDimLevel, 0, 255), constrain(green(buttonColor) - hoverDimLevel, 0, 255), constrain(blue(buttonColor) - hoverDimLevel, 0, 255));
    
    this.onClick = onClick;
    this.isAlreadyClicked = false;
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public void setColor(color buttonColor) {
    this.buttonColor = buttonColor;
  }
  
  private boolean isMouseOverButton() {
    if (mouseX > x && mouseX < x + buttonWidth) {
      if (mouseY > y && mouseY< y + buttonHeight) {
        return true;
      }
    }  
    return false;
  }
  
  public void update() {
    if (isMouseOverButton() && !isAlreadyClicked) {
      if (mousePressed && (mouseButton == LEFT)) {
        onClick.run();
        isAlreadyClicked = true;
        return;
      }
    }
    else {
      isAlreadyClicked = mousePressed;
    }
  }
  
  public void show(int x, int y) {
    this.x = x;
    this.y = y;
    
    color activeColor;
    if (isMouseOverButton()) {
      activeColor = hoverColor;
    }
    else {
      activeColor = buttonColor;
    }
    
    fill(activeColor);
    rect(x, y, buttonWidth, buttonHeight);
    textAlign(CENTER);
    fill(color(255, 255, 255));
    textSize(30);
    text(text, x + buttonWidth/2, y + buttonHeight/2 + 10);
  }
  
}
