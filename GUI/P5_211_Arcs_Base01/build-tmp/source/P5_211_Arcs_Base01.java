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

public class P5_211_Arcs_Base01 extends PApplet {

int x, y;
int numberOfArcs = 10;
int step = 20;
float rotation = - (HALF_PI / 3);
int arcSize;
float start, stop;

public void setup()
{
  size(420, 420);
  background(240);
  noFill();
  stroke(127);
  ellipseMode(CENTER);
  strokeCap(PROJECT);
  smooth();
  noLoop();
}

public void draw()
{
  for (int i = 0; i < numberOfArcs; i++) {
    strokeWeight(i);
    arc(width / 2, height / 2, 200 + (step * i), 200 + (step * i), rotation * i, rotation * i + (TWO_PI - HALF_PI));
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Arcs_Base01" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
