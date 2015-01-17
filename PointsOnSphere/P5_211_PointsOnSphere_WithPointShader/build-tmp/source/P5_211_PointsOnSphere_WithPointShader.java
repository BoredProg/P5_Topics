import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.test.*; 
import peasy.org.apache.commons.math.*; 
import peasy.*; 
import peasy.org.apache.commons.math.geometry.*; 
import processing.opengl.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_PointsOnSphere_WithPointShader extends PApplet {










PeasyCam cam;
Sphere mySphere; //This is our main sphere object.

PShader pointShader;
PVector lightPos; 
PVector lightPosCamSpace;

////////////////////////////////////////////////////////////////////////
// Setup
////////////////////////////////////////////////////////////////////////
public void setup() 
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

public void draw() 
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

public void keyPressed() {
  for(int i = 0; i < 10; i++)
  {
    mySphere.addSphereItem();
  }
};

public void mousePressed() {
  mySphere.addSphereItem();
};
class Sphere {
  
  float xPos = 0;                   //X Position of the Sphere
  float yPos = 0;                   //Y Position of the Sphere
  float zPos = 0;                   //Z Position of the Sphere
  
  float radius = 50;                  //Radius of the Sphere
      
  ArrayList items = new ArrayList();  //List of all of the items contained in the Sphere
  
  public void Sphere()
  {
  }
    
    
  public void init() {
    //Empty, for now!
  };
  
  public void addSphereItem() {
    //Make a new SphereItem
    SphereItem si = new SphereItem();
    //Set the parent sphere
    si.parentSphere = this;
    //Set random values for the spherical coordinates
    si.theta = random(PI * 2);
    si.phi = random(PI * 2);
    //Add the new sphere item to the end of our ArrayList
    items.add(items.size(), si);
    si.init();
  };
  
  public void update() {
    
    for (int i = 0; i < items.size(); i ++) {
      SphereItem si = (SphereItem) items.get(i); // Cast the returned object to the SphereItem Class
      si.update();
    };
    
  };
  
  public void render() {
    //Move to the center point of the sphere
    translate(xPos, yPos, zPos);
    //Mark our position in 3d space
    
    /*    
    rotateX(frameCount / 100f);
    rotateY(frameCount / 100f);
    rotateZ(frameCount / 100f);
    */
    
    
    pushMatrix();
    //Render each SphereItem
    for (int i = 0; i < items.size(); i ++) {
      SphereItem si = (SphereItem) items.get(i);
      si.render();
    };
    //Go back to our original position in 3d space
    popMatrix();
  };
 
};
/*

SphereItem Class
blprnt@blprnt.com

*/


class SphereItem {
  
  Sphere parentSphere;
  
  //Spherical Coordinates
  float radius;
  float theta;
  float phi;
  
  //Speed properties
  float thetaSpeed = 0;
  float phiSpeed = 0;
  
  //Size
  float itemSize = 5;
  
  //Stray
  float stray;
  
  public void SphereItem() {
   
  };
  
  public void init() {
    itemSize = random(5);
    thetaSpeed = random(-0.01f, 0.01f);
    phiSpeed = random(-0.01f, 0.01f);
    stray = random(10,-10);
  };
  
  public void update() {
    theta += thetaSpeed;
    phi += phiSpeed;
  };
  
  public void render() {
    //Get the radius from the parent Sphere
    float r = parentSphere.radius + stray;
    //Convert spherical coordinates into Cartesian coordinates
    float x = cos(theta) * sin(phi) * r;
    float y = sin(theta) * sin(phi) * r;
    float z = cos(phi) * r;
    
    shader(pointShader, POINTS);
    strokeWeight(itemSize);  
    point(x,y,z);
    
    /*
    //Mark our 3d space
    pushMatrix();
    //Move to the position of this item
    translate(x,y,z);
    /*
    //Set the fill colour
    fill(0,0,0,150);
    noStroke();
    //Draw a circle
    //ellipse(0,0,itemSize,itemSize);
    */
    
    /*
    noFill();
    sphereDetail(16);
    stroke(0,100);
    sphere(itemSize);
    //Go back to our position in 3d space
    popMatrix();
   */
  };
  
};
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_PointsOnSphere_WithPointShader" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
