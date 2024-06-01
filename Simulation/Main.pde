Arm IKArm;
Arm PIDTargetArm;
Arm PIDActualArm;

PVector simulationCenter;
PVector poleGlobal;
PVector pole;

ArrayList<Slider> ligamentSliders;
Slider PIDLigamentSlider;
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
  IKArm.showRadii();
  PIDTargetArm = new Arm(simulationCenter.x, simulationCenter.y);
  PIDTargetArm.fade();
  PIDTargetArm.hide();
  PIDActualArm = new Arm(simulationCenter.x, simulationCenter.y);
  PIDActualArm.hide();
  
  ligamentSliders = new ArrayList<Slider>();
  ligamentSliders.add(new Slider("ligament 1", 30, 120));
  ligamentSliders.add(new Slider("ligament 2", 30, 120));
  for (Slider slider : ligamentSliders) {
    IKArm.addLigament(slider);
  }
  
  PIDLigamentSlider = new Slider("Arm Length", 100, 400);
  PIDActualArm.addLigament(PIDLigamentSlider);
  PIDTargetArm.addLigament(PIDLigamentSlider);
  PIDLigamentSlider.hide();
  
  PIDSliders = new ArrayList<Slider>();
  PIDSliders.add(new Slider("kP", 0, 5).makeNotDiscrete());
  PIDSliders.add(new Slider("kI", 0, 5).makeNotDiscrete());
  PIDSliders.add(new Slider("kD", 0, 5).makeNotDiscrete());
  
  Procedure onAdd = () -> {
    if (ligamentSliders.size() < 6) {
      Slider slider = new Slider("ligament " + (ligamentSliders.size() + 1), 30, 120);
      ligamentSliders.add(slider);
      IKArm.addLigament(slider);
    }
  };
  addButton = new Button("+", 50, 50, onAdd);
  
  Procedure onRemove = () -> {
    if (ligamentSliders.size() > 1) {
      ligamentSliders.remove(ligamentSliders.size() - 1);
      IKArm.removeLigament();
    }
  };
  removeButton = new Button("-", 50, 50, onRemove);
  
  Procedure pidSwitch = () -> {
    if (isPIDOn) {
      IKArm.unhide();
      PIDActualArm.hide();
      PIDTargetArm.hide();
      PIDLigamentSlider.hide();
      for (Slider slider : ligamentSliders) {
        slider.unhide();
      }
      addButton.unhide();
      removeButton.unhide();
    }
    else {
      IKArm.hide();
      PIDActualArm.unhide();
      PIDTargetArm.unhide();
      for (Slider slider : ligamentSliders) {
        slider.hide();
      }
      PIDLigamentSlider.unhide();
      addButton.hide();
      removeButton.hide();
    }
    isPIDOn = !isPIDOn;
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
  
  for (int i = 0; i < PIDSliders.size(); i++) {
    Slider slider = PIDSliders.get(i);
    slider.update();
    slider.show(910, 460 + 40 * i);
  }
  
  PIDLigamentSlider.show(910, 40);
  
  // show pole
  noFill();
  ellipse(poleGlobal.x, poleGlobal.y, 20, 20);
  textSize(20);
  textAlign(CENTER);
  text("pole", poleGlobal.x, poleGlobal.y - 20);
  
  // arm and pole movements
  if (mousePressed && (mouseButton == LEFT)) {
    float[] IKArmAngles = IKCalculations.calculateAngles(IKArm.getLigamentLengths(), mouse, IKArm.getMaxDistance(), pole);
    IKArm.setAngles(IKArmAngles);
    float[] PIDTargetArmAngles = IKCalculations.calculateAngles(PIDTargetArm.getLigamentLengths(), mouse, PIDTargetArm.getMaxDistance(), pole);
    PIDTargetArm.setAngles(PIDTargetArmAngles);
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
  
  // update and show arms 
  PIDActualArm.show();
  PIDTargetArm.show();
  IKArm.show();
}
