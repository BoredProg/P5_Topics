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

public class P5_211_Arcs_Base_04 extends PApplet {

// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 17-7: Boxes along a curve 

PFont f;

// The radius of a circle
float r = 100;

// The width and height of the boxes
float w = 40;
float h = 40;

public void setup() {
  size(320,320);
  smooth();
}

public void draw() {
  background(255);
  
  // Start in the center and draw the circle
  translate(width/2, height/2);
  noFill();
  stroke(0);
  // Our curve is a circle with radius r in the center of the window.
  ellipse(0, 0, r*2, r*2); 
  // 10 boxes along the curve
  int totalBoxes = 10;
  // We must keep track of our position along the curve
  float arclength = 0;
  // For every box
  for (int i = 0; i < totalBoxes; i ++ ) {
    // Each box is centered so we move half the width
    arclength += w/2; 
    
    // Angle in radians is the arclength divided by the radius
    float theta = arclength / r;
    
    pushMatrix();
    // Polar to cartesian coordinate conversion
    translate(r*cos(theta) , r*sin(theta));
    // Rotate the box
    rotate(theta);
    
    // Display the box
    fill(0, 100);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popMatrix();
    
    // Move halfway again
    arclength += w/2;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Arcs_Base_04" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
