public class Button {
  private int x;
  private int y;
  private int buttonWidth;
  private int buttonHeight;
  private Procedure onClick;
  
  public Button(int buttonWidth, int buttonHeight, Procedure onClick) {
    this.x = 0;
    this.y = 0;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.onClick = onClick;
  }
}
