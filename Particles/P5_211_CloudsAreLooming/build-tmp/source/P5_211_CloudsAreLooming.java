import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 
import toxi.geom.*; 
import java.util.*; 
import controlP5.*; 

import peasy.org.apache.commons.math.geometry.*; 
import processing.core.*; 
import toxi.math.conversion.*; 
import toxi.geom.*; 
import toxi.math.*; 
import processing.xml.*; 
import toxi.geom.util.*; 
import controlP5.*; 
import peasy.org.apache.commons.math.*; 
import toxi.util.datatypes.*; 
import peasy.*; 
import toxi.math.waves.*; 
import toxi.math.noise.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_CloudsAreLooming extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/6753*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

//http://www.openprocessing.org/sketch/6753




Vec3D globalOffset, avg, cameraCenter;
public float neighborhood, viscosity, speed, turbulence, cameraRate, rebirthRadius, spread, independence, dofRatio;
public int n, rebirth;
public boolean averageRebirth, paused;
Vector particles;

Plane focalPlane;

PeasyCam cam;

boolean recording;

public void setup() {
  size(1280, 720, P3D);
  cam = new PeasyCam(this, 1600);
  
  setParameters();
  makeControls();
  
  cameraCenter = new Vec3D();
  avg = new Vec3D();
  globalOffset = new Vec3D(0, 1.f / 3, 2.f / 3);
  
  particles = new Vector();
  for(int i = 0; i < n; i++)
    particles.add(new Particle());
}

public void draw() {  
  avg = new Vec3D();
  for(int i = 0; i < particles.size(); i++) {
    Particle cur = ((Particle) particles.get(i));
    avg.addSelf(cur.position);
  }
  avg.scaleSelf(1.f / particles.size());
  
  cameraCenter.scaleSelf(1 - cameraRate);
  cameraCenter.addSelf(avg.scale(cameraRate));
  
  translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);
  
  float[] camPosition = cam.getPosition();
  focalPlane = new Plane(avg, new Vec3D(camPosition[0], camPosition[1], camPosition[2]));

  background(0);
  noFill();
  hint(DISABLE_DEPTH_TEST);
  for(int i = 0; i < particles.size(); i++) {
    Particle cur = ((Particle) particles.get(i));
    if(!paused)
      cur.update();
    cur.draw();
  }
  
  for(int i = 0; i < rebirth; i++)
    randomParticle().resetPosition();
  
  if(particles.size() > n)
    particles.setSize(n);
  while(particles.size() < n)
    particles.add(new Particle());
    
  globalOffset.addSelf(
    turbulence / neighborhood,
    turbulence / neighborhood,
    turbulence / neighborhood);
}

public Particle randomParticle() {
  return ((Particle) particles.get((int) random(particles.size())));
}

public void keyPressed() {
  if(key == 'p')
    paused = !paused;
}


public ControlP5 control;
public ControlWindow w;

public void setParameters() {
  n = 10000;
  dofRatio = 50;
  neighborhood = 700;
  speed = 24;
  viscosity = .1f;
  spread = 100;
  independence = .15f;
  rebirth = 0;
  rebirthRadius = 250;
  turbulence = 1.3f;
  cameraRate = .1f;
  averageRebirth = false;
}

public void makeControls() {
  control = new ControlP5(this);
  
  w = control.addControlWindow("controlWindow", 10, 10, 350, 140);
  w.hideCoordinates();
  w.setTitle("Flocking Parameters");
  
  int y = 0;
  control.addSlider("n", 1, 200000, n, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("dofRatio", 1, 200, dofRatio, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("neighborhood", 1, width * 2, neighborhood, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("speed", 0, 100, speed, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("viscosity", 0, 1, viscosity, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("spread", 50, 200, spread, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("independence", 0, 1, independence, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("rebirth", 0, 100, rebirth, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("rebirthRadius", 1, width, rebirthRadius, 10, y += 10, 256, 9).setWindow(w);
  control.addSlider("turbulence", 0, 4, turbulence, 10, y += 10, 256, 9).setWindow(w);
  control.addToggle("paused", false, 10, y += 11, 9, 9).setWindow(w);
  control.setAutoInitialization(true);
}

Vec3D centeringForce = new Vec3D();

class Particle {
  Vec3D position, velocity, force;
  Vec3D localOffset;
  Particle() {
    resetPosition();
    velocity = new Vec3D();
    force = new Vec3D();
    localOffset = Vec3D.randomVector();
  }
  public void resetPosition() {
    position = Vec3D.randomVector();
    position.scaleSelf(random(rebirthRadius));
    if(particles.size() == 0)
      position.addSelf(avg);
    else
      position.addSelf(randomParticle().position);
  }
  public void draw() {
    float distanceToFocalPlane = focalPlane.getDistanceToPoint(position);
    distanceToFocalPlane *= 1 / dofRatio;
    distanceToFocalPlane = constrain(distanceToFocalPlane, 1, 15);
    strokeWeight(distanceToFocalPlane);
    stroke(255, constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 1, 255));
    point(position.x, position.y, position.z);
  }
  public void applyFlockingForce() {
    force.addSelf(
      noise(
        position.x / neighborhood + globalOffset.x + localOffset.x * independence,
        position.y / neighborhood,
        position.z / neighborhood)
        - .5f,
      noise(
        position.x / neighborhood,
        position.y / neighborhood + globalOffset.y  + localOffset.y * independence,
        position.z / neighborhood)
        - .5f,
      noise(
        position.x / neighborhood,
        position.y / neighborhood,
        position.z / neighborhood + globalOffset.z + localOffset.z * independence)
        - .5f);
  }
  public void applyViscosityForce() {
    force.addSelf(velocity.scale(-viscosity));
  }
  public void applyCenteringForce() {
    centeringForce.set(position);
    centeringForce.subSelf(avg);
    float distanceToCenter = centeringForce.magnitude();
    centeringForce.normalize();
    centeringForce.scaleSelf(-distanceToCenter / (spread * spread));
    force.addSelf(centeringForce);
  }
  public void update() {
    force.clear();
    applyFlockingForce();
    applyViscosityForce();
    applyCenteringForce();
    velocity.addSelf(force); // mass = 1
    position.addSelf(velocity.scale(speed));
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_CloudsAreLooming" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
