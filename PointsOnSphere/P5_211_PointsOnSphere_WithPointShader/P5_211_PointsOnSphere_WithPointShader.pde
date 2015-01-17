import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;


import processing.opengl.*;
import java.util.*;

PeasyCam cam;
Sphere mySphere; //This is our main sphere object.

PShader pointShader;
PVector lightPos; 
PVector lightPosCamSpace;

////////////////////////////////////////////////////////////////////////
// Setup
////////////////////////////////////////////////////////////////////////
void setup() 
{
  
  size(1280,720,P3D);
  smooth(32);
  background(255);
  
  //cam = new PeasyCam(this, 0);
  
  pointShader = loadShader("frag.glsl", "vert.glsl");
  strokeWeight(10);
  strokeCap(ROUND);
  stroke(120,120);
  
  lightPos = new PVector(0, 0, 300);
  lightPosCamSpace = new PVector();
  
  //create an instance of the Sphere Class
  mySphere = new Sphere();
  mySphere.xPos = width / 2;
  mySphere.yPos = height / 2;
  mySphere.zPos = 450;
  
  mySphere.init();
};


////////////////////////////////////////////////////////////////////////
// Draw
////////////////////////////////////////////////////////////////////////

void draw() 
{
  background(255);
  lights();
  
  println(mySphere.items.size() + " Billboards, FPS : " + frameRate);
  
  
  if(frameCount % 100 == 0)
  {
    mySphere.addSphereItem();
  }
  
  //code here is executed once per frame 
  pushMatrix();
  //translate(0, 0 , 0);
  //rotateY(frameCount / 100f);
  
  PMatrix modelview = getMatrix();
  modelview.mult(lightPos, lightPosCamSpace);
  pointShader.set("lightPos", lightPosCamSpace);
  
  
  mySphere.update();
  mySphere.render();
  
  popMatrix();
};

void keyPressed() {
  for(int i = 0; i < 10; i++)
  {
    mySphere.addSphereItem();
  }
};

void mousePressed() {
  mySphere.addSphereItem();
};
