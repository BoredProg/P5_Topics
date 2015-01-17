import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import java.util.Calendar; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_UsingWatzTileSaver_Working extends PApplet {

// M_1_4_01.pde
// TileSaver.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * creates a terrain like mesh based on noise values.
 * 
 * MOUSE
 * position x/y + left drag   : specify noise input range
 * position x/y + right drag  : camera controls
 * 
 * KEYS
 * l                          : toogle display strokes on/off
 * arrow up                   : noise falloff +
 * arrow down                 : noise falloff -
 * arrow left                 : noise octaves -
 * arrow right                : noise octaves +
 * space                      : new noise seed
 * +                          : zoom in
 * -                          : zoom out
 * s                          : save png
 * p                          : high resolution export (please update to processing 1.0.8 or 
 *                              later. otherwise this will not work properly)
 */





// ------ mesh ------
int tileCount = 50;
int zScale = 150;

// ------ noise ------
int noiseXRange = 10;
int noiseYRange = 10;
int octaves = 4;
float falloff = 0.5f;

// ------ mesh coloring ------
int midColor, topColor, bottomColor;
int strokeColor;
float threshold = 0.30f;

// ------ mouse interaction ------
int offsetX = 0, offsetY = 0, clickX = 0, clickY = 0, zoom = -280;
float rotationX = 0, rotationZ = 0, targetRotationX = -PI/3, targetRotationZ = 0, clickRotationX, clickRotationZ; 

// ------ image output ------
int qualityFactor = 4;    // Seb : tried up to 20 !! 16 000 x 16 000 pixels and looks smooooooth ;=)
TileSaver tiler;  
boolean showStroke = true;


public void setup() {
  size(800, 800, OPENGL);
  colorMode(HSB, 360, 100, 100);
  tiler = new TileSaver(this);
  cursor(CROSS);

  // colors
  topColor = color(0, 0, 100);
  midColor = color(191, 99, 63);
  bottomColor = color(0, 0, 0);

  strokeColor = color(0, 0, 0);
}


public void draw() {
  if (tiler==null) return; 
  tiler.pre();

  if (showStroke) stroke(strokeColor);
  else noStroke();

  background(0, 0, 100);
  lights();


  // ------ set view ------
  pushMatrix();
  translate(width*0.5f, height*0.5f, zoom);

  if (mousePressed && mouseButton==RIGHT) {
    offsetX = mouseX-clickX;
    offsetY = mouseY-clickY;
    targetRotationX = min(max(clickRotationX + offsetY/PApplet.parseFloat(width) * TWO_PI, -HALF_PI), HALF_PI);
    targetRotationZ = clickRotationZ + offsetX/PApplet.parseFloat(height) * TWO_PI;
  }
  rotationX += (targetRotationX-rotationX)*0.25f; 
  rotationZ += (targetRotationZ-rotationZ)*0.25f;  
  rotateX(-rotationX);
  rotateZ(-rotationZ); 


  // ------ mesh noise ------
  if (mousePressed && mouseButton==LEFT) {
    noiseXRange = mouseX/10;
    noiseYRange = mouseY/10;
  }

  noiseDetail(octaves, falloff);
  float noiseYMax = 0;

  float tileSizeY = (float)height/tileCount;
  float noiseStepY = (float)noiseYRange/tileCount;

  for (int meshY=0; meshY<=tileCount; meshY++) {
    beginShape(TRIANGLE_STRIP);
    for (int meshX=0; meshX<=tileCount; meshX++) {

      float x = map(meshX, 0, tileCount, -width/2, width/2);
      float y = map(meshY, 0, tileCount, -height/2, height/2);

      float noiseX = map(meshX, 0, tileCount, 0, noiseXRange);
      float noiseY = map(meshY, 0, tileCount, 0, noiseYRange);
      float z1 = noise(noiseX, noiseY);
      float z2 = noise(noiseX, noiseY+noiseStepY);

      noiseYMax = max(noiseYMax, z1);
      int interColor;
      colorMode(RGB);
      if (z1 <= threshold) {
        float amount = map(z1, 0, threshold, 0.15f, 1);
        interColor = lerpColor(bottomColor, midColor, amount);
      } 
      else {
        float amount = map(z1, threshold, noiseYMax, 0, 1);
        interColor = lerpColor(midColor, topColor, amount);
      }
      colorMode(HSB, 360, 100, 100);
      fill(interColor);

      vertex(x, y, z1*zScale);   
      vertex(x, y+tileSizeY, z2*zScale);
    }
    endShape();
  }
  popMatrix();

  tiler.post();
}

public void mousePressed() {
  clickX = mouseX;
  clickY = mouseY;
  clickRotationX = rotationX;
  clickRotationZ = rotationZ;
}

public void keyPressed() {
  if (keyCode == UP) falloff += 0.05f;
  if (keyCode == DOWN) falloff -= 0.05f;
  if (falloff > 1.0f) falloff = 1.0f;
  if (falloff < 0.0f) falloff = 0.0f;

  if (keyCode == LEFT) octaves--;
  if (keyCode == RIGHT) octaves++;
  if (octaves < 0) octaves = 0;

  if (key == '+') zoom += 20;
  if (key == '-') zoom -= 20;
}

public void keyReleased() {  
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_####.png");
  if (key == 'p' || key == 'P') tiler.init(timestamp()+".png", qualityFactor);
  if (key == 'l' || key == 'L') showStroke = !showStroke;
  if (key == ' ') noiseSeed((int) random(100000));
}

public String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

// M_3_4_01_TOOL.pde
// GUI.pde, Mesh.pde, TileSaver.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// TileSaver.pde - v0.12 2007.0326
// Marius Watz - http://workshop.evolutionzone.com
//
// Class for rendering high-resolution images by splitting them into
// tiles using the viewport.
//
// Builds heavily on solution by "surelyyoujest":
// http://processing.org/discourse/yabb_beta/YaBB.cgi?
// board=OpenGL;action=display;num=1159148942

class TileSaver {
  public boolean isTiling=false,done=true;
  public boolean doSavePreview=false;

  PApplet p;
  float FOV=60; // initial field of view
  float cameraZ, width, height;
  int tileNum=10,tileNumSq; // number of tiles
  int tileImgCnt, tileX, tileY, tilePad;
  boolean firstFrame=false, secondFrame=false;
  String tileFilename,tileFileextension=".png";
  PImage tileImg;
  float perc,percMilestone;

  // The constructor takes a PApplet reference to your sketch.
  public TileSaver(PApplet _p) {
    p=_p;
  }

  // If init() is called without specifying number of tiles, getMaxTiles()
  // will be called to estimate number of tiles according to free memory.
  public void init(String _filename) {
    init(_filename,getMaxTiles(p.width));
  }

  // Initialize using a filename to output to and number of tiles to use.
  public void init(String _filename,int _num) {
    tileFilename=_filename;
    tileNum=_num;
    tileNumSq=(tileNum*tileNum);

    width=p.width;
    height=p.height;
    cameraZ=(height/2.0f)/p.tan(p.PI*FOV/360.0f);
    p.println("TileSaver: "+tileNum+" tilesnResolution: "+
      (p.width*tileNum)+"x"+(p.height*tileNum));

    // remove extension from filename
    if(!new java.io.File(tileFilename).isAbsolute())
      tileFilename=p.sketchPath(tileFilename);
    tileFilename=noExt(tileFilename);
    p.createPath(tileFilename);

    // save preview
    if(doSavePreview) p.g.save(tileFilename+"_preview.png");

    // set up off-screen buffer for saving tiled images
    tileImg=new PImage(p.width*tileNum, p.height*tileNum);

    // start tiling
    done=false;
    isTiling=false;
    perc=0;
    percMilestone=0;
    tileInc();
  }

  // set filetype, default is TGA. pass a valid image extension as parameter.
  public void setSaveType(String extension) {
    tileFileextension=extension;
    if(tileFileextension.indexOf(".")==-1) tileFileextension="."+tileFileextension;
  }

  // pre() handles initialization of each frame.
  // It should be called in draw() before any drawing occurs.
  public void pre() {
    if(!isTiling) return;
    if(firstFrame) firstFrame=false;
    else if(secondFrame) {
      secondFrame=false;
      
      // since processing version 1.0.8 (revision 0170) the following line has to be removed,
      //        because updating of the projection works now imediately.
      // tileInc();
    }
    setupCamera();
  }

  // post() handles tile update and image saving.
  // It should be called at the very end of draw(), after any drawing.
  public void post() {
    // If first or second frame, don't update or save.
    if(firstFrame||secondFrame|| (!isTiling)) return;

    // Find image ID from reverse row order
    int imgid=tileImgCnt%tileNum+(tileNum-tileImgCnt/tileNum-1)*tileNum;
    int idx=(imgid+0)%tileNum;
    int idy=(imgid/tileNum);

    // Get current image from sketch and draw it into buffer
    p.loadPixels();
    tileImg.set(idx*p.width, idy*p.height, p.g);

    // Increment tile index
    tileImgCnt++;
    perc=100*((float)tileImgCnt/(float)tileNumSq);
    if(perc-percMilestone>5 || perc>99) {
      p.println(p.nf(perc,3,2)+"% completed. "+tileImgCnt+"/"+tileNumSq+" images saved.");
      percMilestone=perc;
    }

    if(tileImgCnt==tileNumSq) tileFinish();
    else tileInc();
  }

  public boolean checkStatus() {
    return isTiling;
  }


  // tileFinish() handles saving of the tiled image
  public void tileFinish() {
    isTiling=false;

    restoreCamera();

    // save large image to TGA
    tileFilename+="_"+(p.width*tileNum)+"x"+
      (p.height*tileNum)+tileFileextension;
    p.println("Save: "+
      tileFilename.substring(
    tileFilename.lastIndexOf(java.io.File.separator)+1));
    tileImg.save(tileFilename);
    p.println("Done tiling.n");

    // clear buffer for garbage collection
    tileImg=null;
    done=true;
  }

  // Increment tile coordinates
  public void tileInc() {
    if(!isTiling) {
      isTiling=true;
      firstFrame=true;
      secondFrame=true;
      tileImgCnt=0;
    } 
    else {
      if(tileX==tileNum-1) {
        tileX=0;
        tileY=(tileY+1)%tileNum;
      } 
      else
        tileX++;
    }
  }

  // set up camera correctly for the current tile
  public void setupCamera() {
    p.camera(width/2.0f, height/2.0f, cameraZ,
    width/2.0f, height/2.0f, 0, 0, 1, 0);
    if(isTiling) {
      float mod=1f/10f;
      p.frustum(width*((float)tileX/(float)tileNum-.5f)*mod,
      width*((tileX+1)/(float)tileNum-.5f)*mod,
      height*((float)tileY/(float)tileNum-.5f)*mod,
      height*((tileY+1)/(float)tileNum-.5f)*mod,
      cameraZ*mod, 10000);
    }

  }

  // restore camera once tiling is done
  public void restoreCamera() {
    float mod=1f/10f;
    p.camera(width/2.0f, height/2.0f, cameraZ,
    width/2.0f, height/2.0f, 0, 0, 1, 0);
    p.frustum(-(width/2)*mod, (width/2)*mod,
    -(height/2)*mod, (height/2)*mod,
    cameraZ*mod, 10000);
  }

  // checks free memory and gives a suggestion for maximum tile
  // resolution. It should work well in most cases, I've been able
  // to generate 20k x 20k pixel images with 1.5 GB RAM allocated.
  public int getMaxTiles(int width) {

    // get an instance of java.lang.Runtime, force garbage collection
    java.lang.Runtime runtime=java.lang.Runtime.getRuntime();
    runtime.gc();

    // calculate free memory for ARGB (4 byte) data, giving some slack
    // to out of memory crashes.
    int num=(int)(Math.sqrt(
    (float)(runtime.freeMemory()/4)*0.925f))/width;
    p.println(((float)runtime.freeMemory()/(1024*1024))+"/"+
      ((float)runtime.totalMemory()/(1024*1024)));

    // warn if low memory
    if(num==1) {
      p.println("Memory is low. Consider increasing memory settings.");
      num=2;
    }

    return num;
  }

  // strip extension from filename
  public String noExt(String name) {
    int last=name.lastIndexOf(".");
    if(last>0)
      return name.substring(0, last);

    return name;
  }
}



  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_UsingWatzTileSaver_Working" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
