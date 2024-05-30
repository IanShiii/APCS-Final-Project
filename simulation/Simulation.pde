Arm arm;
PVector simulationCenter;
PVector poleGlobal;
PVector pole;
ArrayList<Slider> sliders;
Button addButton;
Button removeButton;

void setup() {
  size(1400,700);
  simulationCenter = new PVector(width / 4, height / 2);
  
  poleGlobal = new PVector(30,40);
  pole = poleGlobal.copy().sub(simulationCenter);
  
  arm = new Arm(simulationCenter.x, simulationCenter.y);
  arm.setShowRadii(true);
  
  sliders = new ArrayList<Slider>();
  sliders.add(new Slider("ligament 1", 30, 120, 30, 400));
  arm.addLigament(sliders.get(0));
  
  Procedure onAdd = () -> {
    if (sliders.size() < 7) {
      Slider slider = new Slider("ligament " + (sliders.size() + 1), 30, 120, 30, 400);
      sliders.add(slider);
      arm.addLigament(slider);
    }
  };
  addButton = new Button("+", 50, 50, onAdd);
  
  Procedure onRemove = () -> {
    if (sliders.size() > 1) {
      sliders.remove(sliders.size() - 1);
      arm.removeLigament();
    }
  };
  removeButton = new Button("-", 50, 50, onRemove);
  
}

void draw() {
  background(173, 216, 230);
  textSize(30);
  textAlign(LEFT);
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
  textSize(20);
  textAlign(CENTER);
  text("pole", poleGlobal.x, poleGlobal.y - 20);
  
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
  
  // buttons
  addButton.update();
  addButton.show(910 + (400 / 2) - 25 - 50, sliders.size() * 40 + 60);
  removeButton.update();
  removeButton.show(910 + (400 / 2) -25 + 50, sliders.size() * 40 + 60);
  
  arm.show();
}
