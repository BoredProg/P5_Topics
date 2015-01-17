
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
  float rotx    = 0.0;    // rotation about x-axis
  float roty    = 0.0;    // rotation about y-axis
  float speed   = 0.0006; // rotation x speed
  float maxRS   = 0.01;   // maximum rotation speed x
  float fov     = 1.8;    // vertical field-of-view angle (in radians) 

  // skybox file names without orientation part 
  String[] skyboxFileNames = new String[100]; 
  String[] skyboxFileExt = new String[100]; 

  int filenameCount = 0;
  int filenameIndex = 0;

  PImage tex1,tex2,tex3,tex4,tex5,tex6;   // texture images

//----------------------------------------------------------
// get skybox file names & extentions
//----------------------------------------------------------
int getSkyboxFileNames()
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
void addSkyboxFileNames(String path, String ext) 
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
PImage loadImageFile (String imageName)
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
void selectSkybox(int skyboxIndex)
{
  filenameIndex = skyboxIndex % filenameCount;
  loadCurrentSkybox ();
}
//----------------------------------------------------------
// load previous skybox images 
//----------------------------------------------------------
void loadPreviousSkybox ()
{ 
  filenameIndex = (filenameIndex+filenameCount-1) % filenameCount;
  loadCurrentSkybox ();
}
//----------------------------------------------------------
// load next skybox images  
//----------------------------------------------------------
void loadNextSkybox ()
{ 
  filenameIndex = (filenameIndex+1) % filenameCount;
  loadCurrentSkybox ();
}
//----------------------------------------------------------
// load six skybox images as cube texture
//----------------------------------------------------------
void loadCurrentSkybox ()
{ 
  String skyboxName = skyboxFileNames[filenameIndex];
  String ext = skyboxFileExt[filenameIndex];
  String info = char(10)+"loading skybox " + (filenameIndex+1) 
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
void TexturedCube() 
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
void TexturedCubeSide(PVector P1, PVector P2, PVector P3, PVector P4, PImage tex)
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
void drawCube()
{
  background(128);   // clear background and reset zBuffer
  noStroke();        // set it under comment to see cube edges
  pushMatrix();
    fov = constrain (fov, 0.1, 3.0);
    perspective(fov, float(width)/height, 1, boxSize*1.2);

    translate(width*0.5, height*0.5, 0);
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
void resetRotation()  { rotx=0;  roty=0;  speed = 0.0;  fov  = 1.8; } 

void setRotationX(float xRotation)  { rotx = xRotation; } 
void setRotationY(float yRotation)  { roty = yRotation; } 
void setRotationSpeed(float xSpeed) { speed= xSpeed; } 
void setViewAngle(float viewAngle)  { fov  = viewAngle; } 
void multViewAngle(float viewMult)  { fov *= viewMult; }

void addRotationX(float xDelta)     { rotx += xDelta; } 
void addRotationY(float yDelta)     { roty += yDelta; } 
void addRotationSpeed(float sDelta) { speed+= sDelta; } 
void addViewAngle(float viewDelta)  { fov  += viewDelta; } 

}  // end of class skyboxViewer

