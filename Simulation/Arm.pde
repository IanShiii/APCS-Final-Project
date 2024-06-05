import java.util.LinkedList;
import java.util.function.Supplier;

public class Arm {
  private LinkedList<Ligament> ligaments;
  private float x;
  private float y;
  private boolean showRadii;
  private boolean hidden;
  private boolean faded;

  public Arm(float x, float y) {
    ligaments = new LinkedList<Ligament>();
    this.x = x;
    this.y = y;
    this.showRadii = false;
    this.hidden = false;
  }

  public void addLigament(Slider slider) {
    if (ligaments.size() == 0) {
      Supplier<Float> startX = () -> x;
      Supplier<Float> startY = () -> y;
      Supplier<Integer> size = () -> (int)slider.getValue();
      Ligament newLigament = new Ligament(startX, startY, size);
      ligaments.add(newLigament);
    } else {
      Ligament lastLigament = ligaments.getLast();
      Supplier<Float> startX = () -> lastLigament.calculateEndX();
      Supplier<Float> startY = () -> lastLigament.calculateEndY();
      Supplier<Integer> size = () -> (int)slider.getValue();
      Ligament newLigament = new Ligament(startX, startY, size);
      ligaments.add(newLigament);
    }
  }
  
  public Ligament getLigament(int index) {
    return ligaments.get(index);
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
  
  public void showRadii() {
    this.showRadii = true;
  }
  
  public void hideRadii() {
    this.showRadii = false;
  }
  
  public void fade() {
    this.faded = true;
  }
  
  public void unFade() {
    this.faded = false;
  }
  
  public void hide() {
    this.hidden = true;
  }
  
  public void unhide() {
    this.hidden = false;
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
  
  public void show() {
    if (faded) {
      for (Ligament ligament : ligaments) {
        ligament.setColor(color(0, 0, 0, 100));
      }
    }
    else {
      for (Ligament ligament : ligaments) {
        ligament.setColor(color(0, 0, 0, 0));
      }
    }
    if (!hidden) {
      for (Ligament ligament : ligaments) {
        ligament.show();
        if (showRadii) {
          ligament.showRadius();
        }
      }
    }
  }
}
