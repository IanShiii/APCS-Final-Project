import java.util.LinkedList;
import java.util.function.Supplier;

public class Arm {
  private LinkedList<Ligament> ligaments;
  private float x;
  private float y;

  public Arm(float x, float y) {
    ligaments = new LinkedList<Ligament>();
    this.x = x;
    this.y = y;
  }

  public void addLigament(float length) {
    if (ligaments.size() == 0) {
      Supplier<Float> startX = () -> x;
      Supplier<Float> startY = () -> y;
      Ligament newLigament = new Ligament(startX, startY, 0, length);
      ligaments.add(newLigament);
    } else {
      Ligament lastLigament = ligaments.getLast();
      Supplier<Float> startX = () -> lastLigament.calculateEndX();
      Supplier<Float> startY = () -> lastLigament.calculateEndY();
      Ligament newLigament = new Ligament(startX, startY, 0, length);
      ligaments.add(newLigament);
    }
  }
  
  public void show() {
    for (Ligament ligament : ligaments) {
      ligament.show();
    }
  }
}
