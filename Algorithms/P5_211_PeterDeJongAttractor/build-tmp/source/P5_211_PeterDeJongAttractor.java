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

public class P5_211_PeterDeJongAttractor extends PApplet {

// Peter de Jong
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// based on code by p. bourke
// http://astronomy.swin.edu.au/~pbourke/

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 1500;
float a, b, c, d;
float gs = 3.5f;
float gx = 0.5f;
float gy = 0.75f;
int fadebg;
int exposures;
int maxage = 128;  

int num = 0;
int maxnum = 40000;
TravelerHenon[] travelers = new TravelerHenon[maxnum];

// frame counter for animation
float time;

public void setup() {
  size(1500,1500,P3D);
  background(255);
  rectMode(CORNER);
  noStroke();

  // bourke constants
  a = 2.01f;
  b = -2.53f;
  c = 1.61f;
  d = -0.33f  ;
  
  // make some travelers
  for (int i=0;i<maxnum;i++) {
    travelers[i] = new TravelerHenon();
    num++;
  } 
}

public void draw() {
  for (int i=0;i<num;i++) {
    travelers[i].draw();
  }
  exposures+=num;
}

public void mousePressed() {
  // reset the image  
  reset();
}



public void reset() {
  background(255);
  exposures = 0;
  gs = 3.0f;
  gx = 0.5f;
  gy = 0.5f;
  a = random(-2.5f,2.5f);
  b = random(-2.5f,2.5f);
  c = random(-2.5f,2.5f);
  d = random(-2.5f,2.5f);
  
  for (int i=0;i<num;i++) {
    travelers[i].rebirth();
  }

}


class TravelerHenon {
  float x, y;
  float xn, yn;

  int age = 0;
  
  TravelerHenon() {
    // constructor
    x = random(-1.0f,1.0f);
    y = random(-1.0f,1.0f);
  }
  
  public void draw() {
      // move through time
      xn = sin(a*y) - cos(b*x);
      yn = sin(c*x) - cos(d*y);
      
      float d = sqrt((xn-x)*(xn-x) + (yn-y)*(yn-y));
      x = xn;
      y = yn;
      
      // render single transparent pixel
      stroke(0,5);
      point((x/gs+gx)*dim,(y/gs+gy)*dim);
      
      // age
      age++;
      if (age>maxage) {
        // begin anew
        rebirth();
      }
        
  }  
  
      
  
  public void rebirth() {
    x = random(0.0f,1.0f);
    y = random(-1.0f,1.0f);
    age = 0;
  }    
 
}    


// Peter de Jong
// j.tarbell   January, 2004
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_PeterDeJongAttractor" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
