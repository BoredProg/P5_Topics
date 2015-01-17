import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.event.*; 

import processing.opengl.*; 
import processing.data.*; 
import processing.core.*; 
import japplemenubar.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PG_SkyboxViewer2 extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/65008*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/29759*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

//----------------------------------------------------------
//     file:  PG_SkyboxViewer2.pde
//  version:  v1.0  2010-08-02   
//            v2.0  2011-06-05  added: 'n' load next skybox, 
//                                     F10 help, 
//                                     alternate key commands 
//                                     mouse wheel zooming 
//            v2.1  2011-06-07  calling skybox.drawCube();
//            v2.2  2011-11-25  corrected description 
//            v2.3  2012-07-03  corrections for processing v2.0
//   author:  Ing. Gerd Platl   
//   tested:  with processing 1.5.1 (needs OpenGL, do not work with P3D)
//            with processing 2.0 beta6 (works with P3D)
//     note:  at the moment it seems to work only offline
//  purpose:  interactive view of different skyboxes
//----------------------------------------------------------
/*
 * Demonstrates use of u/v coords in vertex() and effect on texture(). 
 * The textures get distorted using the P3D renderer, but looks great using OPENGL.
 * 
 * Please read a detailed description about how skyboxes works at Friedrich A.Lohmuellers page
 *   http://www.f-lohmueller.de/pov_tut/backgrnd/p_sky9.htm
 * There you can also find my Windows Skybox-Viewer for downloading.
 *
 * How to view skyboxes with this sketch:
 * - download a skybox examples (6 texture images) e.g. from
 *     http://www.f-lohmueller.de/pov_tut/skyboxer/skyboxer_3.htm 
 * - create subdirectory 'skyboxes' for this project
 * - copy texture images to the SkyboxViewer/skyboxes subdirectory 
 * - for using other skybox textures see naming conventions at 
 *     http://www.f-lohmueller.de/pov_tut/skyboxer/skyboxer_1.htm
 * - start this SkyboxViewer 
 * - and feel free to look around wherever you want...
 *
 *  mouse input:
 *      left mouse button   rotate skybox 
 *     right mouse button   zoom skybox
 *            mouse wheel   zoom skybox
 *
 *  key input:  
 *                   0 .. 9   select skybox 0..9 
 *             up/down, W/S   scroll up/down
 *   F1, left, A              auto scroll to left
 *   F2, right, D             auto scroll to right
 *                         Q  stop horizontal scrolling
 *   F3 / F4,          + / -  zoom in/out
 *   F5, blanc, return,    N  load next skybox
 *   F6, back, pageUp,     P  load previous skybox  
 *                         J  save "snapshoot.jpg"
 *   F7,                   V  set vertical angle = 0
 *                         H  set horizontal angle = 0
 *   F8,                   Z  zoom reset 
 *   F9,                   R  reset all
 *   F10,                  I  help on/off
 *                         C  senter window
 *                         L  Re-Load current skybox
 *                       Esc  quit             
 */
//----------------------------------------------------------
//import processing.opengl.*;   // otherwise you get an error message!
      // import for mouse wheel event handling 

//int scrWidth = screenWidth;    // use with processing v1.5.1
//int scrHeight = screenHeight;
int scrWidth = displayWidth;     // use with processing v2.0
int scrHeight = displayHeight;

boolean debugKeys = false;    // show key values
boolean showWindowed = true;  // false: start fullscreen
boolean showHelp = false;     // true: show command keys 
boolean loadSkybox = true;    // true: load skybox textures
int skyboxCount = 0;          // number of skyboxes 

skyboxViewer skybox = new skyboxViewer();

//----------------------------------------------------------
public void setup() 
{
  if (showWindowed)
  { //size(800, 600, OPENGL);
    size(1024, 768, OPENGL);
    frame.setLocation(0, 0);  // do not work with v2.0
  }
  else              //  start fullscreen
  { size(scrWidth, scrHeight, OPENGL);  
    frame.setLocation(-3, -32);
  }  

  background(55,145,255);
  textSize(24);
  showText("loading skybox... (press F10 for Help)",12,30); 
  frameRate(120);

  println(">>> SkyboxViewer v2.3 <<<");
  skyboxCount = skybox.getSkyboxFileNames();
  loadSkybox = (skyboxCount > 0);
  println("HINT:  press [F10] to get help!");
  
  frame.addMouseWheelListener(new MouseWheelInput());   // add mouse wheel listener
}
//----------------------------------------------------------
public void draw() 
{
  if (skyboxCount == 0)
  {
    String errorMsg = "Sorry, no skybox image files found at '"+skyboxesDir+"'";
    println(errorMsg);
    showText(errorMsg,22,66);
    noLoop();
    return;
  }

  if (loadSkybox)    // load next skybox ?
  { 
    skybox.loadCurrentSkybox();
    loadSkybox = false;
  }

  // println ("pic: " + frameCount);
  skybox.drawCube();
  
  if (showHelp)                          // F10: show help  
    //showText("v2.3: a/d/q, w/s/v, h,l,p,z/r,s,+/-,<cursorKeys>,<esc>",12,30);  // Absturtz v2.0b6
    showText("v2.3: a/d/q, w/s/v, h,l,p,z/r,s,+/-",12,30);  
}
//----------------------------------------------------------
// show 2d help information
//----------------------------------------------------------
public void showText(String infoText, int x, int y) 
{
  perspective();
  fill(255);
  text(infoText, x,y);  
}
//----------------------------------------------------------
public void centerWindow() 
{
  frame.setLocation((scrWidth - width) / 2
                   ,(scrHeight - height) / 2);
}

