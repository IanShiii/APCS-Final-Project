Arm IKArm;
Arm PIDArm;
PVector simulationCenter;
PVector poleGlobal;
PVector pole;
ArrayList<Slider> ligamentSliders;
ArrayList<Slider> PIDSliders;
Button addButton;
Button removeButton;
Button pidSwitchButton;
boolean isPIDOn;

void setup() {
  size(1400,700);
  simulationCenter = new PVector(width / 4, height / 2);
  
  poleGlobal = new PVector(30,40);
  pole = poleGlobal.copy().sub(simulationCenter);
  
  IKArm = new Arm(simulationCenter.x, simulationCenter.y);
  IKArm.setShowRadii(true);
  PIDArm = new Arm(simulationCenter.x, simulationCenter.y);
  
  ligamentSliders = new ArrayList<Slider>();
  ligamentSliders.add(new Slider("ligament 1", 30, 120, 30, 400));
  ligamentSliders.add(new Slider("ligament 2", 30, 120, 30, 400));
  for (Slider slider : ligamentSliders) {
    IKArm.addLigament(slider);
    PIDArm.addLigament(slider);
  }
  
  Procedure onAdd = () -> {
    if (ligamentSliders.size() < 6) {
      Slider slider = new Slider("ligament " + (ligamentSliders.size() + 1), 30, 120, 30, 400);
      ligamentSliders.add(slider);
      IKArm.addLigament(slider);
      PIDArm.addLigament(slider);
    }
  };
  addButton = new Button("+", 50, 50, onAdd);
  
  Procedure onRemove = () -> {
    if (ligamentSliders.size() > 1) {
      ligamentSliders.remove(ligamentSliders.size() - 1);
      IKArm.removeLigament();
      PIDArm.removeLigament();
    }
  };
  removeButton = new Button("-", 50, 50, onRemove);
  
  Procedure pidSwitch = () -> {
    if (isPIDOn) {
      IKArm.unFade();
    }
    else {
      IKArm.fade();
    }
  };
  pidSwitchButton = new Button("PID: " + (isPIDOn ? "On" : "Off"), 100, 50, pidSwitch);
  
}

void draw() {
  background(173, 216, 230);
  textSize(30);
  textAlign(LEFT);
  text("Hold left to activate arm. Hold Right to move pole", 40, height - 40);
  PVector mouse = new PVector(mouseX, mouseY).sub(simulationCenter);
  
  // sliders
  for (int i = 0; i < ligamentSliders.size(); i++) {
    Slider slider = ligamentSliders.get(i);
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
    float[] angles = IKCalculations.calculateAngles(IKArm.getLigamentLengths(), mouse, IKArm.getMaxDistance(), pole);
    IKArm.setAngles(angles);
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
  addButton.show(910 + (400 / 2) - 25 - 50, ligamentSliders.size() * 40 + 60);
  removeButton.update();
  removeButton.show(910 + (400 / 2) -25 + 50, ligamentSliders.size() * 40 + 60);
  pidSwitchButton.setText("PID: " + (isPIDOn ? "On" : "Off"));
  pidSwitchButton.update();
  pidSwitchButton.show(width - 125, height - 75);
  
  IKArm.show();
}
