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

public class CubemapToFisheye extends PApplet {

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

public void setup() {
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

public void draw() {
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
  yw+=((mouseX-width*0.5f)/(width*0.05f))*0.02f;
  ptch+=((mouseY-height*0.5f)/(height*0.05f))*0.02f;
 }
}

public void mouseWheel(int delta) {
  zoom += delta*0.05f;
}

public void keyReleased(){  
    showMap = !showMap;
}



/*
* --=[Cubemap to fisheye]=--
* by Jonsku, March 2011
* --
* Some code to generate, load from files and display cube maps.
*/

/*
* Creates a XOR checker pattern for testing
*/
public PImage createFace(int c1, int c2, int freq, int w) {
  if(freq<=0)
    freq = 1;
  freq = boxSize/freq;
  if(freq<1)
    freq = 1;
  PImage f = createImage(w,w,RGB);
  f.loadPixels();
  for(int i=0;i<w;i++) {
    for(int j=0;j<w;j++) {
      f.pixels[i+j*w] = (i%freq*2<=freq ^ j%freq*2<=freq)?c1:c2;
    }
  }
  return f;
}

public void generateCubemap(){
  cubeMap[BOX_FRONT] = createFace(color(100), color(200), patternFrequency, boxSize);
  debug = cubeMap[BOX_FRONT].get();
  cubeMap[BOX_BEHIND] = createFace(color(200,0,0), color(100,0,0), patternFrequency, boxSize);
  cubeMap[BOX_LEFT] = createFace(color(0,200,0), color(0,100,0), patternFrequency, boxSize);
  cubeMap[BOX_RIGHT] = createFace(color(0,0,200), color(0,0,100), patternFrequency, boxSize);
  cubeMap[BOX_BOTTOM] = createFace(color(200,200,0), color(100,100,0), patternFrequency, boxSize);
  cubeMap[BOX_TOP] = createFace(color(0,200,200), color(0,100,100), patternFrequency, boxSize);
}

/*
Load 6 files named:
"front_"+setName
"behind_"+setName
"left_"+setName
"right_"+setName
"top_"+setName
"bottom_"+setName
*/
public void loadCubemap(String setName){
  String fileName ="";
 for(int i=0;i<6;i++){
   switch(i){
     case BOX_FRONT:
     fileName = "front_"+setName;
     break;
          case BOX_BEHIND:
     fileName = "behind_"+setName;
     break;
          case BOX_RIGHT:
     fileName = "right_"+setName;
     break;
          case BOX_LEFT:
     fileName = "left_"+setName;
     break;
          case BOX_TOP:
     fileName = "top_"+setName;
     break;
          case BOX_BOTTOM:
     fileName = "bottom_"+setName;
     break;     
   }
   cubeMap[i] = loadImage(fileName);
 }
 boxSize = cubeMap[BOX_TOP].width;
}

public void drawCubemap() {
  pushMatrix();
  //scale so that the entire cube map fits in the screen
  scale(PApplet.parseFloat(width)/(4*boxSize));
  //top
  image(cubeMap[BOX_BOTTOM],boxSize,0);
  //left
  image(cubeMap[BOX_LEFT],0,boxSize);
  //front
  image(cubeMap[BOX_FRONT],boxSize,boxSize);
  //right
  image(cubeMap[BOX_RIGHT],2*boxSize,boxSize);
  //behind
  image(cubeMap[BOX_BEHIND],3*boxSize,boxSize);  
  //bottom
  image(cubeMap[BOX_TOP],boxSize,2*boxSize);
  popMatrix();
}

/*
* --=[Cubemap to fisheye]=--
* by Jonsku, March 2011
* --
* This code is a combination of code found in http://strlen.com/gfxengine/fisheyequake/
* and explanation and description of the angular fisheye projection by Paul Bourke
* http://paulbourke.net/miscellaneous/domefisheye/fisheye/
* ----------
* What it does is caclulate a projection vector for each pixels and use it to pick the color information
* from the cube map (6 images).
* The rotation of the virtual camera can be controlled by the parameters pitch, yaw and roll.
* The zoom parameter is quite groovy and can be used to create wee planets (http://www.flickr.com/photos/gadl/sets/72157594279945875/)
* or tear the fabric of the universe :D
*/

//fov in radians!
public int[] fisheyeLookup(int w, int h, float fov, float pitch, float yaw, float roll, float zoom) {
  int[] lookupTable = new int[w*h];
  int c = 0;
  float camX= 0;
  float camY= 0;
  for(float y=0;y<h;y++) {
    for(float x=0;x<w;x++) {
      float dx = x-PApplet.parseFloat(w)/2.0f;
      float dy = -y+PApplet.parseFloat(h)/2.0f;
      float d = dist(camX,camY,dx,dy);//sqrt(dx*dx+dy*dy);
      
      //constrain to produce a circular fisheye
      if(d>w/2){
        c++;
        continue;
      }

      float theta =  ((d*fov)/PApplet.parseFloat(w)); //theta
      float phi = atan2(camY-dy,camX-dx)+roll; //phi; add angle to change roll
      float sx_p = sin(theta) * cos(phi);
      float sy_p = sin(theta) * sin(phi);
      float sz_p = cos(theta+zoom);
      
      /*
      The projection vector is rotated by a rotation matrix
      which is the result of the multiplication of 3D roation on X (pitch) and Y (yaw) axes
      */
      float cosPitch = cos(pitch);
      float sinPitch = sin(pitch);
      float cosYaw = cos(yaw);
      float sinYaw = sin(yaw);
      
      float sx = sx_p*cosYaw+sy_p*sinPitch*sinYaw-sz_p*cosPitch*sinYaw;
      float sy = sy_p*cosPitch+sz_p*sinPitch;
      float sz = sx_p*sinYaw-sy_p*sinPitch*cosYaw+sz_p*cosPitch*cosYaw;

      //determine which side of the box to use
      float abs_x = abs(sx);
      float abs_y = abs(sy);
      float abs_z = abs(sz);
      int side = 0;
      float xs = 0.0f;
      float ys = 0.0f;

      if(abs_x > abs_y) {
        if(abs_x > abs_z) {
          side = sx > 0.0f ? BOX_RIGHT : BOX_LEFT;
        }
        else {
          side = sz > 0.0f ? BOX_FRONT : BOX_BEHIND;
        }
      }
      else {
        if(abs_y > abs_z) {
          side = sy > 0.0f ? BOX_TOP : BOX_BOTTOM;
        }
        else {
          side = sz > 0.0f ? BOX_FRONT : BOX_BEHIND;
        }
      }



      //Convert to range [0;1]
      switch(side) {
      case BOX_FRONT: 
        xs = rc(sx/sz); 
        ys = rc(sy/sz); 
        break;
      case BOX_BEHIND: 
        xs = rc(-sx/-sz); 
        ys = rc(sy/-sz); 
        break;
      case BOX_LEFT: 
        xs = rc(sz/-sx); 
        ys = rc(sy/-sx); 
        break;
      case BOX_RIGHT: 
        xs = rc(-sz/sx); 
        ys = rc(sy/sx); 
        break;
      case BOX_TOP: 
        xs = rc(sx/sy); 
        ys = rc(sz/-sy); 
        break;
      case BOX_BOTTOM: 
        xs = rc(-sx/sy); 
        ys = rc(sz/-sy); 
        break;
      }
      xs = constrain(xs,0.0f,0.999f);
      ys = constrain(ys,0.0f,0.999f);
      
      //get the pixel
      int lX = PApplet.parseInt(xs*PApplet.parseFloat(w));
      int lY = PApplet.parseInt(ys*PApplet.parseFloat(h));
      lX = constrain(lX,0,w);
      lY = constrain(lY,0,h);
 
      lookupTable[c++] = cubeMap[side].pixels[lX+lY*w];
    }
  }
  return lookupTable;
}

public float rc(float x) {
  return (x/2)+0.5f;
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CubemapToFisheye" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
