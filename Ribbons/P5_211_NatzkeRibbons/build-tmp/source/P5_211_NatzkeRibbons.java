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

public class P5_211_NatzkeRibbons extends PApplet {



int numcols = 200; // 30x20
int[] colArr = new int[numcols];

PImage texture;

//================================= global vars

int _numRibbons = 3;
int _numParticles = 40;
float _randomness = .2f;
RibbonManager ribbonManager;

float _a, _b, _centx, _centy, _x, _y;
float _noiseoff;
int _angle;

/************************************************************************************
*
*   Setup
*
************************************************************************************/

public void setup() 
{
  size(1280, 720,P3D);
  smooth(32); 
  frameRate(30);
  background(255);
  
  texture = loadImage("palette.png");

  initColors();
  background(0);
  
  _centx = (width / 2);
  _centy = (height / 2);

  initRibbonManager();
}    



/************************************************************************************
*
*   Draw
*
************************************************************************************/


public void draw() {
  //clearBackground();
  background(200);

  stroke(0,200);
  strokeWeight(0.5f);

  float newx = sin(_a + radians(_angle) + PI / 2) * _centx;  
  float newy = sin(_b + radians(_angle)) * _centy; 
  
  _angle += (random(180) - 90);
  if (_angle > 360) { _angle = 0; }
  if (_angle < 0) { _angle = 360; }
  
  translate(_centx, _centy);
  ribbonManager.update(newx* 0.5f, newy*0.5f);
}

public void initRibbonManager() 
{
  background(200);
  _noiseoff = random(1);
  _angle = 1; 
  _a = 3.5f;
  _b = _a + (noise(_noiseoff) * 1) - 0.5f;
  
  ribbonManager = new RibbonManager(_numRibbons, _numParticles, _randomness);   
  ribbonManager.setRadiusMax(12);                 // default = 8
  ribbonManager.setRadiusDivide(10);              // default = 10
  ribbonManager.setGravity(.0f);                   // default = .03
  ribbonManager.setFriction(1.1f);                  // default = 1.1
  ribbonManager.setMaxDistance(40);               // default = 40
  ribbonManager.setDrag(2.5f);                      // default = 2
  ribbonManager.setDragFlare(0.008f);                 // default = .008
  
}


public void mousePressed() 
{ 
  initRibbonManager();
}



public void initColors() 
{

   colArr = new int[numcols];
  for (int x=0; x < numcols; x ++)
   {
      colArr[x] = color(random(255),random(255), random(255));
  }
}






//======== ribbon  

class Ribbon {
  int _numRibbons;
  float _randomness;
  int _numParticles;         // length of the Particle Array (max number of points)
  int particlesAssigned = 0;        // current amount of particles currently in the Particle array                                
  float radiusMax = 8;              // maximum width of ribbon
  float radiusDivide = 10;          // distance between current and next point / this = radius for first half of the ribbon
  float gravity = .03f;              // gravity applied to each particle
  float friction = 1.1f;             // friction applied to the gravity of each particle
  int maxDistance = 40;             // if the distance between particles is larger than this the drag comes into effect
  float drag = 2;                   // if distance goes above maxDistance - the points begin to grag. high numbers = less drag
  float dragFlare = .008f;           // degree to which the drag makes the ribbon flare out
  RibbonParticle[] particles;       // particle array
  int ribbonColor;
  
  Ribbon(int _numParticles, int ribbonColor, float _randomness) {
    this._numParticles = _numParticles;
    this.ribbonColor = ribbonColor;
    this._randomness = _randomness;
    init();
  }
  
  public void init() {
    particles = new RibbonParticle[_numParticles];
  }
  
  public void update(float randX, float randY){
    addParticle(randX, randY);
    drawCurve();
  }
  
  public void addParticle(float randX, float randY) {
    if(particlesAssigned == _numParticles) {
      for (int i = 1; i < _numParticles; i++) {
        particles[i-1] = particles[i];
      }
      particles[_numParticles - 1] = new RibbonParticle(_randomness, this);
      particles[_numParticles - 1].px = randX;
      particles[_numParticles - 1].py = randY;
      return;
    } else {
      particles[particlesAssigned] = new RibbonParticle(_randomness, this);
      particles[particlesAssigned].px = randX;
      particles[particlesAssigned].py = randY;
      ++particlesAssigned;
    }
    if (particlesAssigned > _numParticles) ++particlesAssigned;
  }
  
  public void drawCurve() {
    smooth(32);
    for (int i = 1; i < particlesAssigned - 1; i++) {
      RibbonParticle p = particles[i];
      p.calculateParticles(particles[i-1], particles[i+1], _numParticles, i);
    }

    //fill(30);
    for (int i = particlesAssigned - 3; i > 1 - 1; i--) 
    {
      RibbonParticle p = particles[i];
      RibbonParticle pm1 = particles[i-1];
      fill(ribbonColor, 255);
      texture(texture);
      if (i < particlesAssigned-3) 
      {
        beginShape();
        texture(texture);
        textureWrap(NORMAL);
        vertex(p.lcx2, p.lcy2);
        bezierVertex(p.leftPX, p.leftPY, pm1.lcx2, pm1.lcy2, pm1.lcx2, pm1.lcy2);
        vertex(pm1.rcx2, pm1.rcy2);
        bezierVertex(p.rightPX, p.rightPY, p.rcx2, p.rcy2, p.rcx2, p.rcy2);
        vertex(p.lcx2, p.lcy2);
        endShape();
      }
    }
  }
}
class RibbonManager {
  int _numRibbons;
  int _numParticles;
  float _randomness;
  Ribbon[] ribbons;       // ribbon array
  
