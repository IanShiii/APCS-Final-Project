import java.util.LinkedList;
import java.util.function.Supplier;

public class Arm {
  private LinkedList<Ligament> ligaments;
  private float x;
  private float y;
  private boolean showRadii;

  public Arm(float x, float y) {
    ligaments = new LinkedList<Ligament>();
    this.x = x;
    this.y = y;
    this.showRadii = false;
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
  
  public float[] getLigamentLengths() {
    float[] ligamentLengths = new float[ligaments.size()];
    for (int i = 0; i < ligaments.size(); i++) {
      ligamentLengths[i] = ligaments.get(i).getSize();
    }
    return ligamentLengths;
  }
  
  public void setShowRadii(boolean showRadii) {
    this.showRadii = showRadii;
  }
  
  public void show() {
    for (Ligament ligament : ligaments) {
      ligament.show();
      if (showRadii) {
        ligament.showRadius();
      }
    }
  }
  
  public float getMaxDistance() {
    float maxDistance = 0;
    for (Ligament ligament : ligaments) {
      maxDistance += ligament.getSize();
    }
    return maxDistance;
  }
  
  public void setAngles(float[] angles) {
    for (int i = 0; i < angles.length; i++) {
      ligaments.get(i).setAngle(angles[i]);
    }
  }
}
