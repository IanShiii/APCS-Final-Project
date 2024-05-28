Arm arm;
PVector simulationCenter;
PVector poleGlobal;
PVector pole;
ArrayList<Slider> sliders;

void setup() {
  size(1400,700);
  simulationCenter = new PVector(width / 4, height / 2);
  poleGlobal = new PVector(30,30);
  pole = poleGlobal.copy().sub(simulationCenter);
  arm = new Arm(simulationCenter.x, simulationCenter.y);
  sliders = new ArrayList<Slider>();
  
  sliders.add(new Slider("ligament 1", 30, 180, 30, 400));
  sliders.add(new Slider("ligament 2", 30, 180, 30, 400));
  sliders.add(new Slider("ligament 3", 30, 180, 30, 400));
  sliders.add(new Slider("ligament 4", 30, 180, 30, 400));
  for (Slider slider : sliders) {
    arm.addLigament(slider);
  }
  arm.setShowRadii(true);
}

void draw() {
  background(173, 216, 230);
  textSize(30);
  text("Hold left to activate arm. Hold Right to move pole", 40, height - 40);
  PVector mouse = new PVector(mouseX, mouseY).sub(simulationCenter);
  
  // sliders
  for (int i = 0; i < sliders.size(); i++) {
    Slider slider = sliders.get(i);
    slider.update();
    slider.show(910, 40 * (i + 1));
  }
  
  // show pole
  noFill();
  ellipse(poleGlobal.x, poleGlobal.y, 20, 20);
  textSize(15);
  text("pole", poleGlobal.x - 5, poleGlobal.y + 5);
  
  // arm and pole movements
  if (mousePressed && (mouseButton == LEFT)) {
    float[] angles = IKCalculations.calculateAngles(arm.getLigamentLengths(), mouse, arm.getMaxDistance(), pole);
    arm.setAngles(angles);
    //textSize(40);
    //for (int i = 0; i < angles.length; i++) {
    //  text(angles[i], 30, 40*(i+1));
    //}
  } else if (mousePressed && (mouseButton == RIGHT)) {
    poleGlobal = new PVector(mouseX, mouseY);
    pole = poleGlobal.copy().sub(simulationCenter);
  } 
  
  arm.show();
}
