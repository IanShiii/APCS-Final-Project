import java.util.function.Supplier;

public class Ligament {
    private Supplier<Float> startX;
    private Supplier<Float> startY;
    private float angle;
    private float angularVelocity;
    private float angularAcceleration;
    private Supplier<Integer> size;
    private color ligamentColor;

    public Ligament(Supplier<Float> startX, Supplier<Float> startY, Supplier<Integer> size) {
        this.startX = startX;
        this.startY = startY;
        this.angle = 0;
        this.size = size;
        this.ligamentColor = color(0, 0, 0);
        
        // for PID control
        this.angularVelocity = 0;
        this.angularAcceleration = 0;
    }

    /**
     * getters and setters
     */

    public float getStartX() {
        return startX.get();
    }

    public float getStartY() {
        return startY.get();
    }

    public float getAngle() {
        return angle;
    }
    
    public float getVelocity() {
      return angularVelocity;
    }

    public int getSize() {
        return size.get();
    }

    public void setAngle(float angle) {
        this.angle = angle;
    }
    
    public void setColor(color ligamentColor) {
      this.ligamentColor = ligamentColor;
    }

    /**
     * calculate end positions
     */

    public float calculateEndX() {
        return startX.get() + (float)Math.cos(angle) * size.get();
    }

    public float calculateEndY() {
        return startY.get() + (float)Math.sin(angle) * size.get();
    }
    
    private float calculateTorqueByGravity() {
      float torque = (float)(size.get() * Math.cos(angle) / 2);
      torque /= 2; // make gravity weaker
      return torque;
    }
    
    public void applyTorque(float torque) {
      float totalTorque = calculateTorqueByGravity() + torque;
      float momentOfInertia = (float)((float)1 / 12 * size.get() * Math.pow(size.get(), 2));
      angularAcceleration = totalTorque / momentOfInertia;
    }
    
    private void applyFriction() {
      if (angularVelocity < 0) {
        angularVelocity += .000005;
        if (angularVelocity > 0) {
          angularVelocity = 0;
        }
      }
      if (angularVelocity > 0) {
        angularVelocity -= .000005;
        if (angularVelocity < 0) {
          angularVelocity = 0;
        }
      }
    }
    
    private void updateKinematics() {
      angle += angularVelocity;
      angularVelocity += angularAcceleration;
      applyFriction();
      
      angle = angle % (2*PI);
    }
    
    public float findShortestAngleDifference(Ligament other) {
      float difference = (other.getAngle() - this.getAngle()) % 360;
      if (difference < -180) {
        return difference + 360;
      }
      else if (difference > 179) {
        return difference - 360;
      }
      else {
        return difference;
      }
    }

    public void show() {
      updateKinematics();
      float endX = calculateEndX();
      float endY = calculateEndY();
      strokeWeight(11);
      stroke(ligamentColor);
      line((float)startX.get(), (float)startY.get(), endX, endY);
    }
    
    public void showRadius() {
      strokeWeight(1);
      noFill();
      ellipse(startX.get(), startY.get(), size.get()*2, size.get()*2);
    }
}
