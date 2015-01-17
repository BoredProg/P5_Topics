/**
CubeString.pde
Sebastien Parodi


drag mouse to rotate
right-click to generate next pattern
*/
import processing.opengl.*;

float rotx=0f;
float roty=0f;
int currentSeed = 0;
float lorotz, hirotz;
float loroty, hiroty;
float dstep;

void setup() {
  size(1280,1020,OPENGL);
    hint(ENABLE_OPENGL_4X_SMOOTH);
  fill(255);
  stroke(0);
}

void draw() {
  randomSeed(currentSeed);
  float burnone = random(1f);
  lorotz = random(-0.5, 0.5);
  hirotz = random(-0.5, 0.5);
  loroty = random(-0.5, 0.5);
  hiroty = random(-0.5, 0.5);
  dstep = random(0.01, 0.10);
  background(150);
  translate(width/2f, height/2f, -200f);
  rotateX(rotx+=0.013);
  rotateY(roty+=0.017);
  lights();
  for (int d=0; d<1000; d++) {
    translate(d*dstep,0,0);
    rotateZ( random(1f) < 0.5 ? lorotz : hirotz );
    rotateY( random(1f) < 0.5 ? loroty : hiroty );
    fill(255);
    box(20);
    strokeWeight(5);
    stroke(0,20);
    line(0,0,0, d*dstep,0,0);
    strokeWeight(1);
  }
}

void mousePressed() {
  if (mouseButton==RIGHT) {
    rotx = 0f;
    roty = 0f;
    currentSeed++;
  }
}

void mouseDragged() {
  float dx = mouseX-pmouseX;
  float dy = mouseY-pmouseY;
  rotx += -dy * 0.01;
  roty += dx * 0.01;
}

