PGraphics pg;

void setup() {
  size(600,400,P2D);
  smooth();
  background(255);
  frame.setResizable(true);

  background(0);
}
void draw() {
  background(0);
  pg = createGraphics(width, height, P3D);
  pg.beginDraw();
  pg.noStroke();
  pg.lights();
  pg.translate(width/2,height/2);
  pg.rotateX(frameCount/100.0);
  pg.fill(255,0,0,50);
  pg.box(140);
  pg.endDraw();

  fill(255);
  ellipse(width/2+sin(frameCount/40.0)*width/2,height/2,200,200);

  image(pg,0,0);
}
