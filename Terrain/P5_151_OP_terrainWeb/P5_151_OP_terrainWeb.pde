/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/52738*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import processing.opengl.*;
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
NoiseGenerator ng;
Terrain t;
boolean showImg = true;
PFont font;
int count = 0;

void setup()
{
  size (900, 600, P3D);
  //hint (ENABLE_DEPTH_TEST);
  font = createFont ("Rockwell", 32);
  cam = new PeasyCam (this, 400, -20, -10, 1200);
  cam.setRotations (radians (-80), radians (0), radians (0));
  ng = new NoiseGenerator (800, 800);
  t = new Terrain (0, 0, 200, 200, 800, 800, ng.getImage());
}

void draw ()
{

  background (225);
  lights();
  t.display();
  buildTerrain();
/*
  cam.beginHUD();
  noLights();
  if (showImg) ng.display (20, 20, 200, 200);
  buildTerrain();
  cam.endHUD();*/
  count++;
}

void buildTerrain ()
{
  textFont (font, 26);
  fill (121, 195, 229);
  noStroke();
  if (count == 1) {
    //text ("Building terrain. Step 1 of 7.", 20, height-30);
    ng.doubleImage();
    t.update(ng.getImage());
  }
  else if (count == 2) {
    //text ("Building terrain. Step 2 of 7.", 20, height-30);
    ng.invertImage ();
    t.update(ng.getImage());
  }
  else if (count == 3) {
   // text ("Building terrain. Step 3 of 7.", 20, height-30);
    ng.measureImage ();
    t.update(ng.getImage());
  }
  else if (count == 4) {
 //   text ("Building terrain. Step 4 of 7.", 20, height-30);
    ng.doubleImage();
    t.update(ng.getImage());
  }
  else if (count == 5) {
   // text ("Building terrain. Step 5 of 7.", 20, height-30);
    ng.doFastBlur ();
    t.update(ng.getImage());
  }
  else if (count == 6) {
   // text ("Building terrain. Step 6 of 7.", 20, height-30);
    ng.setValleys ((int) random (10, 30));
    t.update(ng.getImage());
  }
  else if (count == 7) {
   // text ("Building terrain. Step 7 of 7.", 20, height-30);
    ng.setCrack ((int) random (20, 35));
    t.update(ng.getImage());
  }
}

