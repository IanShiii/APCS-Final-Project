public class PIDController {
    private static final float DT = (float) 1 / 60;

    // Constants used by the PID controller
    private Supplier<Float> kP;
    private Supplier<Float> kI;
    private Supplier<Float> kD;

    private float integral;
    private float lastError;

    public PIDController(Supplier<Float> kP, Supplier<Float> kI, Supplier<Float> kD) {
        this.kP = kP;
        this.kI = kI;
        this.kD = kD;
        reset();
    }

    /**
     * Resets the integrator in the PIDController.
     */
    public void reset() {
        integral = 0;
    }

    public float calculate(float setpoint, float measurement) {
        float error = setpoint - measurement;
        
        // calculate P component
        float pOut = error * kP.get();

        // Calculate I Component
        if (kI.get() > 0) {
          integral += error * DT;
        }
        float iOut = integral * kI.get();

        // Calculate D Component
        float derivative = (error - lastError) / DT;
        lastError = error;
        float dOut = derivative * kD.get();
        
        textAlign(LEFT);
        text("pOut: " + pOut, 1050, 250);
        text("iOut: " + iOut, 1050, 300);
        text("dOut: " + dOut, 1050, 350);
        return pOut + iOut + dOut;
    }
    
    public float calculate(float error) {
        
        // calculate P component
        float pOut = error * kP.get();

        // Calculate I Component
        if (kI.get() > 0) {
          integral += error * DT;
        }
        float iOut = integral * kI.get();

        // Calculate D Component
        float derivative = (error - lastError) / DT;
        lastError = error;
        float dOut = derivative * kD.get();
        
        textAlign(LEFT);
        text("pOut: " + pOut, 1050, 250);
        text("iOut: " + iOut, 1050, 300);
        text("dOut: " + dOut, 1050, 350);
        return pOut + iOut + dOut;
    }
}
