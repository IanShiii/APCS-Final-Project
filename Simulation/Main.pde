Arm IKArm;
Arm PIDTargetArm;
Arm PIDActualArm;

PIDController controller;

PVector simulationCenter;
PVector poleGlobal;
PVector pole;

ArrayList<Slider> ligamentSliders;
Slider PIDLigamentSlider;
ArrayList<Slider> PIDSliders;

Button addButton;
Button removeButton;
Button PIDSwitchButton;

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
  PIDSliders.add(new Slider("kP", 0, 8).makeNotDiscrete());
  PIDSliders.add(new Slider("kI", 0, 2).makeNotDiscrete());
  PIDSliders.add(new Slider("kD", 0, 8).makeNotDiscrete());
  
  controller = new PIDController(
    () -> PIDSliders.get(0).getValue(),
    () -> PIDSliders.get(1).getValue(),
    () -> PIDSliders.get(2).getValue()
   );
    
  
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
  PIDSwitchButton = new Button("PID: " + (isPIDOn ? "On" : "Off"), 100, 50, pidSwitch);
  
}

void draw() {
  background(173, 216, 230);
  PVector mouse = new PVector(mouseX, mouseY).sub(simulationCenter);
  
  // instructions
  textSize(30);
  textAlign(LEFT);
  if (isPIDOn) {
    text("Hold left to move target.", 40, height - 40);
  }
  else {
    text("Hold left to activate arm. Hold Right to move pole", 40, height - 40);
  }
  
  // sliders
  for (int i = 0; i < ligamentSliders.size(); i++) {
    Slider slider = ligamentSliders.get(i);
    slider.show(910, 40 * (i + 1));
  }
  
  for (int i = 0; i < PIDSliders.size(); i++) {
    Slider slider = PIDSliders.get(i);
    slider.show(910, 460 + 40 * i);
  }
  
  PIDLigamentSlider.show(910, 40);
  
  // show pole
  if (!isPIDOn) {
    noFill();
    ellipse(poleGlobal.x, poleGlobal.y, 20, 20);
    textSize(20);
    textAlign(CENTER);
    text("pole", poleGlobal.x, poleGlobal.y - 20);
  }
  
  // arm and pole movements
  if (!isMouseOverAnySliders() && !isMouseOverAnyButtons()) {
    if (mousePressed && (mouseButton == LEFT)) {
      float[] IKArmAngles = IKCalculations.calculateAngles(IKArm.getLigamentLengths(), mouse, IKArm.getMaxDistance(), pole);
      IKArm.setAngles(IKArmAngles);
      float[] PIDTargetArmAngles = IKCalculations.calculateAngles(PIDTargetArm.getLigamentLengths(), mouse, PIDTargetArm.getMaxDistance(), pole);
      PIDTargetArm.setAngles(PIDTargetArmAngles);
    } else if (!isPIDOn && mousePressed && (mouseButton == RIGHT)) {
      poleGlobal = new PVector(mouseX, mouseY);
      pole = poleGlobal.copy().sub(simulationCenter);
    } 
  }
  
  // buttons
  addButton.update();
  addButton.show(910 + (400 / 2) - 25 - 50, ligamentSliders.size() * 40 + 60);
  removeButton.update();
  removeButton.show(910 + (400 / 2) -25 + 50, ligamentSliders.size() * 40 + 60);
  PIDSwitchButton.setText("PID: " + (isPIDOn ? "On" : "Off"));
  PIDSwitchButton.update();
  PIDSwitchButton.show(width - 125, height - 75);
  
  // update PID Target Arm
  if (isPIDOn) {
    float output = 20 * controller.calculate(PIDTargetArm.getLigament(0).findShortestAngleDifference(PIDActualArm.getLigament(0)));
    PIDActualArm.getLigament(0).applyTorque(-output);
  }
  
  // update and show arms 
  PIDActualArm.show();
  PIDTargetArm.show();
  IKArm.show();
}

boolean isMouseOverAnySliders() {
  for (Slider slider : ligamentSliders) {
    if (slider.isMouseOverSlider()) {
      return true;
    }
  }
  for (Slider slider : PIDSliders) {
    if (slider.isMouseOverSlider()) {
      return true;
    }
  }
  if (PIDLigamentSlider.isMouseOverSlider()) {
    return true;
  }
  return false;
}

boolean isMouseOverAnyButtons() {
  if (!isPIDOn) {
    if (addButton.isMouseOverButton() || addButton.isClicked()) {
      return true;
    }
    if (removeButton.isMouseOverButton() || removeButton.isClicked()) {
      return true;
    }
  }
  if (PIDSwitchButton.isMouseOverButton() || PIDSwitchButton.isClicked()) {
    return true;
  }
  return false;
}
