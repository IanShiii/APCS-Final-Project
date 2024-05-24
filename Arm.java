import java.util.LinkedList;
import java.util.function.Supplier;

public class Arm {
  private LinkedList<Ligament> ligaments;

  public Arm() {
    ligaments = new LinkedList<Ligament>();
  }

  public void addLigament(double length) {
    if (ligaments.size() == 0) {
      Supplier<Double> startX = () -> 0.0;
      Supplier<Double> startY = () -> 0.0;
      Ligament newLigament = new Ligament(startX, startY, 0, length);
      ligaments.add(newLigament);
    } else {
      Ligament lastLigament = ligaments.getLast();
      Supplier<Double> startX = () -> lastLigament.calculateEndX();
      Supplier<Double> startY = () -> lastLigament.calculateEndY();
      Ligament newLigament = new Ligament(startX, startY, 0, length);
      ligaments.add(newLigament);
    }
  }
}
