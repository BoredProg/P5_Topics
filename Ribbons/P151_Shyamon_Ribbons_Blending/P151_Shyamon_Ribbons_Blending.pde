/*
* From "shiyamon" : https://vimeo.com/user4017397/videos

Drawing 3D Ribbons that follows a particle.
Ribbon drawing is based on Erik Natzke's 2D ribbon drawing (http://jot.eriknatzke.com/)
Lots of thanks to people who bring into Processing!

[Interaction]
drag screen - rotate camera
mouse wheel - zoom camera

press 'a' - add a new particle
press 'd' - toggle the draw mode(polygon/wireframe)
press 'p' - toggle play/pause
*/



import processing.opengl.*;
import javax.media.opengl.*;
import toxi.geom.*;
import processing.video.*;

import damkjer.ocd.*;

//OpenGL variables.............
PGraphicsOpenGL pgl;
GL gl;

//Globals......................
MyPeasyCam pCam;

OrbitCamera oCam;

PImage ribbonColImg;
Particle[] particles;

int pCountMax = 50;
int pCount = 10;

boolean drawMode = true;
boolean isPlay = true;


void setup()
{
  //setup viewport
  size(1280, 640, OPENGL);
  frameRate(30);

  //setup OpenGL
  hint(DISABLE_OPENGL_2X_SMOOTH);
  hint(ENABLE_OPENGL_4X_SMOOTH);

  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  gl.setSwapInterval(1);

  //setup camera
  //pCam = new MyPeasyCam(this, 50, 900, 100);
  oCam = new OrbitCamera(this, 0, 0, 1000);
  
  //load ribbon color image
  ribbonColImg = loadImage("ColorlSample.jpg");

  //create particles
  particles = new Particle[pCountMax];

  for ( int i = 0; i < pCount; i++ ) {
    particles[i] = new Particle();
  }
}

void draw()
{
  background(#000000);

  //Setup blend mode
  setupBlendMode();
  
  oCam.feed();

  //draw particles
  for ( int i=0; i<pCount; i++ ) {
    if ( isPlay ) particles[i].Update();
    particles[i].Render();
  }
}


void keyPressed()
{
  if ( key == 'd' ) {
    drawMode = !drawMode;
  }
  else if ( key == 'p' ) {		
    isPlay = !isPlay;
  }
  else if ( key == 'a' ) {

    if ( pCount < pCountMax ) {
      particles[pCount] = new Particle();
      pCount++;
    }
  }
}

