int BALLS = 200;
int DETAIL = 32;
boolean WIREFRAME = true;
 
PGraphics pg;
boolean go = true;
boolean buffer = true;
 
Ball[] balls = new Ball[BALLS];
 
void setup() {
  size(1920, 1200, P2D);
  frame.setResizable(true); 
 
 
  pg = createGraphics(width, height, P3D);
 
  pg.beginDraw();
  pg.smooth(8);
  pg.endDraw();
 
  for (int i = 0; i != BALLS; i++) {
    final Ball ball = new Ball(pg, 100, color(random(255), random(255), random(255)));
 
    ball.setPosition(0, width);
    ball.setPositionChange(-5, 5);
    ball.setRotation(0, .1f);
    ball.setRotationChange(-.1f, .1f);
    ball.lowerBound = new Tuple(0, 0, -1000);
    ball.upperBound = new Tuple(width, height, 0);
 
    balls[i] = ball;
  }
}
 
void keyPressed() {
  go = !go;
}
 
void mouseReleased() {
  buffer = !buffer;
}
 
void draw() {
  if (!go)  return;
 
  drawBalls();
 
  if (buffer)  image(pg, 0, 0);
 
  frame.setTitle("FPS " + nf(frameRate, 2, 2));
}
 
void drawBalls() {
  pg.beginDraw();
 
  pg.background(0);
  pg.lights();
 
  for (Ball ball: balls) {
    ball.move();
    ball.bounce();
    ball.display(pg);
  }
 
  pg.endDraw();
}
 
class Tuple {
  float x, y, z;
 
  Tuple(float px, float py, float pz) {
    x = px;
    y = py;
    z = pz;
  }
 
  Tuple(float min, float max) {
    this(random(min, max), random(min, max), random(min, max));
  }
}
 
class Ball {
  PShape sh;
  Tuple p, dp, r, dr, lowerBound, upperBound;
  color colour;
  float size;
 
  Ball(PGraphics pg, float s, color c) {
    size = s;
    colour = c;
    sh = pg.createShape(SPHERE, s, DETAIL);
    if (WIREFRAME) sh.setStroke(color(0xff, 0x80));
    else sh.setStroke(false);        
    sh.setFill(c);    
  }
 
  void setPosition(float min, float max) {
    this.p = new Tuple(min, max);
  }
 
  void setPositionChange(float min, float max) {
    this.dp = new Tuple(min, max);
  }
 
  void setRotation(float min, float max) {
    this.r = new Tuple(min, max);
  }
 
  void setRotationChange(float min, float max) {
    this.dr = new Tuple(min, max);
  }
 
  void move() {
    p.x += dp.x;
    p.y += dp.y;
    p.z += dp.z;
    r.x += dr.x;
    r.y += dr.y;
    r.z += dr.z;
  }
 
  void bounce() {
    if (p.x < lowerBound.x) {
      p.x = lowerBound.x;
      dp.x *= -1;
    }
    if (p.x > upperBound.x) {
      p.x = upperBound.x;
      dp.x *= -1;
    }
    if (p.y < lowerBound.y) {
      p.y = lowerBound.y;
      dp.y *= -1;
    }
    if (p.y > upperBound.y) {
      p.y = upperBound.y;
      dp.y *= -1;
    }
    if (p.z < lowerBound.z) {
      p.z = lowerBound.z;
      dp.z *= -1;
    }
    if (p.z > upperBound.z) {
      p.z = upperBound.z;
      dp.z *= -1;
    }
  }
 
  void display(PGraphics pg) {
    pg.pushMatrix();
    pg.translate(p.x, p.y, p.z);
    pg.rotateX(r.x);
    pg.rotateY(r.y);
    pg.rotateZ(r.z);
    pg.shape(sh);
    pg.popMatrix();   
  }    
}
