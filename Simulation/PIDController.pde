public class PIDController {
    private static final float dt = 1;

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

    protected float calculate(float setpoint, float measurement) {
        float error = setpoint - measurement;
        
        // calculate P component
        float pOut = error * kP.get();

        // Calculate I Component
        integral += error * dt;
        float iOut = integral * kI.get();

        // Calculate D Component
        float derivative = (error - lastError) / dt;
        lastError = error;
        float dOut = derivative * kD.get();

        return pOut + iOut + dOut;
    }
}