//=== event handling ===

//----------------------------------------------------------
// handle mouse input
//----------------------------------------------------------
public void mouseDragged() 
{
  if (mouseButton == LEFT)
  { skybox.addRotationX ((pmouseY-mouseY) * 0.01f);     // LEFT
    skybox.addRotationY ((mouseX-pmouseX) * 0.01f);
  }
  else skybox.addViewAngle ((mouseY-pmouseY) * 0.005f);  // RIGHT
  //println ("mouseDragged: " + mouseButton + "  x=" + rotx + "  y=" + roty + "  field of view: " + fov); 
}
//----------------------------------------------------------
// listen for MouseWheelEvent
//----------------------------------------------------------
class MouseWheelInput implements MouseWheelListener
{ public void mouseWheelMoved(MouseWheelEvent e) 
  { skybox.multViewAngle (1.0f + 0.01f * e.getWheelRotation()); } 
}
//----------------------------------------------------------
// handle mouse button pressed
//----------------------------------------------------------
public void mousePressed() 
{
  if (mousePressed && (mouseButton == CENTER)) 
    skybox.resetRotation();
}
//----------------------------------------------------------
// handle key input
//----------------------------------------------------------
public void keyPressed() 
{ 
  if (debugKeys) print (keyCode + " '" + key + "'    ");
  if       (key     ==   'c')  centerWindow();                    // c: center window
  else if ((key     >=   '1') 
        && (key     <=   '9')) skybox.selectSkybox(keyCode-49);   // 1..9: select skybox
  else if ((key     ==   'r') 
        || (keyCode ==   120)) skybox.resetRotation();            // r, F9: reset all
  else if ((key     ==   'a')
        || (keyCode ==   112)                                     // a, F1
        || (keyCode ==  LEFT)) skybox.addRotationSpeed (-0.001f);  // <- auto scroll to left 
  else if ((key     ==   'd')
        || (keyCode ==   113)                                     // d, F2
        || (keyCode == RIGHT)) skybox.addRotationSpeed (+0.001f);  // -> auto scroll to right
  else if ((key     ==   'q')
        || (keyCode ==   127)) skybox.setRotationSpeed (0.0f);   // Q: stop scrolling
  else if  (key     ==   'h')  skybox.setRotationY (0.0f);       // H: set horizontal angle = 0 
  else if ((keyCode ==   118) 
        || (key     ==   'v')) skybox.setRotationX (0.0f);       // F7, V: set vertical angle = 0 
  else if ((key     ==   'w') 
        || (keyCode ==    UP)) skybox.addRotationX (0.01f);     // W: scroll up
  else if ((key     ==   's')
        || (keyCode ==  DOWN)) skybox.addRotationX (-0.01f);    // S: scroll down
  else if ((keyCode ==   114)  
        || (key     ==   '+')) skybox.multViewAngle (1/1.01f);  // F3, +  zoom in
  else if ((keyCode ==   115)                    
        || (key     ==   '-')) skybox.multViewAngle (1.01f);  // F4, -  zoom out
  else if  (key     ==   'z')  skybox.setViewAngle(1.8f);     // zoom reset
  else if ((keyCode ==   116)                                // F5
        || (keyCode ==    10)                                // return
        || (keyCode ==    32)                                // blanc
        || (keyCode ==    34)                                // pageDown
        || (key     ==   'n')) skybox.loadNextSkybox();      // N:  load next skybox
  else if  (key     ==   'l')  skybox.loadCurrentSkybox();   // L:  re-load skybox
  else if ((keyCode ==   117)                                // F6, 
        || (keyCode ==     8)                                // backSpace
        || (keyCode ==    33)                                // pageUp
        || (key     ==   'p')) skybox.loadPreviousSkybox();  // P:
  else if  (key     ==   'j')  save ("snapshoot.jpg");  // save current view as JPeg picture
  else if ((key     ==   'i')
        || (keyCode ==   121)) showHelp = !showHelp;    // F10,  I: toggle help text
  else if  (keyCode ==    27);                          // ESC
  else println ("unhandled key input");      
}


