import java.util.LinkedList;
import java.util.function.Supplier;

public class Arm {
  private LinkedList<Ligament> ligaments;
  private float x;
  private float y;
  private boolean showRadii;
  private boolean faded;

  public Arm(float x, float y) {
    ligaments = new LinkedList<Ligament>();
    this.x = x;
    this.y = y;
    this.showRadii = false;
    this.faded = false;
  }

  public void addLigament(Slider slider) {
    if (ligaments.size() == 0) {
      Supplier<Float> startX = () -> x;
      Supplier<Float> startY = () -> y;
      Supplier<Integer> size = () -> slider.getValue();
      Ligament newLigament = new Ligament(startX, startY, 0, size);
      ligaments.add(newLigament);
    } else {
      Ligament lastLigament = ligaments.getLast();
      Supplier<Float> startX = () -> lastLigament.calculateEndX();
      Supplier<Float> startY = () -> lastLigament.calculateEndY();
      Supplier<Integer> size = () -> slider.getValue();
      Ligament newLigament = new Ligament(startX, startY, 0, size);
      ligaments.add(newLigament);
    }
  }
  
  public void removeLigament() {
    if (ligaments.isEmpty()) {
      return;
    }
    
    ligaments.remove(ligaments.size() - 1);
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
  
  public void fade() {
    this.faded = true;
  }
  
  public void unFade() {
    this.faded = false;
  }
  
  public void show() {
    for (Ligament ligament : ligaments) {
      if (!faded) {
        ligament.setColor(color(0, 0, 0));
      }
      else {
        ligament.setColor(color(0, 0, 0, 100));
      }
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
