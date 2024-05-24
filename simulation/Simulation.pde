Arm arm;

void setup() {
  size(1000,550);
  arm = new Arm(width / 2, height / 2);
  arm.addLigament(300);
}

void draw() {
  background(173, 216, 230);
  arm.show();
}
