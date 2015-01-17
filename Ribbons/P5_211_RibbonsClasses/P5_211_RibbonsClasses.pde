import processing.core.*; 
import processing.xml.*; 

import processing.dxf.*; 
import processing.pdf.*; 
import controlP5.*; 
import processing.opengl.*; 
import javax.media.opengl.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 











ArrayList colorMap;
ArrayList trails;

boolean mouseDown;

PGraphics canvas;
boolean saveNow = false;
boolean saveDXF = false;
PImage backplate;

HashMap configuration;

public void setup() {
  size(960,540,OPENGL);

  configuration = new HashMap();
  configuration.put("expandOverTime",0);
  configuration.put("topMaxAlpha",250);
  configuration.put("bottomMaxAlpha",150);

  Controls controls = new Controls(this, configuration);
  backplate = loadImage("background.jpg");


  trails = new ArrayList();
  colorMap = getColorMap("Palette1.jpg");
}


public void draw() {
  background(255);
  //image(backplate,0,0);
  
  /*
  PGraphicsOpenGL pgl;
   GL gl;
   
   pgl = (PGraphicsOpenGL) g;
   gl = pgl.gl;
   pgl.beginGL();
   
   gl.glDisable(GL.GL_DEPTH_TEST);
   gl.glEnable(GL.GL_BLEND);
   gl.glBlendFunc(GL.GL_ONE_MINUS_SRC_ALPHA , GL.GL_SRC_COLOR);
   pgl.endGL();  
   */

  // Update Trails

  if (mousePressed) {
    ((Trail)trails.get(trails.size()-1)).updateRibbons();
  }

  // Draw Trails

    if(saveDXF) {
    beginRaw(DXF, "images/output.dxf"); 
  }

  if (saveNow) {
    canvas = createGraphics(width, height, PDF, "images/output.pdf");
    canvas.beginDraw();  
    canvas.background(255);
    canvas.noStroke();
    canvas.smooth();      

  } 
  else {
    smooth();
    noStroke();
    canvas = null; 
  }

  for (int i = 0;  i < trails.size(); i++) {
    Trail curTrail = (Trail) trails.get(i);
    curTrail.draw(canvas);

  }

  if (saveNow) {
    //canvas.save("images/0.tif");
    canvas.dispose();
    canvas.endDraw();
    saveNow = false;  
  }

  if (saveDXF) {
    endRaw(); 
    saveDXF = false;  
  }



}


public void mousePressed() {
  trails.add(new Trail(colorMap));
}


public void keyPressed() {
  switch(keyCode) {
  case BACKSPACE:
    if (trails.size() >0) trails.remove(trails.size()-1);  
    break;
  case UP:
    ((Trail)trails.get(trails.size()-1)).addRibbon();
    break;
  }

  if (key == 's') {
    saveNow = true;
  }  

  if (key == 'd') {
    saveDXF = true;
  }  

  /*
  if (keyCode >= 48 && keyCode <= 57) {
   for (int i = 0;  i < ribbons.size(); i++) {
   Ribbon itrRibbon = (Ribbon) ribbons.get(i);
   itrRibbon.setPenMode(keyCode - 48);
   }    
   }
   */
}



// Palette Setup

public ArrayList getColorMap(String filename) {

  PImage palette = loadImage(filename);
  ArrayList colorMap = new ArrayList();
  for (int p=0; p< palette.width * palette.height; p++) {
    if (colorMap.indexOf(palette.pixels[p]) < 0 )
      colorMap.add((int) palette.pixels[p]);
  }

  return (colorMap);
}










// Seek_Arrive
// Daniel Shiffman <http://www.shiffman.net>

// The "Boid" class

// Created 2 May 2005

class Boid {

  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Boid(PVector l, float ms, float mf) {
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    loc = l.get();
    r = 3.0f;
    maxspeed = ms;
    maxforce = mf;
  }
  
  public void run() {
    update();
    //borders();
    //render();
  }
  
  // Method to update location
  public void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  public void seek(PVector target) {
    acc.add(steer(target,false));
  }
 
  public void arrive(PVector target) {
    acc.add(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  public PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = PVector.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0f)) desired.mult(maxspeed*(d/100.0f)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = PVector.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } else {
      steer = new PVector(0,0);
    }
    return steer;
  }
  
  public void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }
  
  // Wraparound
  public void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }

}
class Controls {
  PApplet parent;
  HashMap configuration;
  ControlP5 controlP5;
  ControlWindow controlWindow;  

