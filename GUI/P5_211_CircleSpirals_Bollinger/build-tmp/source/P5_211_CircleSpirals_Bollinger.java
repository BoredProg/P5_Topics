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

public class P5_211_CircleSpirals_Bollinger extends PApplet {


// Portal
// Dave Bollinger
// http://www.davebollinger.com
// revised Feb 2007 for P5 0124 Beta

/** 
Every science fiction fan knows that opening a portal to another dimension<br>
requires some sort of incomprehensible spinning circle contraption, like this.<br>
<br>
Click to reset rings to new pattern.<br>
*/


Ring [] rings;
int nrings;
float rotx, roty;
float ringhue;

public void setup() {
  size(1280,720,P3D);
  smooth(32);
  
  nrings = 8;
  
  rings = new Ring[nrings];
  
  for (int i=0; i<nrings; i++)
  {
    rings[i] = new Ring((i+1)*50f, (i+1)*50f+45f);
  }
  reset();
  
  noStroke();
  colorMode(HSB);
}

public void reset() 
{
  for (int i=0; i<nrings; i++)
    rings[i].reset();
}

public void draw() 
{
  background(0);
  lights();
  translate(width/2f, height/2f, -500);
  
  //rotateX(rotx+=0.013);
  //rotateY(roty+=0.017);
  fill(color(ringhue, 192, 240));
  
  ringhue = (ringhue + 0.2f) % 256f;
  for (int i=0; i<nrings; i++)
  {
    
    // Fait qu'ils n'apparaissent pas au m\u00eame point de d\u00e9part.  
    rotateZ(i);
    rotateZ((frameCount /200f) + noise(i/ frameCount) * 50f);
    rings[i].draw();
  
  }
}

public void mousePressed() {
  reset();
}

class Ring {
  static final int toopie = 64; // trig table resolution
  
  float radius1, radius2, thickness;
  float theta, dtheta;
  
  float rotx, roty, rotz;
  float [] r1cos, r1sin;
  float [] r2cos, r2sin;
  
  
  
  public Ring(float radius1, float radius2) 
  {
    this.radius1 = radius1;
    this.radius2 = radius2;
    
    r1cos = new float[toopie+1];
    r1sin = new float[toopie+1];
    
    r2cos = new float[toopie+1];
    r2sin = new float[toopie+1];
    
    int startDegree = 45;
    
    for (int i = startDegree; i<=toopie; i++) // divide toopie by anything to get a incomplete circle
    {
      float theta = (float)(i) / (float)(toopie) * TWO_PI;
      
      r1cos[i] = radius1 * cos(theta);
      r1sin[i] = radius1 * sin(theta);
      
      r2cos[i] = radius2 * cos(theta);
      r2sin[i] = radius2 * sin(theta);
    }  
    thickness = 0f;
    //reset();
    
  }
  
  
  public void reset() 
  {
    //theta = random(TWO_PI);
    //dtheta = random(-0.1,0.1);
    /*  
    rotx = random(TWO_PI);
    roty = random(TWO_PI);
    rotz = random(TWO_PI);
    */
  }    
  
  public void draw() 
  {
    thickness = mouseY; //frameCount / 10f;
    
    //fill(255,150);
    
    
    /*
    
    theta += dtheta;
    
    rotateY(theta);
    rotateX(rotx);
    rotateY(roty);  
    rotateZ(rotz);
    
    */ 
    
    
    // back edge    
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) 
    {
      vertex(r1cos[i], r1sin[i], thickness);
      vertex(r2cos[i], r2sin[i], thickness);
    }
    endShape();
    
    // front edge
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) 
    {
      vertex(r1cos[i], r1sin[i], -thickness);
      vertex(r2cos[i], r2sin[i], -thickness);
    }
    endShape();
    
    
    // outer rim
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) 
    {
      vertex(r2cos[i], r2sin[i], thickness);
      vertex(r2cos[i], r2sin[i], -thickness);
    }
    endShape();
    
    
    // inner rim
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) {
      vertex(r1cos[i], r1sin[i], thickness);
      vertex(r1cos[i], r1sin[i], -thickness);
    }
   endShape();
  }
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_CircleSpirals_Bollinger" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
