

int numcols = 200; // 30x20
color[] colArr = new color[numcols];

PImage texture;

//================================= global vars

int _numRibbons = 3;
int _numParticles = 40;
float _randomness = .2;
RibbonManager ribbonManager;

float _a, _b, _centx, _centy, _x, _y;
float _noiseoff;
int _angle;

/************************************************************************************
*
*   Setup
*
************************************************************************************/

void setup() 
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


void draw() {
  //clearBackground();
  background(200);

  stroke(0,200);
  strokeWeight(0.5);

  float newx = sin(_a + radians(_angle) + PI / 2) * _centx;  
  float newy = sin(_b + radians(_angle)) * _centy; 
  
  _angle += (random(180) - 90);
  if (_angle > 360) { _angle = 0; }
  if (_angle < 0) { _angle = 360; }
  
  translate(_centx, _centy);
  ribbonManager.update(newx* 0.5, newy*0.5);
}

void initRibbonManager() 
{
  background(200);
  _noiseoff = random(1);
  _angle = 1; 
  _a = 3.5;
  _b = _a + (noise(_noiseoff) * 1) - 0.5;
  
  ribbonManager = new RibbonManager(_numRibbons, _numParticles, _randomness);   
  ribbonManager.setRadiusMax(12);                 // default = 8
  ribbonManager.setRadiusDivide(10);              // default = 10
  ribbonManager.setGravity(.0);                   // default = .03
  ribbonManager.setFriction(1.1);                  // default = 1.1
  ribbonManager.setMaxDistance(40);               // default = 40
  ribbonManager.setDrag(2.5);                      // default = 2
  ribbonManager.setDragFlare(0.008);                 // default = .008
  
}


void mousePressed() 
{ 
  initRibbonManager();
}



void initColors() 
{

   colArr = new color[numcols];
  for (int x=0; x < numcols; x ++)
   {
      colArr[x] = color(random(255),random(255), random(255));
  }
}






