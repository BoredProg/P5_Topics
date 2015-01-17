/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/25607*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/*
* --=[Cubemap to fisheye]=--
* by Jonsku, March 2011
* --
* Creates (angular) fisheye from cube maps and display them interactively.
* See my other sketch : http://openprocessing.org/visuals/?visualID=12140
* -- Controls --
* Move the mouse to rotate the camera.
* Click to toggle camera rotation.
* Use the scrollwheel to zoom in and out (not what you expect, it's very coool!)
* Press any key to show/hide the source cubemap.
*/

PImage[] cubeMap;
static final int BOX_FRONT = 0;
static final int BOX_BEHIND = 1;
static final int BOX_LEFT = 2;
static final int BOX_RIGHT = 3;
static final int BOX_BOTTOM = 4;
static final int BOX_TOP = 5;
PImage debug;
int boxSize = 800;
int patternFrequency = 5;

PImage fisheye;

boolean showMap = false;

float ptch = 0;
float yw = 0;

float zoom = 0;

boolean rotation = true;

void setup() {
addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
  }}); 
  
  smooth();
  cubeMap = new PImage[6];
 // generateCubemap();
 loadCubemap("garden.png");
   //size(cubeMap[BOX_FRONT].width,cubeMap[BOX_FRONT].height,JAVA2D);
   size(528,528,JAVA2D);
   //hold the result of the projection
  fisheye = createImage(width,height,RGB);

}

void draw() {
  background(100);

  if(showMap) {
    drawCubemap();
  }
  else {
    fisheye.loadPixels();
  fisheye.pixels = fisheyeLookup(width,height, PI,ptch,yw,0,zoom);
  fisheye.updatePixels();
    image(fisheye,0,0);
  }
  
  if(mousePressed){
    rotation = !rotation;
  }
  
 if(rotation){
  yw+=((mouseX-width*0.5)/(width*0.05))*0.02;
  ptch+=((mouseY-height*0.5)/(height*0.05))*0.02;
 }
}

void mouseWheel(int delta) {
  zoom += delta*0.05;
}

void keyReleased(){  
    showMap = !showMap;
}