//----------------------------------------------------------
//     file:  SkyboxViewer.pde
//  version:  v2.0   2011-06-05   
//            v2.1   2011-06-07  added skybox.drawCube()
//            v2.2   2012-08-03  unusing 'textureMode(NORMALIZED);'
//   author:  Ing. Gerd Platl   
//   tested:  with processing 1.5.1 (start with OPENGL)
//            with processing 2.0 beta6 (works with P3D)
//  purpose:  class to load and view different skyboxes
//----------------------------------------------------------

String skyboxesDir = "Skyboxes";

//-- methods -----------------------------------------------
//   getSkyboxFileNames    get skybox file names
//   addSkyboxFileNames    add skybox file names to global lists
//   loadImageFile         load skybox image file
//   selectSkybox          load skybox by number (1..n) 
//   loadPreviousSkybox    load previous skybox images 
//   loadNextSkybox        load next skybox images  
//   drawCube              draw textured skybox cube
//----------------------------------------------------------
class skyboxViewer 
{
  float boxSize = 100000; // skybox size
  float rotx    = 0.0f;    // rotation about x-axis
  float roty    = 0.0f;    // rotation about y-axis
  float speed   = 0.0006f; // rotation x speed
  float maxRS   = 0.01f;   // maximum rotation speed x
  float fov     = 1.8f;    // vertical field-of-view angle (in radians) 

  // skybox file names without orientation part 
  String[] skyboxFileNames = new String[100]; 
  String[] skyboxFileExt = new String[100]; 

  int filenameCount = 0;
  int filenameIndex = 0;

