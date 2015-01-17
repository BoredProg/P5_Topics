/** 
 * Bouncing Spheres (v2.0)
 * by  JColosi (2014/Jan)
 * mod GoToLoop
 * mod CodeAntiCode
 *
 * forum.processing.org/two/discussion/2675/
 * best-graphics-card-for-processing-development
 * 
 */
 
import java.awt.Color;
 
interface Config {
  int BALLS = 1000;
  int DETAIL = 64;
  int BALL_SIZE = 30;
  boolean WIREFRAME = false;
}
 
PGraphics pg;
boolean go = true;
boolean useDraw = true;
boolean useShape = true;
 
final Ball[] balls = new Ball[Config.BALLS];
 
void setup() 
{
  
  size(1280, 720, P2D);
  frame.setResizable(true);
  pg = createGraphics(width, height, P3D);
 
 
  pg.beginDraw();
  pg.smooth(32);
  pg.endDraw();
 
  for (int i = 0; i != Config.BALLS; i++) {
    final Ball ball = new Ball(pg, Config.BALL_SIZE, color(random(255), random(255), random(255)));
 
    ball.setPosition(0, width);
    ball.setPositionChange(-10, 10);
    ball.setRotation(0, .1f);
    ball.setRotationChange(-.1f, .1f);
    ball.lowerBound = new Tuple(0, 0, -1000);
    ball.upperBound = new Tuple(width, height, 0);
 
    balls[i] = ball;
  }
}
 
void keyPressed() {
}
 
void mouseReleased() {
  useShape = !useShape;
}
 
void draw() {
  println("enter draw");
  String msg = String.format("FPS: %2.2f     Shape: %s", frameRate, useShape);
  frame.setTitle(msg);
  if (!go)  return;
 
  drawBalls();
 
  if (useDraw)  image(pg, 0, 0);
}
 
void drawBalls() {
  pg.beginDraw();
 
  pg.background(0);
  pg.lights();
 
  for (Ball ball: balls) {
    ball.move();
    ball.bounce();
    if (useShape) ball.displayShape(pg);
    else ball.display(pg);
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
  PShape shape;
  Tuple p, dp, r, dr, lowerBound, upperBound;
  color colour;
  float size;
 
  Ball(PGraphics pg, float size, color colour) {
    this.size = size;
    this.colour = colour;
    this.shape = pg.createShape(SPHERE, size, Config.DETAIL);
    if (Config.WIREFRAME) shape.setStroke(color(0xff, 0x40));
    else shape.setStroke(false);        
    this.shape.setFill(colour);
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
    if (Config.WIREFRAME)  pg.stroke(0xff, 0x40);
    else pg.noStroke();
 
    pg.fill(colour);
    pg.sphereDetail(Config.DETAIL);
 
    pg.pushMatrix();
    pg.translate(p.x, p.y, p.z);
    pg.rotateX(r.x);
    pg.rotateY(r.y);
    pg.rotateZ(r.z);
    pg.sphere(size);
    pg.popMatrix();
  }
 
  void displayShape(PGraphics pg) {
    pg.pushMatrix();
    pg.translate(p.x, p.y, p.z);
    pg.rotateX(r.x);
    pg.rotateY(r.y);
    pg.rotateZ(r.z);
    pg.shape(shape);
    pg.popMatrix();
  }
}

