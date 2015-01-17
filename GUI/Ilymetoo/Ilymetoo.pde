// Constellation II   -- vs 2010

import controlP5.*;
import processing.opengl.*;
import java.util.*;

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
float linkWeight = 1.25;

System space;


void setup() {

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

void draw() {
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


void printFrame() {
  noStroke();
  fill(0);
  rect(width-80,height-10-20,150,60);
  fill(255);
  text(frameRate,width-80,height-10);
}
