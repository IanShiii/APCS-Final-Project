import java.util.function.Supplier;

public class Ligament {
    private Supplier<Float> startX;
    private Supplier<Float> startY;
    private float angle;
    private float size;

    public Ligament(Supplier<Float> startX, Supplier<Float> startY, float angle, float size) {
        this.startX = startX;
        this.startY = startY;
        this.angle = angle;
        this.size = size;
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

    public float getSize() {
        return size;
    }

    public void setAngle(float angle) {
        this.angle = angle;
    }

    public void setSize(float size) {
        this.size = size;
    }

    /**
     * calculate end positions
     */

    public float calculateEndX() {
        return startX.get() + (float)Math.cos(angle) * size;
    }

    public float calculateEndY() {
        return startY.get() + (float)Math.sin(angle) * size;
    }

    public void show() {
        float endX = calculateEndX();
        float endY = calculateEndY();
        strokeWeight(13);
        line((float)startX.get(), (float)startY.get(), endX, endY);
    }
    
    public void showRadius() {
      strokeWeight(1);
      noFill();
      ellipse(startX.get(), startY.get(), size*2, size*2);
    }
}
