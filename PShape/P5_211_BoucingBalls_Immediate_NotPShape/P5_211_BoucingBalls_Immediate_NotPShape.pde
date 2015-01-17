/** 
 * Bouncing Spheres (v2.0)
 * by  JColosi (2014/Jan)
 * mod GoToLoop
 *
 * forum.processing.org/two/discussion/2675/
 * best-graphics-card-for-processing-development
 * 
 */
 
import java.awt.Color;
 
interface Config {
  int BALLS = 100;
  int DETAIL = 64;
  boolean WIREFRAME = true;
}
 
PGraphics pg;
boolean go = true;
boolean buffer = true;
 
//final ArrayList<Ball> balls = new ArrayList();
final Ball[] balls = new Ball[Config.BALLS];
 
void setup() {
  size(1024, 1024, P2D);
 
  pg = createGraphics(width, height, P3D);
 
  pg.beginDraw();
  pg.colorMode(RGB, 0xff);
  pg.smooth(8);
  pg.endDraw();
 
  for (int i = 0; i != Config.BALLS; i++) {
    final Ball ball = new Ball();
 
    ball.setPosition(0, width);
    ball.setPositionChange(-20, 20);
    ball.setRotation(0, .1f);
    ball.setRotationChange(-.1f, .1f);
    ball.lowerBound = new Tuple(0, 0, -1000);
    ball.upperBound = new Tuple(width, height, 0);
    ball.colour = new Color(random(1), random(1), random(1));
    ball.size = 100;
 
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
 
  if (Config.WIREFRAME)  pg.stroke(0xff, 0x80);
  else pg.noStroke();
 
  pg.background(0);
 
  for (Ball ball: balls) {
    ball.move();
    ball.bounce();
 
    pg.fill(ball.colour.getRGB());
    pg.sphereDetail(Config.DETAIL);
 
    pg.pushMatrix();
    pg.translate(ball.p.x, ball.p.y, ball.p.z);
    pg.rotateX(ball.r.x);
    pg.rotateY(ball.r.y);
    pg.rotateZ(ball.r.z);
    pg.sphere(ball.size);
    pg.popMatrix();
  }
 
  pg.lights();
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
  Tuple p, dp, r, dr, lowerBound, upperBound;
  Color colour;
  short size;
 
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
}
