Arm arm;

void setup() {
  size(1000,550);
  arm = new Arm(width / 2, height / 2);
  arm.addLigament(100);
  arm.addLigament(60);
  arm.addLigament(50);
  arm.setShowRadii(true);
}

void draw() {
  background(173, 216, 230);
  float[] angles = IKCalculations.calculateAngles(arm.getLigamentLengths(), new PVector(mouseX - width/2, mouseY - height/2), arm.getMaxDistance());
  textSize(50);
  for (int i = 0; i < angles.length; i++) {
    text(angles[i], 30, 50*(i+1));
  }
  arm.setAngles(angles);
  arm.show();
}
