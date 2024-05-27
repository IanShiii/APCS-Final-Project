Arm arm;
PVector screenCenter;
PVector poleGlobal;
PVector pole;

void setup() {
  size(1000,550);
  screenCenter = new PVector(width, height);
  poleGlobal = new PVector(30,30);
  pole = poleGlobal.copy().sub(screenCenter);
  arm = new Arm(screenCenter.x/2, screenCenter.y/2);
  arm.addLigament(40);
  arm.addLigament(30);
  arm.addLigament(90);
  arm.addLigament(50);
  arm.addLigament(20);
  arm.addLigament(100);
  arm.setShowRadii(true);
}

void draw() {
  background(173, 216, 230);
  textSize(30);
  text("Hold left to activate arm. Hold Right to move pole", 40, height - 40);
  PVector mouse = new PVector(mouseX, mouseY).sub(new PVector(width/2, height/2));
  
  // show pole
  textSize(15);
  ellipse(poleGlobal.x, poleGlobal.y, 20, 20);
  text("pole", poleGlobal.x - 5, poleGlobal.y + 5);
  
  if (mousePressed && (mouseButton == LEFT)) {
    float[] angles = IKCalculations.calculateAngles(arm.getLigamentLengths(), mouse, arm.getMaxDistance(), pole);
    arm.setAngles(angles);
    //textSize(40);
    //for (int i = 0; i < angles.length; i++) {
    //  text(angles[i], 30, 40*(i+1));
    //}
  } else if (mousePressed && (mouseButton == RIGHT)) {
    poleGlobal = new PVector(mouseX, mouseY);
    pole = poleGlobal.copy().sub(screenCenter);
  } 
  
  arm.show();
}