  Controls(PApplet theParent, HashMap theConfiguration) {
    parent = theParent;
    configuration = theConfiguration;

    controlP5 = new ControlP5(parent);
    //controlP5.setAutoDraw(false);
    /*
    controlWindow = controlP5.addControlWindow("controlP5window",10,10,400,200);
    controlWindow.hideCoordinates();
    controlWindow.setTitle("Settings");
    controlWindow.setBackground(color(40));
    */
    
    RadioButton radioExpand = controlP5.addRadio("radioExpand",10,10);
    radioExpand.add("Expand Over Time",0);
    radioExpand.add("Contract Over Time",1);
    radioExpand.add("Bulge Over Time",2);
    radioExpand.setId(1);
    //radioExpand.setWindow(controlWindow);
    
    Slider sliderTopAlpha = controlP5.addSlider("Top Max Alpha",0,255, 10,60, 100, 10 );
    sliderTopAlpha.setId(2);
    //sliderTopAlpha.setWindow(controlWindow);
    
    Slider sliderBottomAlpha = controlP5.addSlider("Bottom Max Alpha",0,255, 10,80, 100, 10 );
    sliderBottomAlpha.setId(3);
    //sliderBottomAlpha.setWindow(controlWindow);    
    
  }
}


public void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id "+theEvent.controller().id());
  switch(theEvent.controller().id()) {
    case(1):
      setConfig("expandOverTime", ((Number)theEvent.controller().value()).toString());
      break;
    case(2):
      setConfig("topMaxAlpha", ((Number)theEvent.controller().value()));
      break;      
    case(3):
      setConfig("bottomMaxAlpha", ((Number)theEvent.controller().value()));
      break;        
  }
}



// Config Setup

public void setConfig(String parameter, Object value) {
  //println(value);
  configuration.put(parameter,value);
}



class Ribbon {
  ArrayList spots;
  PGraphics canvas;
  int ribbonColor;
  float lastUpdate;
  float birthDay;
  float seed;
  boolean saveNow = false;
  int saveIndex = 0;
  int penMode = 0;
  Boid bird;

  Ribbon(int newColor) {
    ribbonColor = newColor;

    seed = random(-1,1);
    spots = new ArrayList();
    birthDay = millis();

    bird = new Boid(new PVector(mouseX,mouseY),random(2,10),random(5,10  ));
  }

  public void addPoint(float newX, float newY) {
    bird.arrive(new PVector(newX, newY));
    spots.add(new Spot(new PVector(round(bird.loc.x), round(bird.loc.y))));
    bird.run();
  }

  public void update() {
    lastUpdate = millis();
    bird.run();
  }


  public void setPenMode(int newPenMode) {
    penMode = newPenMode; 
  }


