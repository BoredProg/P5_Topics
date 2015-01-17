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

public class P211_PointsOnSphere_Fibonacci extends PApplet {

// Tiny_Fibonacci_Sphere.pde 5/2012
float rX=0.7f, rY, vX, vY, phi=(sqrt(5)+1)/2-1; // golden ratio
int p=2000;
public void setup()
{ size(600, 600, P3D);
  strokeWeight(3);  stroke(0);
}
public void draw()
{ background(255);        
  translate(width/2.0f, height/2.0f, 0);
  vX *= 0.95f;  vX += (mouseY-pmouseY)*1.6e-4f;  rX += vX;  rotateX(rX); 
  vY *= 0.95f;  vY += (mouseX-pmouseX)*1.6e-4f;  rY += vY;  rotateY(rY); 
  p += 1;
  for (int i = 1; i <= p; ++i,
    pushMatrix(),
    rotateY((phi*i -floor(phi*i))*2.0f*PI),
    rotateZ(asin(2*i/(float)p-1)),
    point(222.0f, 0),
    popMatrix() );
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P211_PointsOnSphere_Fibonacci" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
