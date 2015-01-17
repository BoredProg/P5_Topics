import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_Arcs_Base_02 extends PApplet {

/*
//arc
void setup() {
  size(500, 500);
  smooth();
}
 
void draw() {
  background(255);
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  // fill(random(100,360),100,80,50);
  arcer(width / 2, height / 2, 400);
  noLoop();
}
 
void arcer( float x, float y, float radius) {
  for (int i = 0; i < 100;i++) {
    float beginAngle = random(TWO_PI);
    float endAngle = beginAngle + radians(15);
    float alpha = random(5, 40);
    arc(x, y, radius, radius, beginAngle, endAngle);
    fill(random(100, 260), 100, 80, alpha);
  }
}
 
 
//arc more parameters
void setup() {
  size (500, 500);
  smooth();
  colorMode(HSB, 360, 100, 100, 100);
}
 
void draw() {
  background(0);
  stroke(255);
  arcer(width / 2, height / 2, 300, 200, radians(random(40)), 100);
  noLoop();
}
 
void arcer(float x, float y, float radius, float radiusVariation, float maxAngle, int numAngles
) {
  for (int i = 0; i < numAngles;i++) {
    float beginAngle = random(TWO_PI);
    float endAngle = beginAngle + random(maxAngle);
    float arcRadius = radius + random(-radiusVariation, radiusVariation);
    float alpha = random(5, 40);
    arc(x, y, arcRadius, arcRadius, beginAngle, endAngle);
    fill(random(200, 360), 100, 80, alpha);
  }
}
 
*/
 
//arc modulation sinus
public void setup() {
  size(500, 500);
  smooth();
}
 
public void draw() {
  background(255);
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  for (int i = 5; i > 0; i--) {
    float radius = i * 90;
    arcer(width / 2, height / 2, radius, 30, radians(15), 200);
  }
  noLoop();
}
 
public void arcer( float x, float y, float radius, float radiusVariation, float maxAngle, int numAngles) {
  float phase = PI;
  for (int i = 0; i < numAngles;i++) {
    float beginAngle = random(TWO_PI);
    float endAngle = beginAngle + random(maxAngle);
 
    float sinVal = sin(beginAngle * 10 + phase);
    float arcRadius = radius + sinVal * radiusVariation;
    float alpha = random(5, 30);
 
    arc(x, y, arcRadius, arcRadius, beginAngle, endAngle);
    fill(random(120, 360), 100, 80, alpha);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Arcs_Base_02" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
