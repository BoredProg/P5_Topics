import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

/*

Spherical Coordinates Tutorial File
April, 2008
blprnt@blprnt.com

*/


import processing.opengl.*;
import java.util.*;
PeasyCam cam;

Sphere mySphere; //This is our main sphere object.

void setup() {
  //code here is executed once, when the app initializes
  size(1280,720,P3D);
  smooth(32);
  background(255);
  
  //cam = new PeasyCam(this, 100);
  
  //create an instance of the Sphere Class
  mySphere = new Sphere();
  mySphere.xPos = width / 2;
  mySphere.yPos = height / 2;
  mySphere.zPos = 450;
  
  mySphere.init();
};

void draw() {
  background(255);
  
  mySphere.addSphereItem();
  
  //code here is executed once per frame 
  pushMatrix();
  //translate(0, 0 , 0);
  //rotateY(frameCount / 100f);
  
  
  mySphere.update();
  mySphere.render();
  
  popMatrix();
};

void keyPressed() {
  mySphere.addSphereItem();
};

void mousePressed() {
  mySphere.addSphereItem();
};