  PImage tex1,tex2,tex3,tex4,tex5,tex6;   // texture images

//----------------------------------------------------------
// get skybox file names & extentions
//----------------------------------------------------------
public int getSkyboxFileNames()
{
  println("--- skyboxes ---");
  String path = sketchPath + "\\" + skyboxesDir;
  
  File f = new File(path);
  if (!f.isDirectory())
    println("can't find directory " + path);
  else
  { println(path);
    addSkyboxFileNames (path, ".png");
    addSkyboxFileNames (path, ".jpg");
    addSkyboxFileNames (path, ".gif");
    addSkyboxFileNames (path, ".tga");
    addSkyboxFileNames (path, ".bmp");
  }
  return filenameCount;
}  

//----------------------------------------------------------
// add skybox file names & extentions to global lists
//----------------------------------------------------------
public void addSkyboxFileNames(String path, String ext) 
{
  File file = new File(path);
  //println("path=" +path+"\\*"+ext);
  if (!file.isDirectory()) return;
  String names[] = file.list();
  for (int ni=0; ni<names.length; ni++)
  { 
    String name = names[ni];
    int sp = name.indexOf(ext);
    if (sp > 0) sp = name.indexOf("_Front");
    if (sp > 0)
    {  skyboxFileNames[filenameCount] = names[ni].substring(0,sp);
       skyboxFileExt[filenameCount] = ext;
       println(filenameCount+1 + ": " + skyboxFileNames[filenameCount] + '*' + ext);
       filenameCount++;
} } }
//----------------------------------------------------------
// load image file (with exception handling)
//----------------------------------------------------------
public PImage loadImageFile (String imageName)
{ 
  PImage tempImage = null;
  boolean makeImage = true;
  try
  { //File f = new File(imageName);
    //if (f.exists())
    {
      tempImage = loadImage(imageName);
      makeImage = (tempImage.width <= 2);
      //println("pic=" + tempImage.width + '*' + tempImage.height);
    }  
  }
  catch (Exception  ex)
  { println("\n  ERROR at loading image file '" + imageName + "'");
    //println(" >>> " + ex.toString());   // ex.getMessage()
    makeImage = true;
  }
  if (makeImage)
  { tempImage = createImage(256, 256, ARGB);
    tempImage.set(10,10, color(random(127,255),0,0));  // red image
  }
  return tempImage;
}
//----------------------------------------------------------
// load skybox by number (1..n) 
//----------------------------------------------------------
public void selectSkybox(int skyboxIndex)
{
  filenameIndex = skyboxIndex % filenameCount;
  loadCurrentSkybox ();
}
//----------------------------------------------------------
// load previous skybox images 
//----------------------------------------------------------
public void loadPreviousSkybox ()
{ 
  filenameIndex = (filenameIndex+filenameCount-1) % filenameCount;
  loadCurrentSkybox ();
}
//----------------------------------------------------------
// load next skybox images  
//----------------------------------------------------------
public void loadNextSkybox ()
{ 
  filenameIndex = (filenameIndex+1) % filenameCount;
  loadCurrentSkybox ();
}
//----------------------------------------------------------
// load six skybox images as cube texture
//----------------------------------------------------------
public void loadCurrentSkybox ()
{ 
  String skyboxName = skyboxFileNames[filenameIndex];
  String ext = skyboxFileExt[filenameIndex];
  String info = PApplet.parseChar(10)+"loading skybox " + (filenameIndex+1) 
                        + ":  " + skyboxName + "*" + ext;
  print (info);
  showText (info,22,22);
  cursor(WAIT);
  String name = skyboxesDir + "/" + skyboxName; 

  try
  { tex1 = loadImageFile (name + "_Front" + ext);
    tex2 = loadImageFile (name + "_Back" + ext);
    tex3 = loadImageFile (name + "_Left" + ext);
    tex4 = loadImageFile (name + "_Right" + ext);
    tex5 = loadImageFile (name + "_Base" + ext);
    tex6 = loadImageFile (name + "_Top" + ext);
    if (tex1 != null) println ("   " + tex1.width + '*' + tex1.height + "  OK");
  }
  catch (Exception ex) 
  { println("  error at loading "+name+"_*"+ext); 
  }
  finally { }
  cursor(CROSS);
}

//----------------------------------------------------------
// define cube edges
//----------------------------------------------------------
float p = boxSize / 2;   // half skybox size
float m = -p;

PVector P000 = new PVector (m,m,m);
PVector P010 = new PVector (m,p,m);
PVector P110 = new PVector (p,p,m);
PVector P100 = new PVector (p,m,m);
PVector P001 = new PVector (m,m,p);
PVector P011 = new PVector (m,p,p);
PVector P111 = new PVector (p,p,p);
PVector P101 = new PVector (p,m,p);

//----------------------------------------------------------
// assign 6 textures to the 6 cube faces
//----------------------------------------------------------
public void TexturedCube() 
{
  TexturedCubeSide (P100, P000, P010, P110, tex1);   // -Z "Front" face
  TexturedCubeSide (P001, P101, P111, P011, tex2);   // +Z "Back" face
  TexturedCubeSide (P000, P001, P011, P010, tex3);   // -X "Left" face
  TexturedCubeSide (P101, P100, P110, P111, tex4);   // +X "Right" face
  TexturedCubeSide (P110, P010, P011, P111, tex5);   // +Y "Base" face
  TexturedCubeSide (P101, P001, P000, P100, tex6);   // -Y "Top" face
}

//----------------------------------------------------------
// create a cube side given by 4 edge vertices and a texture
//----------------------------------------------------------
public void TexturedCubeSide(PVector P1, PVector P2, PVector P3, PVector P4, PImage tex)
{
  beginShape(QUADS);
    if (tex == null) return;
    texture(tex);    // 2048 = max. texture size
    vertex (P1.x, P1.y, P1.z, 2048,    0);
    vertex (P2.x, P2.y, P2.z,    0,    0);
    vertex (P3.x, P3.y, P3.z,    0, 2048);
    vertex (P4.x, P4.y, P4.z, 2048, 2048);
  endShape();
}
//----------------------------------------------------------
// draw the skybox cube
//----------------------------------------------------------
public void drawCube()
{
  background(128);   // clear background and reset zBuffer
  noStroke();        // set it under comment to see cube edges
  pushMatrix();
    fov = constrain (fov, 0.1f, 3.0f);
    perspective(fov, PApplet.parseFloat(width)/height, 1, boxSize*1.2f);

    translate(width*0.5f, height*0.5f, 0);
    speed = constrain (speed, -maxRS,  maxRS); 
    roty += speed;
    rotateX(rotx);
    rotateY(roty);
    skybox.TexturedCube();
  popMatrix();
}

//----------------------------------------------------------
// set/change rotation, rotation speed, field of view  
//----------------------------------------------------------
public void resetRotation()  { rotx=0;  roty=0;  speed = 0.0f;  fov  = 1.8f; } 

public void setRotationX(float xRotation)  { rotx = xRotation; } 
public void setRotationY(float yRotation)  { roty = yRotation; } 
public void setRotationSpeed(float xSpeed) { speed= xSpeed; } 
public void setViewAngle(float viewAngle)  { fov  = viewAngle; } 
public void multViewAngle(float viewMult)  { fov *= viewMult; }

public void addRotationX(float xDelta)     { rotx += xDelta; } 
public void addRotationY(float yDelta)     { roty += yDelta; } 
public void addRotationSpeed(float sDelta) { speed+= sDelta; } 
public void addViewAngle(float viewDelta)  { fov  += viewDelta; } 

}  // end of class skyboxViewer

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PG_SkyboxViewer2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
