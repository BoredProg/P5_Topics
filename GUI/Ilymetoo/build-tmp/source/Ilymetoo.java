import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import processing.opengl.*; 
import java.util.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Ilymetoo extends PApplet {

// Constellation II   -- vs 2010





PFont font;
int pop = 300;                     // until 2000 with OpenGL, 250-300 w/o ; use GL Hardware antialiasing to replace smooth() 
int MAXPOP = 3000;
int maxDist = 25;                  // link distance btw 2 point

boolean stand = false;
boolean play = true;

int bgAlpha = 75;
float c1Alpha = 255;
float c2Alpha = 0;
boolean c2Fill = true;
boolean nbProp = false;

float speedMove = 10;
float linkWeight = 1.25f;

System space;


public void setup() {

  size(480,800,OPENGL);
  if (frame != null)
    frame.setResizable(true);
  frameRate(60);
  rectMode(CENTER);
  font = loadFont("Rix-9.vlw"); // HowardFat-16.vlw, Butter-unsalted-13.vlw, okolaksRegular-13.vlw, Rix-11.vlw, Rix-10.vlw (+16), Rix-9.vlw
  textFont(font);
  background(0);
  frame.setBackground(new java.awt.Color(0, 0, 0));

  setupGui();
  space = new System(MAXPOP);

 // cam = new PeasyCam(this, 100);
 // cam.setMinimumDistance(50);
 // cam.setMaximumDistance(500);
}

public void draw() {
  if ( play ) {
    if ( ! stand ) {
      noSmooth();
      rectMode(CORNER);
      fill(0,bgAlpha); noStroke(); rect(0,0,width,height);
      rectMode(CENTER);
    }
    //smooth();
    space.draw(speedMove,linkWeight,maxDist,pop);       // passing global parms via P5 GUI
    noSmooth();
  }
  printFrame();
}


public void printFrame() {
  noStroke();
  fill(0);
  rect(width-80,height-10-20,150,60);
  fill(255);
  text(frameRate,width-80,height-10);
}
class Circle {

  float x,y;
  float rx,ry;                // x,y random position
  float z1;                   // size of central dot 
  float z2;                   // size of first circle
  int c1, c2;               // circles colors

  int c1MaxSize = 4;
  int c2MaxSize = 9;

//  float c2Alpha = 0;

  int i, maxi;                // range of secondary circles
  int nb;                      // nb of neighbor
  float selfmove;


  Circle(float irx,float iry) { // initial random x & y position
    rx = irx;
    ry = iry; 
    x = (noise(rx)*width);
    y = (noise(ry)*height);
    nb = 0;
    selfmove = 0;
    c1 = 124;
    c2 = 124;
  }

  public void move(float noiseValue) {
    x = (noise(rx)*width);
    y = (noise(ry)*height);
    rx+=noiseValue + selfmove;
    ry+=noiseValue + selfmove;
    z1 = (random(1,c1MaxSize));
    if ( nbProp )
      z2 = (random(z1,nb*3));
    else
      z2 = (random(0,c2MaxSize));
    //c1 = random(c1,255-c1);      // color of central dot
    c1 = (int) random(70+(nb*2),150+((nb*3)%105));      // color of central dot => from 70 to 255
    //println(c1);
    //c2 = random(c1,c1/2+50-c2);
    c2 = (int) random(c1-70,c1);                        // from 0 to c1
  }    

  public void display() {
    if (c2Alpha > 0) {
      if (c2Fill) {
        noStroke();
        fill(c2,c2Alpha);
      }
      else {
        stroke(c2,c2Alpha);
        strokeWeight(0.2f);
        fill(0,c2Alpha);
      }
      ellipse(x,y,z2,z2);
    }
    if (c1Alpha > 0) {
      noStroke();
      fill(c1,c1Alpha);
      ellipse(x,y,z1,z1);
    }
  }

  public void addnb(int n) {
    nb += n;
    selfmove += speedMove * (nb / 500);
  }
}
class System {

  Circle[] circles;
  float[] xpos;
  float[] ypos;

  float noiseValue = 0.010f;   // base of random move
  float lw;                   // linkWeight
  int md;                     // maxDist
  int maxPop;                 // maximum population (max array size)
  int currentPop;

  System(int in) {
    circles = new Circle[in];
    xpos = new float[in];
    ypos = new float[in];
    lw = 1;
    md = 25;
    maxPop = in;
    currentPop=0;

    for(int i = 0; i< circles.length;i++) {
      circles[i] = new Circle(random(width),random(height)); 
    }
  }

  public void draw(float speedMove, float linkWeight, int maxDist, int pop) {
  
    currentPop=pop;
    md = maxDist;

    //for(int i = 0; i < circles.length;i++) {
    for(int i = 0; i < currentPop; i++) {
      xpos[i]= circles[i].x;
      ypos[i]= circles[i].y;
      
      circles[i].nb=0;
      circles[i].selfmove=0;
      lw = linkWeight;
      linkIt(i);

      circles[i].move(noiseValue);        // noiseValue
      circles[i].display();

    }
    noiseValue = speedMove / 10000;
  }
  
  public void linkIt(int ii) {
    float a,d;

    for (int j = ii; j < currentPop; j++) {
      d = dist(xpos[ii],ypos[ii],xpos[j],ypos[j]);
      if(d <= md && ii != j ) {
        //a = 160 - (d*3);
        a = 255 - (d * (255/md));
        strokeWeight(lw);
        stroke(180,180,220,a);
        line(xpos[ii],ypos[ii],xpos[j],ypos[j]);
        circles[ii].addnb(1);
      }
    }
  }
}
ControlP5 cp5;

public void setupGui() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  ControlWindow guiWin = cp5.addControlWindow("P5Win",10,10,300,200);
  guiWin.setBackground(color(0));
  guiWin.setColorForeground(color(0));

  controlP5.Slider ctlspeedMove = cp5.addSlider("speedMove")
    .setPosition(5,5)
    .setSize(150,15)
    .setRange(1,50)
    .setValue(10);
  ctlspeedMove.setWindow(guiWin);
  
  controlP5.Slider ctlc1Alpha = cp5.addSlider("c1Alpha")
    .setPosition(5,25)
    .setSize(150,15)
    .setRange(0,255)
    .setValue(0);
  ctlc1Alpha.setWindow(guiWin);
  
  controlP5.Slider ctlc2Alpha = cp5.addSlider("c2Alpha")
    .setPosition(5,45)
    .setSize(150,15)
    .setRange(0,255)
    .setValue(0);
  ctlc2Alpha.setWindow(guiWin);

  controlP5.Toggle ctlc2Fill = cp5.addToggle("c2Fill")
    .setPosition(220,45)
    .setSize(15,15)
    .setValue(true);
  ctlc2Fill.setWindow(guiWin);
  
  controlP5.Toggle ctlnbProp = cp5.addToggle("nbProp")
    .setLabel("NBP")
    .setPosition(250,45)
    .setSize(15,15)
    .setValue(false);
  ctlnbProp.setWindow(guiWin);

  controlP5.Slider ctllinkWeight = cp5.addSlider("linkWeight")
    .setPosition(5,65)
    .setSize(150,15)
    .setRange(0,3.0f)
    .setValue(1.0f);
  ctllinkWeight.setWindow(guiWin);

  controlP5.Slider ctlmaxDist = cp5.addSlider("maxDist")
    .setPosition(5,85)
    .setSize(150,15)
    .setRange(1,127)
    .setValue(25);
  ctlmaxDist.setWindow(guiWin);

  controlP5.Slider ctlbgAlpha = cp5.addSlider("bgAlpha")
    .setPosition(5,105)
    .setSize(150,15)
    .setRange(0,255)
    .setValue(75);
  ctlbgAlpha.setWindow(guiWin);

  controlP5.Toggle ctlstand = cp5.addToggle("stand")
    .setPosition(5,125)
    .setSize(20,20)
    .setValue(false);
  ctlstand.setWindow(guiWin);

  controlP5.Toggle ctlplay = cp5.addToggle("play")
    .setPosition(35,125)
    .setSize(20,20)
    .setValue(true);
  ctlplay.setWindow(guiWin);
  
  controlP5.Slider ctlPop = cp5.addSlider("pop")
    .setPosition(5,160)
    .setSize(150,15)
    .setRange(0,MAXPOP)
    .setValue(300);
  ctlPop.setWindow(guiWin);


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Ilymetoo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
