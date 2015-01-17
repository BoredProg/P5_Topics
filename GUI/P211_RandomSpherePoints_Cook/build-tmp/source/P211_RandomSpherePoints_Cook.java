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

public class P211_RandomSpherePoints_Cook extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/69005*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

//-----------------------------------------------------------------------------
// sketch:  PG_RandomSpherePoints_Cook.pde
// create random points on a sphere surface
// version: v1.0  2012-09-07   initial version  
//          v1.1  2014-04-14   usage of class   
//-----------------------------------------------------------------------------
/** 
 Cook (1957) extended a method of von Neumann (1951) to give a simple method 
 of picking points uniformly distributed on the surface of a unit sphere. <bs>

 Pick four numbers a,b,c, and d from a uniform distribution on (-1,1), 
 and reject pairs with k>=1 where k=a^2+b^2+c^2+d^2. 

 From the remaining points, the rules of quaternion transformation then imply 
 that the points with Cartesian coordinates
   x = 2*(b*d +a*c) / k
   y = 2*(c*d -a*b) / k
   z = (a^2 +d^2 -b^2 -c^2) / k
 have the desired distribution (Cook 1957, Marsaglia 1972). 
*/
//--------------------------------------------------------

int randomPoints = 80000;
float rotX, rotY = 0.0f;
randomSpherePoints rsp;

//--------------------------------------------------------
public void setup()
{
  size(512, 512, P3D);
  println (">>> PG_RandomSpherePoints_Cook v1.1 <<<");
  smooth();
  stroke(40, 166);
  strokeWeight(4.0f);
  rsp = new randomSpherePoints (randomPoints, round(width / 2.5f));
}
//--------------------------------------------------------
public void draw()
{
  background(222);
  translate(width*0.5f, height*0.5f);
  rotateX (rotX);
  rotateY (rotY);
  rsp.draw();

  if (mousePressed)
  {
     rotY += (pmouseX - mouseX) * -0.002f;
     rotX += (pmouseY - mouseY) * +0.002f;
     println (round(frameRate) + " fps");
  }
  rotY += 0.002f;
}
//--------------------------------------------------------
public void keyPressed()
{
  if (key == 's') save("RandomSpherePoints.png");
  if (key == ' ') rsp = new randomSpherePoints (randomPoints, round(width / 2.5f));
}


//==========================================================
// file:    RandomSpherePoints_Cook.pde
//          create random points on a sphere surface
// version: v1.0  2012-09-07   initial version  
//          v1.1  2014-04-14   source code embedded to class
// see  http://mathworld.wolfram.com/SpherePointPicking.html
//==========================================================
class randomSpherePoints
{
  int maxPoints = 0;
  PVector[] points;
  
  //--------------------------------------------------------
  // create random sphere points
  //--------------------------------------------------------
  randomSpherePoints (int pointCount, float sphereRadius)
  { 
    maxPoints = pointCount; 
    points = new PVector[pointCount];
    for (int ni=0; ni < maxPoints; ni++)
    points[ni] = randomSpherePoint (sphereRadius);
  }
 
  //--------------------------------------------------------
  // draw random sphere points  
  //--------------------------------------------------------
  public void draw()
  {  
    for (int ni=0; ni < maxPoints; ni++)
    point (points[ni].x, points[ni].y, points[ni].z);
  }

  //--------------------------------------------------------
  // return random sphere point using method of Cook/Neumann
  //--------------------------------------------------------
  public PVector randomSpherePoint (float sphereRadius)
  {
    float a=0, b=0, c=0, d=0, k=99;
    while (k >= 1.0f) 
    { 
      a = random (-1.0f, 1.0f);
      b = random (-1.0f, 1.0f);
      c = random (-1.0f, 1.0f);
      d = random (-1.0f, 1.0f);
      k = a*a +b*b +c*c +d*d;
    }
    k = k / sphereRadius;
    return new PVector 
      ( 2*(b*d + a*c) / k 
      , 2*(c*d - a*b) / k  
      , (a*a + d*d - b*b - c*c) / k);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P211_RandomSpherePoints_Cook" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
