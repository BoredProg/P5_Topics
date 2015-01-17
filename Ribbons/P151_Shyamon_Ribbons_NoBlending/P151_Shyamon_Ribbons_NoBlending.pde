import processing.opengl.*;
import javax.media.opengl.*;
import toxi.geom.*;
import processing.video.*;
import codeanticode.glgraphics.*;

//OpenGL variables
PGraphicsOpenGL pgl;
GL gl;
GLTexture srcTex, destTex;
GLGraphicsOffScreen offScreen;
BloomFx bloomFx;
float bloomIntens = 1.3;
float bloomThresh = 1.1;

//Globals..................................
OrbitCamera oCam;
PImage particleImg, ribbonColImg;
Particle[] particles;

int pCountMax = 300;
int pCount = 30;
boolean drawMode = true;
boolean checkNormal = false;

boolean isPlay = true;
boolean save = false;
MovieMaker mm;

PMatrix initMat;

void setup()
{
  size(1920, 1080, GLConstants.GLGRAPHICS);
  colorMode(RGB, 1.0);
  //frameRate(30);

  initMat = getMatrix();

  //setup OpenGL
  hint(DISABLE_OPENGL_2X_SMOOTH);
  hint(ENABLE_OPENGL_4X_SMOOTH);

  destTex = new GLTexture(this, width, height);
  bloomFx = new BloomFx(this);

  offScreen = new GLGraphicsOffScreen(this, width, height, true, 4);
  offScreen.noStroke();
  gl = offScreen.gl;
  gl.setSwapInterval(1);

  //setup camera
  oCam = new OrbitCamera(this, 0, 0, 1000);

  //load image
  particleImg = loadImage("Light64_alpha.png");
  ribbonColImg = loadImage("ColorlSample.jpg");

  //create particles
  particles = new Particle[pCountMax];

  for ( int i = 0; i < pCount; i++ ) {
    particles[i] = new Particle(particleImg);
    particles[i].SetOffScreenRender( offScreen );
  }

  if ( save )
    mm = new MovieMaker(this, width, height, "drawing.mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);
}

void draw()
{
  background(#000000);

  // normalRenderForDebug();
  //do offscreen render
  offScreenRender();

  srcTex = offScreen.getTexture();
  destTex = bloomFx.DoFx(srcTex, bloomThresh, bloomIntens);

  //upsample to screen
  image( destTex, 0, 0, width, height);

  if ( bloomThresh < 1.1 ) bloomThresh += 0.0035;

  if ( save )
    mm.addFrame();
}

void normalRenderForDebug()
{
  setupBlendMode();
  oCam.feed();

  //draw particles
  for ( int i=0; i<pCount; i++ ) {
    if ( isPlay ) particles[i].Update();
    particles[i].Render();
  }
}

void offScreenRender()
{
  offScreen.beginDraw();

  //Setup blend mode
  setupBlendMode();

  offScreen.background(0);
  oCam.feed();

  offScreen.beginGL();
  gl.glPushMatrix();

  for ( int i=0; i<pCount; i++ ) 
  {
    if ( isPlay ) particles[i].Update();
    particles[i].Render();
  }

  gl.glPopMatrix();
  offScreen.endGL();

  offScreen.endDraw();
}


void keyPressed()
{
  if ( key == 'd' ) {
    drawMode = !drawMode;
  }
  else if ( key == 'f' ) {
    println(frameRate);
  }
  else if ( key == 'p' ) {		
    isPlay = !isPlay;
  }
  else if ( key == 'b') {
    for ( int i = 0; i < pCount; i++ ) {
      // particles[i].moveRange = 800;
      particles[i].outForce = 100;
      bloomThresh = 0.1;
    }
  }
  else if ( key == 's' ) {
    saveFrame("cap.png");
  }
  else if ( key == ' ') {
    if ( save )
      mm.finish();
  }
  else if ( key == 'a' ) {

    if ( pCount < pCountMax ) {
      particles[pCount] = new Particle(particleImg);
      particles[pCount].SetOffScreenRender( offScreen );
      pCount++;
    }
  }
}