  RibbonManager(int _numRibbons, int _numParticles, float _randomness) {
    this._numRibbons = _numRibbons;
    this._numParticles = _numParticles;
    this._randomness = _randomness;
    init();
  }
  
  public void init() {
    addRibbon();
  }

  public void addRibbon() {
    ribbons = new Ribbon[_numRibbons];
    for (int i = 0; i < _numRibbons; i++) {
      int ribbonColour = colArr[PApplet.parseInt(random(numcols))];
      ribbons[i] = new Ribbon(_numParticles, ribbonColour, _randomness);
    }
  }
  
  public void update(float currX, float currY)  {
    for (int i = 0; i < _numRibbons; i++) {
      float randX = currX;
      float randY = currY;
      
      ribbons[i].update(randX, randY);
    }
  }
  
  public void setRadiusMax(float value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].radiusMax = value; } }
  public void setRadiusDivide(float value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].radiusDivide = value; } }
  public void setGravity(float value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].gravity = value; } }
  public void setFriction(float value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].friction = value; } }
  public void setMaxDistance(int value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].maxDistance = value; } }
  public void setDrag(float value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].drag = value; } }
  public void setDragFlare(float value) { for (int i = 0; i < _numRibbons; i++) { ribbons[i].dragFlare = value; } }
}
//======== particle 

class RibbonParticle {
  float px, py;                                       // x and y position of particle (this is the bexier point)
  float xSpeed, ySpeed = 0;                           // speed of the x and y positions
  float cx1, cy1, cx2, cy2;                           // the avarage x and y positions between px and py and the points of the surrounding Particles
  float leftPX, leftPY, rightPX, rightPY;             // the x and y points of that determine the thickness of this segment
  float lpx, lpy, rpx, rpy;                           // the x and y points of the outer bezier points
  float lcx1, lcy1, lcx2, lcy2;                       // the avarage x and y positions between leftPX and leftPX and the left points of the surrounding Particles
  float rcx1, rcy1, rcx2, rcy2;                       // the avarage x and y positions between rightPX and rightPX and the right points of the surrounding Particles
  float radius;                                       // thickness of current particle
  float _randomness;
  Ribbon ribbon;
  
  RibbonParticle(float _randomness, Ribbon ribbon) {
    this._randomness = _randomness;
    this.ribbon = ribbon;
  }
  
  public void calculateParticles(RibbonParticle pMinus1, RibbonParticle pPlus1, int particleMax, int i) {
    float div = 2;
    cx1 = (pMinus1.px + px) / div;
    cy1 = (pMinus1.py + py) / div;
    cx2 = (pPlus1.px + px) / div;
    cy2 = (pPlus1.py + py) / div;

    // calculate radians (direction of next point)
    float dx = cx2 - cx1;
    float dy = cy2 - cy1;

    float pRadians = atan2(dy, dx);

    float distance = sqrt(dx*dx + dy*dy);

    if (distance > ribbon.maxDistance) {
      float oldX = px;
      float oldY = py;
      px = px + ((ribbon.maxDistance/ribbon.drag) * cos(pRadians));
      py = py + ((ribbon.maxDistance/ribbon.drag) * sin(pRadians));
      xSpeed += (px - oldX) * ribbon.dragFlare;
      ySpeed += (py - oldY) * ribbon.dragFlare;
    }
    
    ySpeed += ribbon.gravity;
    xSpeed *= ribbon.friction;
    ySpeed *= ribbon.friction;
    px += xSpeed + random(.3f);
    py += ySpeed + random(.3f);
    
    float randX = ((_randomness / 2) - random(_randomness)) * distance;
    float randY = ((_randomness / 2) - random(_randomness)) * distance;
    px += randX;
    py += randY;
    
    //float radius = distance / 2;
    //if (radius > radiusMax) radius = ribbon.radiusMax;
    
    if (i > particleMax / 2) {
      radius = distance / ribbon.radiusDivide  ; 
    } else {
      radius = pPlus1.radius * .9f;
    }
    
    if (radius > ribbon.radiusMax) radius = ribbon.radiusMax;
    if (i == particleMax - 2 || i == 1) {
      if (radius > 1) radius = 1;
    }

    // calculate the positions of the particles relating to thickness
    leftPX = px + cos(pRadians + (HALF_PI * 3)) * radius * 2;
    leftPY = py + sin(pRadians + (HALF_PI * 3)) * radius * 2;
    rightPX = px + cos(pRadians + HALF_PI) * radius * 2;
    rightPY = py + sin(pRadians + HALF_PI) * radius * 2;

    // left and right points of current particle
    lpx = (pMinus1.lpx + lpx) / div;
    lpy = (pMinus1.lpy + lpy) / div;
    rpx = (pPlus1.rpx + rpx) / div;
    rpy = (pPlus1.rpy + rpy) / div;

    // left and right points of previous particle
    lcx1 = (pMinus1.leftPX + leftPX) / div;
    lcy1 = (pMinus1.leftPY + leftPY) / div;
    rcx1 = (pMinus1.rightPX + rightPX) / div;
    rcy1 = (pMinus1.rightPY + rightPY) / div;

    // left and right points of next particle
    lcx2 = (pPlus1.leftPX + leftPX) / div;
    lcy2 = (pPlus1.leftPY + leftPY) / div;
    rcx2 = (pPlus1.rightPX + rightPX) / div;
    rcy2 = (pPlus1.rightPY + rightPY) / div;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_NatzkeRibbons" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