  public void draw(PGraphics canvas) {
    Spot lastSpot = null;

    float lastVelOffset = 0;
    PVector lastTop = null, lastBottom = null, itrTop = null, itrBottom = null;

    // Middle

    for (int i = 0;  i < spots.size() ; i++) {
      Spot itrSpot = (Spot) spots.get(i);

      // Remove invisible spots

      if (itrSpot.getAge(lastUpdate)  > 3000) {      
        spots.remove(i); // Drop point after x milliseconds
        birthDay = itrSpot.getBirthDay();
      }

      // Draw shapes

      if (i > 0) {    
        // Trig Basics

        float rise = round(lastSpot.location.y - itrSpot.location.y);
        float base = round(lastSpot.location.x - itrSpot.location.x);
        float diagonal = round(rise*rise + base*base);

        float topAngle = round(atan(base / rise));
        float bottomAngle = round(atan(rise / base ));

        // Offsets

        float alphaDecay = lastSpot.getAge(lastUpdate) /20; // Fade over time

        float lastDecay =0, itrDecay =0;
        switch (configuration.get("expandOverTime").toString().charAt(0)) {
        case '0':  // Expand over time
          lastDecay = (lastSpot.getAge(lastUpdate) /20);
          itrDecay = (itrSpot.getAge(lastUpdate) /20);
          break;
        case '1':  // Contract over time
          lastDecay = (lastSpot.getAge(birthDay) /20);
          itrDecay = (itrSpot.getAge(birthDay) /20); 
          break;
        case '2': // Bulge over time
          float midPoint = ((lastUpdate - birthDay) / 2);
          lastDecay = (midPoint - abs(midPoint - abs(lastSpot.getAge(birthDay)))) /20;
          itrDecay = (midPoint - abs(midPoint - abs(itrSpot.getAge(birthDay)))) /20;
          break;
        }


        float lastSeedOffset = seed * lastSpot.getAge(lastUpdate) / 10 ;
        float itrSeedOffset = seed * itrSpot.getAge(lastUpdate) / 10;
        float velOffset = ((lastSpot.location.x - itrSpot.location.x)/width) * 100;

        lastSpot.offset = lastDecay;
        itrSpot.offset = itrDecay;

        // Bounds

        switch (penMode) {
        case 1: // Tilt geometry to follow angle of cursor
          float newBase, newRise;
          newBase = round(itrSpot.offset * cos(topAngle));
          newRise = round(itrSpot.offset * sin(topAngle));

          if (lastSpot.location.y > itrSpot.location.y) {
            newBase *=-1;
            newRise *=-1;
          }

          if (itrTop == null) {
            lastTop = new PVector(lastSpot.location.x + newBase, lastSpot.location.y - newRise);
            lastBottom = new PVector(lastSpot.location.x - newBase, lastSpot.location.y + newRise);      
          } 
          else {
            lastBottom = itrBottom;
            lastTop = itrTop; 
          }

          newBase = round(itrSpot.offset * sin(bottomAngle));
          newRise = round(itrSpot.offset * cos(bottomAngle));

          if (lastSpot.location.x > itrSpot.location.x) {
            newBase *=-1;
            newRise *=-1;
          }  

          itrTop = new PVector(itrSpot.location.x + newBase, itrSpot.location.y - newRise);
          itrBottom = new PVector(itrSpot.location.x - newBase, itrSpot.location.y + newRise);   
          break;
        default: // Vertical offset Only


          if (itrTop == null) {
            lastBottom = new PVector(lastSpot.location.x, round(lastSpot.location.y + lastSpot.offset));                
            lastTop = new PVector(lastSpot.location.x,round(lastSpot.location.y - lastSpot.offset));
          } 
          else {
            lastBottom = itrBottom;
            lastTop = itrTop; 
          }
          itrBottom = new PVector(itrSpot.location.x, round(itrSpot.location.y + itrSpot.offset));
          itrTop = new PVector(itrSpot.location.x,round(itrSpot.location.y - itrSpot.offset));          


          break;
        }


        // Draw it

        if (canvas != null) {
          canvas.beginShape();              
          canvas.fill(ribbonColor,((Number)configuration.get("bottomMaxAlpha")).floatValue() - alphaDecay);
          canvas.vertex(lastBottom.x, lastBottom.y);                  
          canvas.fill(ribbonColor,((Number)configuration.get("topMaxAlpha")).floatValue() - alphaDecay);         
          canvas.vertex(lastTop.x, lastTop.y);
          canvas.fill(ribbonColor,((Number)configuration.get("topMaxAlpha")).floatValue() - alphaDecay);
          canvas.vertex(itrTop.x, itrTop.y);             
          canvas.fill(ribbonColor,((Number)configuration.get("bottomMaxAlpha")).floatValue() - alphaDecay);   
          canvas.vertex(itrBottom.x, itrBottom.y);                
          canvas.endShape(CLOSE);           
         
        } 
        else {
          beginShape();              
          fill(ribbonColor,((Number)configuration.get("bottomMaxAlpha")).floatValue() - alphaDecay);
          vertex(lastBottom.x, lastBottom.y);                  
          fill(ribbonColor,((Number)configuration.get("topMaxAlpha")).floatValue() - alphaDecay);         
          vertex(lastTop.x, lastTop.y);
          fill(ribbonColor,((Number)configuration.get("topMaxAlpha")).floatValue() - alphaDecay);
          vertex(itrTop.x, itrTop.y);             
          fill(ribbonColor,((Number)configuration.get("bottomMaxAlpha")).floatValue() - alphaDecay);   
          vertex(itrBottom.x, itrBottom.y);                
          endShape(CLOSE);

        }

        lastVelOffset = velOffset;
      }


      lastSpot = itrSpot;
    }   


  }

}















class Spot {
  PVector location;
  float timestamp;
  float offset = 10;

  Spot(PVector newLocation) {
    location = newLocation.get();
    timestamp = millis();
  }

  public float getAge(float curTime) {
    return abs(curTime - timestamp);
  } 
  
  public float getBirthDay() {
     return timestamp; 
  }

}

class Trail {

  ArrayList ribbons;
  ArrayList colorMap;
  int colorOffset;
  float seed;

  Trail(ArrayList newColorMap) {
    colorMap = newColorMap;
    ribbons = new ArrayList();
    colorOffset = round(random(colorMap.size()-1));
    
    for(int x = 0; x< 5; x++)
      addRibbon(((Number) colorMap.get((x + colorOffset) % colorMap.size())).intValue());

    seed = random(-1,1);
  }
  
  public void addRibbon() {

    int newColor = ((Number) colorMap.get((ribbons.size() + colorOffset) % colorMap.size())).intValue();
    ribbons.add(new Ribbon(newColor)); 
  }

  public void addRibbon(int ribbonColor) {
    ribbons.add(new Ribbon(ribbonColor));
  }

  public void updateRibbons() {
    for (int i = 0;  i < ribbons.size(); i++) {
      Ribbon itrRibbon = (Ribbon) ribbons.get(i);
      itrRibbon.addPoint(mouseX, mouseY);
      itrRibbon.update();

    }  
  }


  
  public void draw(PGraphics canvas) { 
    for (int i = 0;  i < ribbons.size(); i++) {
      Ribbon itrRibbon = (Ribbon) ribbons.get(i);
      itrRibbon.draw(canvas);
    }    
  }

  public void printSeed() {

    println(seed);
  }
}




 
