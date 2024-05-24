import java.util.function.Supplier;

public class Ligament {
    private Supplier<Double> startX;
    private Supplier<Double> startY;
    private double angle;
    private double length;

    public Ligament(Supplier<Double> startX, Supplier<Double> startY, double angle, double length) {
        this.startX = startX;
        this.startY = startY;
        this.angle = angle;
        this.length = length;
    }

    /**
     * getters and setters
     */

    public double getStartX() {
        return startX.get();
    }

    public double getStartY() {
        return startY.get();
    }

    public double getAngle() {
        return angle;
    }

    public double getLength() {
        return length;
    }

    public void setAngle(double angle) {
        this.angle = angle;
    }

    public void setLength(double length) {
        this.length = length;
    }

    /**
     * calculate end positions
     */

    public double calculateEndX() {
        return startX.get() + Math.cos(angle) * length;
    }

    public double calculateEndY() {
        return startY.get() + Math.sin(angle) * length;
    }

    public show() {
        double endX = calculateEndX();
        double endY = calculateEndY();
        strokeWeight(20);
        line(startX.get(), startY.get(), endX, endY);
    }
}