import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.jogamp.opengl.util.gl2.GLUT; 
import java.nio.*; 
import java.util.*; 
import javax.media.opengl.GL2; 
import javax.media.opengl.glu.GLU; 
import remixlab.proscene.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_ShadersGalore_Blinn_Toon_Bump_04 extends PApplet {

/****************************************************************************************
*
*  Shaders Galore !
*  =================
*
*  Keys : 
*    - "." and "0" to "9"  : shader selection
*
*    - "/"                 : Select Previous Material Preset
*    - "*"                 : Select Next Material Preset 
*
****************************************************************************************/









// ProScene..
Scene           scene;

// OpenGL
PJOGL           pgl;
GL2             gl;
GLU             glu;  
GLUT            glut;

// Shaders and shader variables..
PShader         activeShader;

PShader         toonShader;
PShader         blinnShader;
PShader         perPixelLightShader;
PShader         goochShader;
PShader         adaptiveAaShader;
PShader         latticeShader;
PShader         wardIsotropicShader;
PShader         minnaertWardShader;
PShader         wiggleShader;
PShader         brickShader;

// all these variables for the "Bump map" shader.
PShaderCustom   bumpMapShader; 
int[]           textureIds;
PImage          diffuseTextureImage;
PImage          bumpTextureImage;
float[]         projMatrix       = new float[16];
float[]         modelMatrix      = new float[16];
int[]           shaderimgloc;
int             tangentLoc;
int             binormalLoc;
int             uir;
int             cbs;

// Materials..
Material       material;
Materials      materials;

PShape         pShape;
float          angle;



/************************************************************************
*
*  SETUP
*
************************************************************************/

public void setup() 
{  
  // Size and frame location.
  size(1920, 1080, P3D);
  frame.setLocation(1930,10);
  
  // Creates needed OpenGL objects.
  pgl         = (PJOGL)beginPGL();
  gl          = pgl.gl.getGL2();

  smooth();

  // Init Material Presets.
  materials = new Materials();

  // Init OpenGL.
  initGl();
  
  //initProScene();
    
  // Init light and create two OpenGL lights, one directional and one spot.
  initLights();  
    
  // Loads the textures into OpenGL.
  initTextures();
  
  // Create the Shaders !
  createShaders();

  // sets the Processing texturing mode.
  textureMode(NORMAL);
    
  // Set the active Shader.
  activeShader = perPixelLightShader;
  
  // create a PShape.
  pShape = createCan();
  
};




/************************************************************************
*
*  DRAW
*
************************************************************************/
public void draw() 
{ 
  background(50);
  
  // Sets the frame's Title to display FPS, active shader, and active material.
  setFrameTitle();
  
  pointLight(255, 255, 255, width/2, height, 200);
  
  // draw all 10 shaders..
  //drawShapes();
    
  // Setup shape position, scale and rotation.
  gl.glPushMatrix();
  gl.glTranslatef(displayWidth/2, displayHeight/2, 0);
  
  gl.glRotatef(angle,0,1,0); 
  gl.glRotatef(angle * 1.02f ,1,0,0);  
  
  // Processing Y scale mode.  
  gl.glScalef(1,-1,1);
      
  // Set Shape Material.
  setMaterial();    
  
  // Binds the active shader.
  activeShader.bind();

  // draws the geometry.  
  drawShape();
    
  // Unbinds the active shader.
  activeShader.unbind();
  
  gl.glPopMatrix();
  angle += 0.67f;
  

}


/************************************************************************
* drawShape() : draws the Shape that will be affected by the 
*               active shader.
************************************************************************/

public void drawShape()
{
  if (activeShader == perPixelLightShader)
  {        
    pushMatrix();
    pointLight(255, 255, 255, width/2, height, 400);
    translate(width/2, height/2, 0);
    rotateY(angle * 0.02f); 
    rotateX(angle * 0.002f);  
    //fill(255,80,80);  
    shape(pShape);
    popMatrix();  
  }
  
  else
  {    
    
    // Draw the specified OpenGL Shape.  
    glut.glutSolidTeapot(300);
  
    //glut.glutSolidSphere(300f, 64,64);
    //glut.glutSolidTorus(150,300,92,92);
    
    //drawLine3D(new PVector(0,0,0), new PVector(200,-200,300), 30, color(255,0,0));
   
    //gl.glScalef(200,200,200);
    //drawGlCube();
   
    //gl.glScalef(200,200,200); 
    //glut.glutSolidDodecahedron();
  }
}

/************************************************************************
* drawShapes() : draws 10 shapes that will be affected by the 
*               10 shaders.
************************************************************************/
public void drawShapes()
{
  PShader currentShader;
  
  PShader[] allShaders = { 
                           blinnShader,
                           toonShader,
                           bumpMapShader,
                           goochShader,
                           adaptiveAaShader,
                           latticeShader,
                           wardIsotropicShader,
                           minnaertWardShader,
                           wiggleShader,
                           brickShader,
                         };

  Vec3 cellSize = new Vec3(displayWidth / 3f, displayHeight / 3f, 0);
  
  float shapeSize = 160;
  float posX = 0;
  float posY = 0;


  for (int i = 0; i <= allShaders.length - 1; i++)
  {        
    currentShader = allShaders[i];
    currentShader.bind();
              
    
    gl.glPushMatrix();
    
    posX = cellSize.x * i + cellSize.x /2;
    posY = 240; //cellSize.y * i;
    
    if (i == 3 || i == 6 )
    {
      posX = cellSize.x /2;
      posY += cellSize.y;
        
    }

    
    gl.glTranslatef(posX, posY, 0f);
    
    gl.glRotatef(angle,0,1,0); 
    gl.glRotatef(angle * 1.02f ,1,0,0);  
    
    // Processing Y scale mode.  
    gl.glScalef(1,-1,1);
      
    // Set Shape Material.
    setMaterial();        
     
     // draw the geometry.
    glut.glutSolidTeapot(shapeSize);
    
    gl.glPopMatrix();  
    currentShader.unbind();
           
    
    angle += 0.067f;
    
  };

    
    
  activeShader = perPixelLightShader;
  
  if (activeShader == perPixelLightShader)
  {        
    pushMatrix();
    pointLight(255, 255, 255, width/2, height, 400);
    translate(width/2, height/2, 0);
    rotateY(angle * 0.02f); 
    rotateX(angle * 0.002f);  
    //fill(255,80,80);  
    shape(pShape);
    popMatrix();  
  }
  
  else
  {    
    
    // Draw the specified OpenGL Shape.  
    glut.glutSolidTeapot(300);
  
    //glut.glutSolidSphere(300f, 64,64);
    //glut.glutSolidTorus(150,300,92,92);
    
    //drawLine3D(new PVector(0,0,0), new PVector(200,-200,300), 30, color(255,0,0));
   
    //gl.glScalef(200,200,200);
    //drawGlCube();
   
    //gl.glScalef(200,200,200); 
    //glut.glutSolidDodecahedron();
  }  
}



/*****************************************************************************************************
*  createShaders() :
*  -----------------
*
*  Initialize and feed all the shaders !
*****************************************************************************************************/
public void createShaders()
{
    // Creates the "per-pixel lighting" shader..
  perPixelLightShader = new PShader(this, perPixelShaderVertexCode, perPixelShaderFragmentCode);
  
  // Creates the Blinn-Phong Shader
  blinnShader = new PShader(this, blinnShaderVertexCode, blinnShaderFragmentCode ); 
  blinnShader.set("numLights",2);
    
  // Creates the ToonShader.
  toonShader = new PShader(this, toonShaderVertexCode, toonShaderFragmentCode );
    
  // Creates the BumpMap shader;
  bumpMapShader = new PShaderCustom(this, bumpMapShaderVertexCode, bumpMapShaderFragmentCode);  
  
  bindTextures();  
  // get location of shader 'attribute' variables.
  tangentLoc       =  bumpMapShader.getAttributeLocation("tangent");
  binormalLoc      =  bumpMapShader.getAttributeLocation("binormal");   
  // sets the uniforms. 
  bumpMapShader.set("Base", 2);    
  bumpMapShader.set("NormalHeight", 1); 
  bumpMapShader.set("BumpSize",  0.02f * 2.0f, 0.02f * - 1.0f);        
  gl.glVertexAttrib3f(tangentLoc , -1,  0, 0);
  gl.glVertexAttrib3f(binormalLoc,  0, -1, 0);    
  
      
  // Creates the Gooch Shader
  goochShader = new PShader(this, goochShaderVertexCode, goochShaderFragmentCode );
  goochShader.set("LightPosition", 0.0f,  10.0f,   4.0f);
  goochShader.set("CoolColor",     0.0f,   0.0f,   0.6f);    
  goochShader.set("DiffuseCool",   0.45f);
  goochShader.set("DiffuseWarm",   0.45f);
  goochShader.set("SurfaceColor",  1.0f,   0.75f,   0.75f);    
  goochShader.set("WarmColor",     0.6f,   0.6f,    0.0f);       
  
  // Creates the "Adaptive Anti-Alias Stripes"
  adaptiveAaShader = new PShader(this, adaptiveAaShaderVertexCode, adaptiveAaShaderFragmentCode );
  adaptiveAaShader.set("Frequency", 18f);  // Stripes frequency.
  adaptiveAaShader.set("LightPosition", 0.0f, 0.0f, 4.0f); 
  
  // Creates the Lattice Shader
  latticeShader = new PShader(this, latticeShaderVertexCode, latticeShaderFragmentCode );
  
  latticeShader.set("Ambient",       0.1f,  0.1f,  0.1f);
  latticeShader.set("EyePosition",   0.0f,  0.0f,  0.0f);
  latticeShader.set("Kd", 1);
  latticeShader.set("LightColor",    1.0f,  1.0f,  1.0f);
  latticeShader.set("LightPosition", 0.0f, 10.0f,  4.0f);
  latticeShader.set("Scale",         15.0f,  15.0f);
  latticeShader.set("Specular",      0f,    1f,    0f);
  latticeShader.set("SurfaceColor",  1f,    1f,    0f);
  latticeShader.set("Threshold",     0.2f,  0.2f);
  
  // Creates the Ward Isotropic Shader.
  wardIsotropicShader = new PShader(this, wardIsotropicShaderVertexCode, wardIsotropicShaderFragmentCode);
  
  // Creates the Minnaert Ward Shader
  minnaertWardShader = new PShader(this, minnaertWardShaderVertexCode, minnaertWardShaderFragmentCode);
  minnaertWardShader.set("ior",        1.9f);
  minnaertWardShader.set("k",          1.5f);
  minnaertWardShader.set("roughness",  0.15f);
  
  // Creates the "Wiggle" Shader ;-)
  wiggleShader  = new PShader(this, wiggleShaderVertexCode, wiggleShaderFragmentCode);
  wiggleShader.set("freq",   2.0f,  2.5f);
  wiggleShader.set("scale",  0.5f,  0.2f);
  
  // Creates the "Bricks" Shader
  brickShader   = new PShader(this, brickShaderVertexCode, brickShaderFragmentCode);  
  brickShader.set("BrickColor",     1f,    0.3f, 0.2f);
  brickShader.set("BrickPct",       0.9f,  0.85f);
  brickShader.set("BrickSize",      0.3f,  0.15f);
  brickShader.set("LightPosition",  0.0f,  0.0f,  4.0f);
  brickShader.set("MortarColor", 0.85f, 0.86f, 0.84f);

};






/************************************************************************
* initProScene()  :  Init the ProScene camera and apply camera settings.
************************************************************************/

private void initProScene()
{
  
  // INIT PROSCENE
  scene = new Scene(this);
  //scene.disableKeyboardHandling();
  scene.setAxisIsDrawn(true);
  scene.setGridIsDrawn(true);
  scene.drawGrid(100, 20);
  //scene.setLeftHanded();
  scene.setRadius(50000);
    
}


/************************************************************************
* setMaterial() : Sets the current Material
************************************************************************/

private void setMaterial()
{
  // get the current MaterialPreset.
  material = materials.getMaterial(materialNames[materialIndex]);   
  
  // Apply the Material.
  gl.glMaterialfv(GL2.GL_FRONT_AND_BACK, GL2.GL_AMBIENT,    FloatBuffer.wrap(material.ambient.toArray()));
  gl.glMaterialfv(GL2.GL_FRONT_AND_BACK, GL2.GL_DIFFUSE,    FloatBuffer.wrap(material.diffuse.toArray()));
  gl.glMaterialfv(GL2.GL_FRONT_AND_BACK, GL2.GL_SPECULAR,   FloatBuffer.wrap(material.specular.toArray()));
  gl.glMaterialfv(GL2.GL_FRONT_AND_BACK, GL2.GL_EMISSION,   FloatBuffer.wrap(material.emissive.toArray()));
  gl.glMaterialf (GL2.GL_FRONT_AND_BACK, GL2.GL_SHININESS,  material.shininess * 128 );
}


/************************************************************************
* initGl()  :  Inits OpenGL.
************************************************************************/

public void initGl()
{        
  pgl  = (PJOGL) beginPGL();
  glu  = pgl.glu;
  glut = new GLUT();
  gl   = GLU.getCurrentGL().getGL2();
  
  gl.setSwapInterval(1);  
  gl.glShadeModel(GL2.GL_SMOOTH);                                  //Enable Smooth Shading
    
  gl.glClearDepth(1.0f);                                           //Depth Buffer Setup
  gl.glEnable(GL2.GL_DEPTH_TEST);                                  //Enables Depth Testing
  gl.glDepthFunc(GL2.GL_LEQUAL);                                   //The Type Of Depth Testing To Do
  gl.glHint(GL2.GL_PERSPECTIVE_CORRECTION_HINT, GL2.GL_NICEST);    //Really Nice Perspective Calculations
    
  gl.glEnable(GL2.GL_CULL_FACE);
  gl.glCullFace(GL2.GL_BACK);
  
}


/************************************************************************
* initLights()    :  Init OpenGL lighting and creates two lights,
*                    one directional and one spot light.
************************************************************************/

public void initLights()
{  
  float[] lightAmbient   = { 0.1f, 0.1f, 0.1f,  1.0f};
  float[] lightDiffuse   = { 0.7f, 0.7f, 0.7f,  1.0f};
  float[] lightSpecular  = { 0.5f, 0.5f, 0.5f,  1.0f};
  float[] lightPosition  = {-1.5f, 1.0f, -4.0f, 1.0f};
  
  
  // Light model parameters:
  float lightModelAmbient[] = { 0.0f, 0.0f, 0.0f, 0.0f  };
  gl.glLightModelfv(GL2.GL_LIGHT_MODEL_AMBIENT, FloatBuffer.wrap(lightModelAmbient));
  
  gl.glLightModelf(GL2.GL_LIGHT_MODEL_LOCAL_VIEWER, 1.0f);
  gl.glLightModelf(GL2.GL_LIGHT_MODEL_TWO_SIDE, 0.0f);
    
  // SETUP LIGHT 1 (Directional ? Light )
  // Common properties : ambient, diffuse, specular, position (which is direction in this case I think).
  gl.glLightfv(GL2.GL_LIGHT1, GL2.GL_AMBIENT, lightAmbient, 0);
  gl.glLightfv(GL2.GL_LIGHT1, GL2.GL_DIFFUSE, lightDiffuse, 0);
  gl.glLightfv(GL2.GL_LIGHT1, GL2.GL_SPECULAR, lightSpecular, 0);
  gl.glLightfv(GL2.GL_LIGHT1, GL2.GL_POSITION, lightPosition, 0);
  gl.glEnable(GL2.GL_LIGHTING);
  gl.glEnable(GL2.GL_LIGHT1);
  
  // Don't know what it does..
  gl.glEnable(GL2.GL_NORMALIZE);

  // SETUP LIGHT 0 ( Spot Light )
         
  // Spotlight Parameters..
  float spotDirection[]   = {1.0f, -1.0f, -1.0f};
  int spotExponent        = 30;
  int spotCutoff          = 180;
  
  gl.glLightfv(GL2.GL_LIGHT0,     GL2.GL_SPOT_DIRECTION,    FloatBuffer.wrap(spotDirection));  // Direction
  gl.glLighti(GL2.GL_LIGHT0,      GL2.GL_SPOT_EXPONENT,     spotExponent);                     // Exponent
  gl.glLighti(GL2.GL_LIGHT0,      GL2.GL_SPOT_CUTOFF,       spotCutoff);                       // CutOff
  
  float contantAttenuation   = 1.0f;
  float linarAttenuation     = 0.0f;
  float quadraticAttenuation = 0.0f;
  
  gl.glLightf(GL2.GL_LIGHT0, GL2.GL_CONSTANT_ATTENUATION,   contantAttenuation);              // ContantAttenuation
  gl.glLightf(GL2.GL_LIGHT0, GL2.GL_LINEAR_ATTENUATION,     linarAttenuation);                  // LinarAttenuation
  gl.glLightf(GL2.GL_LIGHT0, GL2.GL_QUADRATIC_ATTENUATION,  quadraticAttenuation);           // QuadraticAttenuation
  
  // Common properties (ambient, diffuse, specular, position)..
  gl.glLightfv(GL2.GL_LIGHT0, GL2.GL_POSITION, FloatBuffer.wrap(lightPosition));
  gl.glLightfv(GL2.GL_LIGHT0, GL2.GL_AMBIENT, FloatBuffer.wrap(lightAmbient));
  gl.glLightfv(GL2.GL_LIGHT0, GL2.GL_DIFFUSE, FloatBuffer.wrap(lightDiffuse));
  gl.glLightfv(GL2.GL_LIGHT0, GL2.GL_SPECULAR, FloatBuffer.wrap(lightSpecular));
  
  
  // ENABLE LIGHT0 AND LIGHT 1
  gl.glEnable(GL2.GL_LIGHTING);
  
  gl.glEnable(GL2.GL_LIGHT0);
  gl.glEnable(GL2.GL_LIGHT1);
}


/************************************************************************
* initTextures()  :  Loads the two textures for the bump map 
*                    into OpenGL.
************************************************************************/

private void initTextures()
{
   diffuseTextureImage  = loadImage("stones_diffuse.jpg");
   bumpTextureImage     = loadImage("stones_height.tga");
   
   //diffuseTextureImage  = loadImage("aa_diffuse.jpg");
   //bumpTextureImage     = loadImage("aa_bump.png");
 
  textureIds = new int[2];  
  gl.glGenTextures(2,textureIds,0);

  gl.glBindTexture(GL2.GL_TEXTURE_2D,textureIds[0]);
  gl.glTexImage2D(GL2.GL_TEXTURE_2D, 0, 4, diffuseTextureImage.width, diffuseTextureImage.height, 0, GL2.GL_BGRA, GL2.GL_UNSIGNED_BYTE, IntBuffer.wrap(diffuseTextureImage.pixels));
  gl.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MIN_FILTER,GL2.GL_LINEAR);  // Linear Filtering
  gl.glTexParameteri(GL2.GL_TEXTURE_2D, GL2.GL_TEXTURE_MAG_FILTER,GL2.GL_LINEAR);  // Linear Filtering

  gl.glBindTexture(GL2.GL_TEXTURE_2D,textureIds[1]);
  gl.glTexImage2D(GL2.GL_TEXTURE_2D, 0, 4, bumpTextureImage.width, bumpTextureImage.height, 0, GL2.GL_BGRA, GL2.GL_UNSIGNED_BYTE, IntBuffer.wrap(bumpTextureImage.pixels));
  gl.glTexParameteri(GL2.GL_TEXTURE_2D,GL2.GL_TEXTURE_MIN_FILTER,GL2.GL_LINEAR);  // Linear Filtering
  gl.glTexParameteri(GL2.GL_TEXTURE_2D,GL2.GL_TEXTURE_MAG_FILTER,GL2.GL_LINEAR);  // Linear Filtering
}

/************************************************************************
* bindTextures()  :  binds the two textures for the bump map shader.
************************************************************************/
private void bindTextures()
{
   gl.glActiveTexture(GL2.GL_TEXTURE0+2);
   gl.glBindTexture(GL2.GL_TEXTURE_2D, textureIds[0]);
  
   gl.glActiveTexture(GL2.GL_TEXTURE0+1);
   gl.glBindTexture(GL2.GL_TEXTURE_2D, textureIds[1]);
}

public void keyPressed()
{

  switch (key)
  {
    
    ////////////////////////////////////////////////////////////////////
    //  Set active Shader
    ////////////////////////////////////////////////////////////////////
    case '0':
      activeShader = perPixelLightShader;
      break;

    case '1':
      activeShader = blinnShader;
      break;
      
    case '2':
      activeShader = toonShader;
      break;

    case '3':
      activeShader = bumpMapShader;
      break;      

    case '4':
      activeShader = goochShader;
      break;      

    case '5':
      activeShader = adaptiveAaShader;
      break;      

    case '6':
      activeShader = latticeShader;
      break;      

    case '7':
      activeShader = wardIsotropicShader;
      break;      

    case '8':
      activeShader = minnaertWardShader;
      break;      

    case '9':
      activeShader = wiggleShader;
      break;      

    case '.':
      activeShader = brickShader;
      break;      

    ////////////////////////////////////////////////////////////////////
    //  Set active Material
    ////////////////////////////////////////////////////////////////////


    case '/':
      materialIndex--;    
      materialIndex = materialIndex <0 ? materialNames.length -1 : materialIndex;   
      break;      


    case '*':
      materialIndex ++;    
      materialIndex = materialIndex <= materialNames.length -1 ? materialIndex : 0;       
      break;      

    
    default:
      break;
  }
  
  // Sets the frame title to display active shader name
  // and active Material
  setFrameTitle();
 
};




/**
* Sets the frame title to display active shader name
* and active Material
*/
private void setFrameTitle()
{
    // Set shader name (for display)
  String shaderName = "";  
  String frameTitle;
  
  if (activeShader == perPixelLightShader)
  {
    shaderName = "Per Pixel Lighting (P5)";
  }
  else if (activeShader == blinnShader)
  {
    shaderName = "Blinn-Phong Lighting (GL)";  
  }
  else if (activeShader == toonShader)
  {
     shaderName = "Toon Shader (GL)";    
  }
  else if (activeShader == bumpMapShader)
  {
    shaderName = "Bump Map Shader (GL)";
  }
  else if (activeShader == goochShader)
  {
    shaderName = "Gooch Shader (GL)";
  }
  else if (activeShader == adaptiveAaShader)
  {
    shaderName = "Adaptive AA (GL)";
  }
  else if (activeShader == latticeShader)
  {
    shaderName = "Lattice Shader (GL)";
  }
  else if (activeShader == wardIsotropicShader)
  {
    shaderName = "Ward Isotropic Shader (GL)";
  }
  else if (activeShader == minnaertWardShader)
  {
    shaderName = "Minnaert Ward Shader (GL)";
  }
  else if (activeShader == wiggleShader)
  {
    shaderName = "Wiggle Shader (GL)";
  }
  else if (activeShader == brickShader)
  {
    shaderName = "Bricks Shader (GL)";
  }
 
  else
  {
    shaderName = "NO_SHADER";
  }
  
  // Sets the frame's Title.
  frameTitle = "FPS : " + (int)frameRate + ", Material : " + materialNames[materialIndex] + ", Shader : " + shaderName;
  frame.setTitle(frameTitle);
  
  text(frameTitle, 15, 15);
}










/**
*  All material presets are from : 
*      http://devernay.free.fr/cours/opengl/materials.html
*      http://www.it.hiof.no/~borres/gb/magicianprogs/Material.html ( with a simpler array-based method for presets).
*      http://www.kynd.info/log/?p=201
*/



/************************************************************************************
*
*  Material Class.
*
************************************************************************************/
public class Material
{
  
  public Vec4  ambient  ;
  public Vec4  diffuse  ;
  public Vec4  specular ;
  public Vec4  emissive ;
  public float shininess;
  
  public Material()
  {
    ambient  = new Vec4();
    diffuse  = new Vec4();
    specular = new Vec4();
    emissive = new Vec4();
    
    shininess = 0.0f; 
  }  
}


String[] materialNames = {"default", "emerald", "jade", "obsidian", "pearl", "ruby", "turquoise", "brass", "bronze", "chrome", "copper", "gold", "silver",
                          "black_plastic", "cyan_plastic", "green_plastic", "red_plastic", "white_plastic", "yellow_plastic",
                          "black_rubber", "cyan_rubber",  "green_rubber", "red_rubber", "white_rubber", "yellow_rubber",   
                          "reflex_red", "cool_white", "warm_white", "less_bright_white", "bright_white",};

int materialIndex = 0;



/************************************************************************************
*
*  MaterialPreset Class (just extend Material to have a name). 
*
************************************************************************************/
public class MaterialPreset extends Material
{
  public String name;

  public MaterialPreset(String name)
  {
    super();
    
    this.name = name;
  }    
}




/************************************************************************************
*
*  Materials Class   :  Named MaterialPresets Provider. 
*
************************************************************************************/
public class Materials
{
  public HashMap<String, MaterialPreset> materialPresets;
  
  public Materials()
  {
    materialPresets = new HashMap<String, MaterialPreset>();   
   
   createMaterials(); 
  }
  
  public Material getMaterial(String materialName)
  {
    return materialPresets.get(materialName);
  }
  
  private void createMaterials()
  {
      // default
      MaterialPreset mat = new MaterialPreset("default");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 0.8f,       0.8f,       0.8f,      1.0f  );
      mat.specular.set ( 0.0f,       0.0f,       0.0f,      1.0f  );
      mat.emissive.set ( 0.0f,       0.0f,       0.0f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);

    
    
      // EMERALD
      mat = new MaterialPreset("emerald");
      
      mat.ambient.set  ( 0.0215f,    0.1745f,    0.0215f,   1.0f  );
      mat.diffuse.set  ( 0.07568f,   0.61424f,   0.07568f,  1.0f  );
      mat.specular.set ( 0.633f,     0.727811f,  0.633f,    1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);
  
      
      // JADE
      mat = new MaterialPreset("jade");
      
      mat.ambient.set  ( 0.135f,     0.2225f,    0.1575f,    1.0f  );
      mat.diffuse.set  ( 0.54f,      0.89f,      0.63f,      1.0f  );  
      mat.specular.set ( 0.316228f,  0.316228f,  0.316228f,  1.0f );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,       1.0f  );
      mat.shininess = 0.1f;
        
      materialPresets.put(mat.name, mat);
      
      
      // OBSIDIAN
      mat = new MaterialPreset("obsidian");
      
      mat.ambient.set  ( 0.05375f,   0.05f,      0.06625f,  1.0f  );
      mat.diffuse.set  ( 0.18275f,   0.17f,      0.22525f,  1.0f  );
      mat.specular.set ( 0.332741f,  0.328634f,  0.346435f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.3f;
        
      materialPresets.put(mat.name, mat);      
      
      
      // PEARL
      mat = new MaterialPreset("pearl");
      
      mat.ambient.set  ( 0.25f,      0.20725f,   0.20725f,  1.0f  );
      mat.diffuse.set  ( 1f,         0.829f,     0.829f,   1.0f  );
      mat.specular.set ( 0.296648f,  0.296648f,  0.296648f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.088f;
        
      materialPresets.put(mat.name, mat); 

      // Ruby
      mat = new MaterialPreset("ruby");
      
      mat.ambient.set  ( 0.1745f,    0.01175f,   0.01175f,  1.0f  );
      mat.diffuse.set  ( 0.61424f,   0.04136f,   0.04136f,   1.0f  );
      mat.specular.set ( 0.727811f,  0.626959f,  0.626959f,  1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);

      // Turquoise
      mat = new MaterialPreset("turquoise");
      
      mat.ambient.set  ( 0.1f ,      0.18725f,   0.1745f,   1.0f  );
      mat.diffuse.set  ( 0.396f,     0.74151f,   0.69102f,  1.0f  );
      mat.specular.set ( 0.297254f,  0.30829f,   0.306678f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.1f;
        
      materialPresets.put(mat.name, mat);

      // Brass
      mat = new MaterialPreset("brass");
      
      mat.ambient.set  ( 0.329412f,  0.223529f,  0.027451f, 1.0f  );
      mat.diffuse.set  ( 0.780392f,  0.568627f,  0.113725f, 1.0f  );
      mat.specular.set ( 0.992157f,  0.941176f,  0.807843f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.21794872f;
        
      materialPresets.put(mat.name, mat);

      // Bronze
      mat = new MaterialPreset("bronze");
      
      mat.ambient.set  ( 0.2125f,    0.1275f,    0.054f,    1.0f  );
      mat.diffuse.set  ( 0.714f,     0.4284f,    0.18144f,   1.0f  );
      mat.specular.set ( 0.393548f,  0.271906f,  0.166721f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.2f;
        
      materialPresets.put(mat.name, mat);


      // Chrome
      mat = new MaterialPreset("chrome");
      
      mat.ambient.set  ( 0.25f,      0.25f,      0.25f,     1.0f  );
      mat.diffuse.set  ( 0.4f,       0.4f,       0.4f,      1.0f  );
      mat.specular.set ( 0.774597f,  0.774597f,  0.774597f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);

     // Copper
      mat = new MaterialPreset("copper");
      
      mat.ambient.set  ( 0.19125f,   0.0735f,    0.0225f,   1.0f  );
      mat.diffuse.set  ( 0.7038f,    0.27048f,   0.0828f,   1.0f  );
      mat.specular.set ( 0.256777f,  0.137622f,  0.086014f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.1f;
        
      materialPresets.put(mat.name, mat);

    // Gold
      mat = new MaterialPreset("gold");
      
      mat.ambient.set  ( 0.24725f,   0.1995f,    0.0745f,   1.0f  );
      mat.diffuse.set  ( 0.75164f,   0.60648f,   0.22648f,  1.0f  );
      mat.specular.set ( 0.628281f,  0.555802f,  0.366065f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.4f;
        
      materialPresets.put(mat.name, mat);


    // Silver
      mat = new MaterialPreset("silver");
      
      mat.ambient.set  ( 0.19225f,   0.19225f,  0.19225f,   1.0f  );
      mat.diffuse.set  ( 0.50754f,   0.50754f,  0.50754f,   1.0f  );
      mat.specular.set ( 0.508273f,  0.508273f, 0.508273f,  1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.4f;
        
      materialPresets.put(mat.name, mat);


      // Black plastic
      mat = new MaterialPreset("black_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f,      1.0f  );
      mat.diffuse.set  ( 0.01f,      0.01f,      0.01f,     1.0f  );
      mat.specular.set ( 0.50f,      0.50f,      0.50f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // Cyan plastic
      mat = new MaterialPreset("cyan_plastic");
      
      mat.ambient.set  ( 0.0f,       0.1f,       0.06f,     1.0f  );
      mat.diffuse.set  ( 0.0f,       0.5098039f, 0.5098039f,1.0f  );
      mat.specular.set ( 0.5019608f, 0.5019608f, 0.5019608f,1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // green plastic
      mat = new MaterialPreset("green_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.1f,       0.35f,      0.1f,      1.0f  );
      mat.specular.set ( 0.45f,      0.55f,      0.45f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // Red plastic
      mat = new MaterialPreset("red_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.5f,       0.0f,       0.0f,      1.0f  );
      mat.specular.set ( 0.7f,       0.6f,       0.6f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // White plastic
      mat = new MaterialPreset("white_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.55f,      0.55f,      0.55f,     1.0f  );
      mat.specular.set ( 0.70f,      0.70f,      0.70f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // Yellow plastic
      mat = new MaterialPreset("yellow_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.5f,       0.5f,       0.0f,      1.0f  );
      mat.specular.set ( 0.60f,      0.60f,      0.50f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);

      // Black rubber
      mat = new MaterialPreset("black_rubber");
      
      mat.ambient.set  ( 0.02f,      0.02f,      0.02f,     1.0f  );
      mat.diffuse.set  ( 0.01f,      0.01f,      0.01f,     1.0f  );
      mat.specular.set ( 0.4f,       0.4f,       0.4f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Cyan rubber
      mat = new MaterialPreset("cyan_rubber");
      
      mat.ambient.set  ( 0.0f,       0.05f,      0.05f,     1.0f  );
      mat.diffuse.set  ( 0.4f ,      0.5f ,      0.5f,      1.0f  );
      mat.specular.set ( 0.04f,      0.7f,       0.7f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Green rubber
      mat = new MaterialPreset("green_rubber");
      
      mat.ambient.set  ( 0.0f,       0.05f,      0.0f,      1.0f  );
      mat.diffuse.set  ( 0.4f ,      0.5f ,      0.4f,      1.0f  );
      mat.specular.set ( 0.04f,      0.7f,       0.04f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Red rubber
      mat = new MaterialPreset("red_rubber");
      
      mat.ambient.set  ( 0.05f,      0.0f,       0.0f,      1.0f  );
      mat.diffuse.set  ( 0.5f ,      0.4f ,      0.4f,      1.0f  );
      mat.specular.set ( 0.7f,       0.04f,      0.04f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);

      // White rubber
      mat = new MaterialPreset("white_rubber");
      
      mat.ambient.set  ( 0.05f,      0.05f,      0.05f,     1.0f  );
      mat.diffuse.set  ( 0.5f ,      0.5f ,      0.5f,      1.0f  );
      mat.specular.set ( 0.7f,       0.7f,       0.7f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Yellow rubber
      mat = new MaterialPreset("yellow_rubber");
      
      mat.ambient.set  ( 0.05f,      0.05f,      0.0f,      1.0f  );
      mat.diffuse.set  ( 0.5f ,      0.5f ,      0.4f,      1.0f  );
      mat.specular.set ( 0.7f,       0.7f,       0.004f,    1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


     // Reflex Red
      mat = new MaterialPreset("reflex_red");
      
      mat.ambient.set  ( 1.0f,       0.0f,       0.0f,      1.0f  );
      mat.diffuse.set  ( 1.0f,       0.04136f,   0.04136f,  1.0f  );
      mat.specular.set ( 1.0f,       0.626959f,  0.626959f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.03f;
        
      materialPresets.put(mat.name, mat);


     // Cool white
      mat = new MaterialPreset("cool_white");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.3f,      1.0f  );
      mat.diffuse.set  ( 0.8f,       0.9f,       1.0f,      1.0f  );
      mat.specular.set ( 0.2f,       0.2f,       0.4f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);


     // Warm white
      mat = new MaterialPreset("warm_white");
      
      mat.ambient.set  ( 0.3f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 1.0f,       0.9f,       0.8f,      1.0f  );
      mat.specular.set ( 0.4f,       0.2f,       0.2f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);


     // Less Bright White
      mat = new MaterialPreset("less_bright_white");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 0.8f,       0.8f,       0.8f,      1.0f  );
      mat.specular.set ( 0.5f,       0.5f,       0.5f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);


     // Bright White
      mat = new MaterialPreset("bright_white");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 1.0f,       1.0f,       1.0f,      1.0f  );
      mat.specular.set ( 0.5f,       0.5f,       0.5f,      1.0f  );
      mat.emissive.set ( 0.15f,      0.15f,      0.15f,     1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);
  }
  
  
  
};

































/****************************************************************************
* Class   :  PShaderCustom
*
*            just changed two protected methods to public in order to 
*            get shader's attribute variable's location (id).
****************************************************************************/
public class PShaderCustom extends PShader
{
  
  public PShaderCustom(PApplet parent, String[] vertSource, String[] fragSource) 
  {
    super(parent, vertSource, fragSource);
  }
  
  
  /**
   * Returns the ID location of the attribute parameter given its name.
   *
   * @param name String
   * @return int
   */
  public int getAttributeLocation(String name) 
  {
    return super.getAttributeLoc(name);
  }


  /**
   * Returns the ID location of the uniform parameter given its name.
   *
   * @param name String
   * @return int
   */
  public int getUniformLocation(String name) 
  {
    return super.getUniformLoc(name);
    
  }  
}

/**************************************************************************************
*
*  Blinn-Phong Shader
*
*
**************************************************************************************/


String[] blinnShaderVertexCode = {

"#define MAX_LIGHTS 8",  

"varying vec3 normal, eyeVec;",
"varying vec3 lightDir[MAX_LIGHTS];",

"uniform int numLights;",

"void main()",
"{"  ,
  "gl_Position = ftransform();",    
  "normal = gl_NormalMatrix * gl_Normal;",
  "vec4 vVertex = gl_ModelViewMatrix * gl_Vertex;",
  "eyeVec = -vVertex.xyz;",
  "int i;",
  "for (i=0; i<numLights; ++i)",
  "{",
    "lightDir[i] = vec3(gl_LightSource[i].position.xyz - vVertex.xyz);",
  "}",
"}"};


String[] blinnShaderFragmentCode = { 


"#define MAX_LIGHTS 8",
"varying vec3 normal;",
"varying vec3 eyeVec;",
"varying vec3 lightDir[MAX_LIGHTS];",

"uniform int numLights;",

"void main (void)",
"{",
"  vec4 final_color = gl_FrontLightModelProduct.sceneColor;",
"  vec3 N = normalize(normal);",
"  int i;",
"  for (i=0; i<numLights; ++i)",
"  {  ",
"    vec3 L = normalize(lightDir[i]);",
"    float lambertTerm = dot(N,L);",
"    if (lambertTerm > 0.0)",
"    {",
"      final_color += gl_LightSource[i].diffuse * gl_FrontMaterial.diffuse * lambertTerm;  ",
      
"      vec3 E = normalize(eyeVec);",
"      vec3 R = reflect(-L, N);",
"      float specular = pow(max(dot(R, E), 0.0), gl_FrontMaterial.shininess);",
"      final_color += gl_LightSource[i].specular * gl_FrontMaterial.specular * specular;  ",
"    }",
"  }",
"",
"  gl_FragColor = final_color;",      
"}"};


/**************************************************************************************
*
*  Toon Shader
*
*
**************************************************************************************/



String[] toonShaderVertexCode =  {  
                                    "varying vec3 eyeSpaceNormal;",
                                    
                                    "void main()",
                                    "{",
                                    "  eyeSpaceNormal = gl_NormalMatrix * gl_Normal;",
                                    "  gl_Position    = ftransform();", 
                                    "}"
                                  };
                                  

String[] toonShaderFragmentCode = {
                                  
                                    "varying vec3 eyeSpaceNormal;",
                                    
                                    "vec4 toonify(in float intensity)",
                                    "{",
                                    "  if (intensity > 0.95)",
                                    "    return vec4(0.5, 1.0, 0.5, 1.0);",
                                    "" ,
                                    " else if (intensity > 0.5)",
                                    "    return vec4(0.3, 0.6, 0.3, 1.0);",
                                    "",
                                    " else if (intensity > 0.25)",
                                    "    return vec4(0.2, 0.4, 0.2, 1.0);",
                                    "",
                                    "  else", 
                                    "    return vec4(0.1, 0.2, 0.1, 1.0);",
                                    "}",
                                    
                                    "void main()",
                                    "{",
                                    "  vec3 normal = normalize(eyeSpaceNormal);",
                                    
                                    "  float intensity = dot(normalize(gl_LightSource[0].position.xyz), normal);",
                                    
                                       // or, to mix the color material with the final color..
                                       //"  gl_FragColor   = toonify(intensity) + gl_FrontMaterial.diffuse ;", 
                                       
                                      "  gl_FragColor   = toonify(intensity) + gl_FrontMaterial.diffuse / 2;",    
                                    "}",
                                    };
                                    


                                    
                                    
/**************************************************************************************
*
*  BumpMap Shader
*
*
**************************************************************************************/

                                    
                                    
String[] bumpMapShaderVertexCode = 
                      {
                        "attribute vec3 tangent;" , 
                        "attribute vec3 binormal;" ,                         
                        "uniform float invRad;" ,
                        
                        "varying  vec3 g_lightVec;" ,
                        "varying  vec3 g_viewVec;" ,                          

                        "void main()" ,
                        "{" ,
                        "gl_Position      = ftransform();" ,
                        "gl_TexCoord[0]   = gl_MultiTexCoord0;" ,
                        "mat3 TBN_Matrix  = gl_NormalMatrix * mat3(tangent, binormal, gl_Normal);" ,
                        "vec4 mv_Vertex   = gl_ModelViewMatrix * gl_Vertex;" ,
                        "g_viewVec        = vec3(-mv_Vertex) * TBN_Matrix ;  " ,
                        
                        "vec4 lightEye    = gl_ModelViewMatrix *  gl_LightSource[0].position;" ,
                        "vec3 lightVec    = 0.02* (lightEye.xyz - mv_Vertex.xyz);  " ,
                        "g_lightVec       = lightVec * TBN_Matrix; " ,
                        "}"
                        };


// Shiny.frag
String[] bumpMapShaderFragmentCode = 
                          {
                            "uniform sampler2D NormalHeight; "  ,
                            "uniform sampler2D Base;" , 
                            
                            "varying vec3 g_lightVec;" ,
                            "varying vec3 g_viewVec;" ,
                            
                            "uniform vec2     BumpSize;//   = 0.02 * vec2 (2.0, -1.0);",
                            
                            "void main()" , 
                            "{" , 
                            "float LightAttenuation  = clamp(1.0 - dot(g_lightVec, g_lightVec), 0.0, 1.0);" , 
                            "vec3 lightVec           = normalize(g_lightVec);" , 
                            "vec3 viewVec            = normalize(g_viewVec);" , 
                            "float height            = texture2D(NormalHeight, gl_TexCoord[0].xy).a;" , 
                            "height                  = height * BumpSize.x + BumpSize.y;" , 
                            
                            "vec2 newUV       = gl_TexCoord[0].xy + viewVec.xy * height;" , 
                            "vec4 color_base  = texture2D(Base,newUV);" , 
                            "vec3 bump        = texture2D(NormalHeight, newUV.xy).rgb * 2.0 - 1.0;" , 
                            "bump             = normalize(bump);" ,                             
                            "float base       = 0.02 + (0.7 * texture2D(NormalHeight, newUV.xy).a);" ,
                            "float diffuse    = clamp(dot(lightVec, bump), 0.0, 1.0);" , 
                            "float specular   = pow(clamp(dot(reflect(-viewVec, bump), lightVec), 0.0, 1.0), 16.0);" ,
                            
                            // initial line that does not take material into account.
                           //"gl_FragColor     = vec4(color_base.rgb * gl_LightSource[0].diffuse.rgb * (diffuse * base + 0.7 * specular * color_base.a) * 1.0,1.0);", 
                            
                            // Line that takes coloring into account.
                            "gl_FragColor     = vec4(color_base.rgb * gl_LightSource[0].diffuse.rgb * (diffuse * base + 0.7 * specular * color_base.a) * 1.0,1.0) * gl_FrontMaterial.diffuse;" , 
                            "}" 
                          };          




/**************************************************************************************
*
*  Per-Pixel Lighting Shader
*
*
**************************************************************************************/


String[] perPixelShaderVertexCode = 
                {

                "#define PROCESSING_LIGHT_SHADER",
                
                "uniform mat4 modelview;",
                "uniform mat4 transform;",
                "uniform mat3 normalMatrix;",
                
                "uniform vec4 lightPosition;",
                "uniform vec3 lightNormal;",
                
                "attribute vec4 vertex;",
                "attribute vec4 color;",
                "attribute vec3 normal;",
                
                "varying vec4 vertColor;",
                "varying vec3 ecNormal;",
                "varying vec3 lightDir;",
                
                "void main() {",
                "  gl_Position = transform * vertex;",    
                "  vec3 ecVertex = vec3(modelview * vertex);",  
                  
                "  ecNormal = normalize(normalMatrix * normal);",
                "  lightDir = normalize(lightPosition.xyz - ecVertex);",  
                "  vertColor = color;",
                "}",
              };

String[] perPixelShaderFragmentCode = 
{

                "#ifdef GL_ES",
                "precision mediump float;",
                "precision mediump int;",
                "#endif",
                
                "varying vec4 vertColor;",
                "varying vec3 ecNormal;",
                "varying vec3 lightDir;",
                
                "void main() {  ",
                "  vec3 direction = normalize(lightDir);",
                "  vec3 normal = normalize(ecNormal);",
                "  float intensity = max(0.0, dot(direction, normal));",
                "  gl_FragColor = vec4(intensity, intensity, intensity, 1) * vertColor;",
                "}",  

  
};



/**************************************************************************************
*
*    Gooch NPR Shader
*
*   Copyright (C) 2007 Dave Griffiths
*   Fluxus Shader Library
*   ---------------------
*   Gooch NPR Shading Model
*   Orginally for technical drawing style 
*   rendering, uses warm and cool colours
*   to depict shading to keep detail in the
*   shadowed areas
*
*  See : https://code.google.com/p/qshaderedit/source/browse/trunk/shaders/gooch.glsl?r=208
*
**************************************************************************************/

String[] goochShaderVertexCode = 
              {
                "uniform vec3  LightPosition;  // (0.0, 10.0, 4.0)", 
                
                "varying float NdotL;",
                "varying vec3  ReflectVec;",
                "varying vec3  ViewVec;",
                
                "void main()",
                "{",
                "    vec3 ecPos      = vec3(gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - ecPos);",
                "    ReflectVec      = normalize(reflect(-lightVec, tnorm));",
                "    ViewVec         = normalize(-ecPos);",
                "    NdotL           = (dot(lightVec, tnorm) + 1.0) * 0.5;",
                "    gl_Position     = ftransform();",
                "}",
              }; 
                
String[] goochShaderFragmentCode = 
              {
                "uniform vec3  SurfaceColor; // (0.75, 0.75, 0.75)",
                "uniform vec3  WarmColor;    // (0.6, 0.6, 0.0)",
                "uniform vec3  CoolColor;    // (0.0, 0.0, 0.6)",
                "uniform float DiffuseWarm;  // 0.45",
                "uniform float DiffuseCool;  // 0.45",
                
                "varying float NdotL;",
                "varying vec3  ReflectVec;",
                "varying vec3  ViewVec;",
                
                "void main()",
                "{",
                "    vec3 kcool    = min(CoolColor + DiffuseCool * SurfaceColor, 1.0);",
                "    vec3 kwarm    = min(WarmColor + DiffuseWarm * SurfaceColor, 1.0);", 
                "    vec3 kfinal   = mix(kcool, kwarm, NdotL);",
                
                "    vec3 nreflect = normalize(ReflectVec);",
                "    vec3 nview    = normalize(ViewVec);",
                
                "    float spec    = max(dot(nreflect, nview), 0.0);",
                "    spec          = pow(spec, 32.0);",
                
                "    gl_FragColor = vec4(min(kfinal + spec, 1.0), 1.0);",
                "}",
              };



/**************************************************************************************
*
*    Adaptive AA Shader
*
*   Copyright (C) 2007 Dave Griffiths
*   Fluxus Shader Library
*   ---------------------
*  
*  Shader for adaptively antialiasing a procedural stripe pattern
*
*  See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/adaptiveaa.glsl
*
**************************************************************************************/

String[] adaptiveAaShaderVertexCode = 
{

                "uniform vec3  LightPosition;",
                
                "varying float V;",
                "varying float LightIntensity;",
                 
                "void main()",
                "{",
                "    vec3 pos        = vec3(gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - pos);",
                
                "    LightIntensity = max(dot(lightVec, tnorm), 0.0);",
                
                "    V = gl_MultiTexCoord0.s;  // try .s for vertical stripes",
                
                "    gl_Position = ftransform();",
                "}",  
};



String[] adaptiveAaShaderFragmentCode = 
{
                "varying float V;                    // generic varying",
                "varying float LightIntensity;",
                
                "uniform float Frequency;            // Stripe frequency = 16",
                
                "void main()",
                "{",
                "    float sawtooth = fract(V * Frequency);",
                "    float triangle = abs(2.0 * sawtooth - 1.0);",
                "    float dp = length(vec2(dFdx(V), dFdy(V)));",
                "    float edge = dp * Frequency * 2.0;",
                "    float square = smoothstep(0.5 - edge, 0.5 + edge, triangle);",
                "    gl_FragColor = vec4(vec3(square), 1.0) * LightIntensity;",
                "}",
};





/**************************************************************************************
*
*    Lattice Shader
*
*   Copyright (C) 2007 Dave Griffiths
*   Fluxus Shader Library
*   ---------------------
*  See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/lattice.glsl
* 
*  Parameters :
*  ------------
*    vec3 Ambient = vec3(0.1, 0.1, 0.1);
*    vec3 EyePosition = vec3(0, 0, 0);
*    float Kd = 1;
*    vec3 LightColor = vec3(1, 1, 1);
*    vec3 LightPosition = vec3(0, 10, 4);
*    vec2 Scale = vec2(5, 5);
*    vec3 Specular = vec3(0, 1, 0);
*    vec3 SurfaceColor = vec3(1, 1, 0);
*    vec2 Threshold = vec2(0.2, 0.2);
**************************************************************************************/

String[] latticeShaderVertexCode = 
{
                "uniform vec3  LightPosition;",
                "uniform vec3  LightColor;",
                "uniform vec3  EyePosition;",
                "uniform vec3  Specular;",
                "uniform vec3  Ambient;",
                "uniform float Kd;",
                
                "varying vec3  DiffuseColor;",
                "varying vec3  SpecularColor;",
                
                "void main()",
                "{",
                "    vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - ecPosition);",
                "    vec3 viewVec    = normalize(EyePosition - ecPosition);",
                "    vec3 Hvec       = normalize(viewVec + lightVec);",
                
                "    float spec = abs(dot(Hvec, tnorm));",
                "    spec = pow(spec, 16.0);",
                
                "    DiffuseColor    = LightColor * vec3 (Kd * abs(dot(lightVec, tnorm)));",
                "    DiffuseColor    = clamp(Ambient + DiffuseColor, 0.0, 1.0);",
                "    SpecularColor   = clamp((LightColor * Specular * spec), 0.0, 1.0);",
                
                "    gl_TexCoord[0]  = gl_MultiTexCoord0;",
                "    gl_Position     = ftransform();",
                "}",
};


String[] latticeShaderFragmentCode = 
{
                "varying vec3  DiffuseColor;",
                "varying vec3  SpecularColor;",
                
                "uniform vec2  Scale;",
                "uniform vec2  Threshold;",
                "uniform vec3  SurfaceColor;",
                
                "void main()",
                "{",
                "    float ss = fract(gl_TexCoord[0].s * Scale.s);",
                "    float tt = fract(gl_TexCoord[0].t * Scale.t);",
                
                "    if ((ss > Threshold.s) && (tt > Threshold.t)) discard;",
                
                "    vec3 finalColor = SurfaceColor * DiffuseColor + SpecularColor;",
                "    gl_FragColor = vec4(finalColor, 1.0);",
                "}",
  
};



/**************************************************************************************
*
*    Ward Isotropic Shader
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/sancho/wardisotropic.glsl
***************************************************************************************/

String[] wardIsotropicShaderVertexCode = 
{
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "void main() {",
                "  gl_Position = ftransform();",
                "  v_V = (gl_ModelViewMatrix * gl_Vertex).xyz;",
                "  v_N = gl_NormalMatrix * gl_Normal;",
                "}",  
};


String[] wardIsotropicShaderFragmentCode = 
{
                "#version 110",
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "const float roughness = 0.05;",
                
                "void main()", 
                "{",
                "  vec3 N = normalize(v_N);",
                "  vec3 V = normalize(v_V);",
                "  vec3 R = reflect(V, N);",
                "  vec3 L = normalize(vec3(gl_LightSource[0].position));",
                "  vec3 Nf = faceforward(N, V, N);",
                "  vec3 Vf = -V;",
                "  vec3 H = normalize(L+Vf);",
                "  float ndoth = dot(Nf, H);",
                "  float ndotl = dot(Nf, L);",
                "  float ndotv = dot(Nf, Vf);",
                "  float delta = acos(ndoth);",
                "  float tandelta = tan(delta);",
                "  float secta = exp( -( pow( tandelta, 2.0) / pow( roughness, 2.0)));",
                "  float sectb = 1.0 / sqrt( ndotl * ndotv );",
                "  float sectc = 1.0 / ( 4.0 * pow( roughness, 2.0) );",
                
                "  vec4 ambient = gl_FrontMaterial.ambient;",
                "  vec4 diffuse = gl_FrontMaterial.diffuse * max(dot(L, N), 0.0);",
                "  vec4 specular = gl_FrontMaterial.specular * (sectc * secta * sectb);",
                
                "  gl_FragColor = ambient + diffuse + specular;",
                "}",  
  
};


/**************************************************************************************
*
*    Minnaert Ward Shader
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/sancho/minnaertward.glsl
*
*    Parameters :
*    ------------
*    float ior = 1.9;
*    float k = 1.5;
*    float roughness = 0.15;
*
***************************************************************************************/

String[] minnaertWardShaderVertexCode = 
{
                "#version 110",
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "void main()", 
                "{",
                "  gl_Position = ftransform();",
                "  v_V = (gl_ModelViewMatrix * gl_Vertex).xyz;",
                "  v_N = gl_NormalMatrix * gl_Normal;",
                "}",  
};



String[] minnaertWardShaderFragmentCode = 
{


                "#version 110",
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "uniform float k; // minnaert roughness  1.5",
                "uniform float roughness; // Ward isotropic specular roughness 0.2",
                "uniform float ior; // Schlick's fresnel approximation index of refraction 1.5",
                
                "// Minnaert limb darkening diffuse term",
                "vec3 minnaert( vec3 L, vec3 Nf, float k)", 
                "{",
                "  float ndotl = max( 0.0, dot(L, Nf));",
                "  return gl_LightSource[0].diffuse.rgb * pow( ndotl, k);",
                "}",
                
                "// Ward isotropic specular term",
                "vec3 wardiso( vec3 Nf, vec3 Ln, vec3 Hn, float roughness, float ndotv )", 
                "{",
                "  float ndoth = dot( Nf, Hn);",
                "  float ndotl = dot( Nf, Ln);",
                "  float tandelta = tan( acos(ndoth));",
                "  return gl_LightSource[0].specular.rgb",
                "    * exp( -( pow( tandelta, 2.0) / pow( roughness, 2.0)))",
                "    * (1.0 / sqrt( ndotl * ndotv ))",
                "    * (1.0 / (4.0 * pow( roughness, 2.0)));",
                "}",
                  
                "float schlick( vec3 Nf, vec3 Vf, float ior, float ndotv )", 
                "{",
                "  float kr = (ior-1.0)/(ior+1.0);",
                "  kr *= kr;",
                "  return kr + (1.0-kr)*pow( 1.0 - ndotv, 5.0);",
                "}",
                  
                "void main()", 
                "{",
                "  vec3 N = normalize(v_N);",
                "  vec3 V = normalize(v_V);",
                "  vec3 L = normalize(vec3(gl_LightSource[0].position));",
                "  vec3 Vf = -V;",
                "  float ndotv = dot(N, Vf);",
                "  vec3 H = normalize(L+Vf);",
                
                "  vec3 ambient = gl_FrontMaterial.ambient.rgb;",
                "  vec3 diffuse = gl_FrontMaterial.diffuse.rgb * minnaert( L, N, k);",
                "  float fresnel = schlick( N, V, ior, ndotv);",
                "  vec3 specular = gl_FrontMaterial.specular.rgb * wardiso( N, L, H, roughness, ndotv) * fresnel;",
                
                "  gl_FragColor = vec4( ambient + diffuse + specular, 1.0);",
                "}",

};



/**************************************************************************************
*
*    Wiggle Shader
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/wiggle.glsl
*
*    Parameters  :
*    -------------
*        vec2 freq = vec2(2, 2.5);
*        vec2 scale = vec2(0.5, 0.2);
*
**************************************************************************************/

String[] wiggleShaderVertexCode = 
{
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "uniform float time;",
                "uniform vec2 freq;",
                "uniform vec2 scale;",
                
                "void main ()", 
                "{",
                "  float wiggleX = sin(gl_Vertex.x * freq.x + time) * scale.x;",
                "  float wiggleY = cos(gl_Vertex.y * freq.y + time) * scale.y;",
                
                "  gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.x + wiggleY, gl_Vertex.y + wiggleX, gl_Vertex.z, gl_Vertex.w);",
                "  v_V = (gl_ModelViewMatrix * gl_Vertex).xyz;",
                "  v_N = gl_NormalMatrix * gl_Normal;",
                "}",  
};


String[] wiggleShaderFragmentCode = 
{
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "void main ()", 
                "{",
                "  vec3 N = normalize(v_N);",
                "  vec3 V = normalize(v_V);",
                "  vec3 R = reflect(V, N);",
                "  vec3 L = normalize(vec3(gl_LightSource[0].position));",
                
                "  vec3 ambient = vec3(0.1, 0.0, 0.0);",
                "  vec3 diffuse = vec3(1.0, 0.0, 0.0) * max(dot(L, N), 0.0);",
                "  vec3 specular = vec3(1.0, 1.0, 1.0) * pow(max(dot(R, L), 0.0), 8.0);",
                
                "  gl_FragColor = vec4(ambient + diffuse + specular, 1.0);",
                "}",  
};



/**************************************************************************************
*
*    Brick Shader, shader for procedural bricks
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/brick.glsl
*
*    Parameters  :
*    -------------
*        vec3 BrickColor = vec3(1, 0.3, 0.2);
*        vec2 BrickPct = vec2(0.9, 0.85);
*        vec2 BrickSize = vec2(0.3, 0.15);
*        vec3 LightPosition = vec3(0, 0, 4);
*        vec3 MortarColor = vec3(0.85, 0.86, 0.84);
*
**************************************************************************************/

String[] brickShaderVertexCode = 
{
  
                "uniform vec3 LightPosition;",
                
                "const float SpecularContribution = 0.3;",
                "const float DiffuseContribution  = 1.0 - SpecularContribution;",
                
                "varying float LightIntensity;",
                "varying vec2  MCposition;",
                
                "void main(void)", //////////////////////
                "{",
                "    vec3 ecPosition = vec3 (gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - ecPosition);",
                "    vec3 reflectVec = reflect(-lightVec, tnorm);",
                "    vec3 viewVec    = normalize(-ecPosition);",
                "    float diffuse   = max(dot(lightVec, tnorm), 0.0);",
                "    float spec      = 0.0;",
                
                "    if (diffuse > 0.0)",
                "    {",
                "        spec = max(dot(reflectVec, viewVec), 0.0);",
                "        spec = pow(spec, 16.0);",
                "    }",
                
                "    LightIntensity  = DiffuseContribution * diffuse + SpecularContribution * spec;",
                
                "    MCposition      = gl_Vertex.xz;",
                "    gl_Position     = ftransform();",
                "}",  
  
};


String[] brickShaderFragmentCode = 
{
                "uniform vec3  BrickColor;",
                "uniform vec3  MortarColor;",
                "uniform vec2  BrickSize;",
                "uniform vec2  BrickPct;",
                
                "varying vec2  MCposition;",
                "varying float LightIntensity;",
                
                "void main(void)",
                "{",
                "    vec3  color;",
                "    vec2  position, useBrick;",
                    
                "    position = MCposition / BrickSize;",
                
                "    if (fract(position.y * 0.5) > 0.5)",
                "    {",
                "        position.x += 0.5;",
                "    }",
                "    position = fract(position);",
                
                "    useBrick = step(position, BrickPct);",
                
                "    color  = mix(MortarColor, BrickColor, useBrick.x * useBrick.y);",
                "    color *= LightIntensity;",
                
                "    gl_FragColor = vec4 (color, 1.0);",
                
                "}",
};





















                          
public void drawGlCube()
{
  gl.glBegin(GL2.GL_QUADS);

  gl.glNormal3f(0,0,-1);

  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-1,1,-1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-1,-1,-1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(1,-1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(1,1,-1);


  gl.glNormal3f(1,0,0);  
  gl.glVertexAttrib3f(tangentLoc,0,0,1);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);

  gl.glTexCoord2f(1,1);
  gl.glVertex3f(1,-1,1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(1,1,1);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(1,1,-1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(1,-1,-1);

  gl.glNormal3f(0,0,1);
  gl.glVertexAttrib3f(tangentLoc,-1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);

  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-1,-1,1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-1,1,1);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(1,1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(1,-1,1);


  gl.glNormal3f(-1,0,0);
  gl.glVertexAttrib3f(tangentLoc,0,0,-1);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);

  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-1,1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-1,-1,1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-1,-1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-1,1,-1);


  gl.glNormal3f(0,1,0);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,0,-1);

  gl.glTexCoord2f(0,0);
  gl.glVertex3f(1,1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-1,1,1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-1,1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(1,1,-1);


  gl.glNormal3f(0,-1,0);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,0,-1);

  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-1,-1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(1,-1,1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(1,-1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-1,-1,-1);

  gl.glEnd();
}


public void drawLine3D(PVector pv1, PVector pv2, float weight, int _color)
{
 PVector v1 = new PVector(pv2.x - pv1.x, pv2.y - pv1.y, pv2.z - pv1.z);
 
 float rho = sqrt(pow(v1.x, 2) + pow(v1.y, 2) + pow(v1.z, 2));
 float phi = acos(v1.z / rho);
 float the = atan2(v1.y, v1.x);
 
 v1.mult(0.5f);      
 
 float zval = pv1.dist(pv2) * 0.5f;  
 float rad = radians(120) * weight * 0.5f;
   
 gl.glPushMatrix();
   gl.glTranslatef(pv1.x, pv1.y, pv1.z);
   gl.glTranslatef(v1.x, v1.y, v1.z);
   gl.glRotatef(degrees(the), 0, 0, 1);
   gl.glRotatef(degrees(phi), 0, 1, 0);
   gl.glColor4f(red(_color)/255, green(_color)/255, blue(_color)/255, 0.67f);
   
   //DRAW THE 3D 'LINE' (with 3 planes)  
   gl.glBegin(GL2.GL_QUADS);
     //1
     gl.glVertex3f( rad, -rad,  zval);
     gl.glVertex3f( rad, -rad, -zval);
     gl.glVertex3f(-rad, -rad, -zval);
     gl.glVertex3f(-rad, -rad,  zval);      
     //2
     gl.glVertex3f(-rad, -rad,  zval);
     gl.glVertex3f(-rad, -rad, -zval);
     gl.glVertex3f(   0,  rad, -zval);
     gl.glVertex3f(   0,  rad,  zval);
     //3
     gl.glVertex3f(   0,  rad,  zval);
     gl.glVertex3f(   0,  rad, -zval);
     gl.glVertex3f( rad, -rad, -zval);
     gl.glVertex3f( rad, -rad,  zval);
   gl.glEnd();
   
 gl.glPopMatrix();
   
}



public PShape createCan(/* float r, float h, int detail */) 
{
  
  float r = 80;
  float h = 80;
  int detail = 128; 
  
  
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  
  
  
  for (int i = 0; i <= detail; i++) 
  {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = PApplet.parseFloat(i) / detail;
  
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
};

  public void drawCanGL()
{
  float r = 200;    // radius
  float h = 300;    // height
  int detail = 128; 
  
  gl.glBegin(GL2.GL_QUAD_STRIP);
  
  for (int i = 0; i <= detail; i++) 
  {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = PApplet.parseFloat(i) / detail;
    
    //sh.normal(x, 0, z);
    gl.glNormal3f(x, 0, z);
       
    //sh.vertex(x * r, -h/2, z * r, u, 0);
    gl.glVertex3f(x * r,  -h/2,  z * r);
    gl.glTexCoord2f(u, 0);
     
    //sh.vertex(x * r, +h/2, z * r, u, 1);    
    gl.glVertex3f(x * r, + h/2, z * r);
    gl.glTexCoord2f(u, 1);
  }
  
  gl.glEnd();  
};













public void glutShape()
{
  // Enable Texture Coord Generation For S and T ( NEW )
  gl.glEnable(GL2.GL_TEXTURE_GEN_S);
  gl.glEnable(GL2.GL_TEXTURE_GEN_T);

  /*   Set The Texture Generation Mode For S and T To Quadric Sphere Mapping (NEW)
   *  Specifies a single-valued texture generation parameter,
   *  one of   GL_OBJECT_LINEAR,      
   *           GL_EYE_LINEAR,         
   *           GL_SPHERE_MAP,
   *           GL_NORMAL_MAP, 
   *       or GL_REFLECTION_MAP.
   
   gl.glTexGeni(GL2.GL_S, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_SPHERE_MAP);
   gl.glTexGeni(GL2.GL_T, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_SPHERE_MAP);
   */
 
  gl.glTexGeni(GL2.GL_S, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_OBJECT_LINEAR);
  gl.glTexGeni(GL2.GL_T, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_OBJECT_LINEAR);

 //gl.glTexGeni(GL2.GL_S, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_EYE_LINEAR);
  //gl.glTexGeni(GL2.GL_T, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_EYE_LINEAR);


  glut.glutSolidTeapot(1.0f, true);
//glut.glutSolidSphere(1,64,64);
//glut.glutSolidIcosahedron();
 

  // disable Texture Coord Generation For S and T
  gl.glDisable(GL2.GL_TEXTURE_GEN_S);
  gl.glDisable(GL2.GL_TEXTURE_GEN_T);

  //glut.glutSolidTorus(50, 100, 64, 64);

  //gl.glScalef(20,20,20);
  

}

public PShape createCan(float r, float h, int detail) 
{
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = PApplet.parseFloat(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
  }


/************************************************************************************
*
*  Vec3
*
************************************************************************************/
public class Vec3
{
  public float x;
  public float y;
  public float z;
  
  public Vec3()
  {
    x = 0;
    y = 0;
    z = 0;
  }
  
  public Vec3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public void set(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    
  }
  
  public float[] toArray()
  {
    return new float[] {x, y, z };
  }
  
}

/************************************************************************************
*
*  Vec4
*
************************************************************************************/
public class Vec4 extends Vec3
{
  public float w;
  
  public Vec4()
  {
    this(0,0,0,0);
  }
  
  public Vec4 (float x, float y, float z, float w)
  {
    super(x,y,z);
    
    w = 0;
  }
  
  public void set( float x, float y, float z, float w )
  {
    super.set(x, y, z);
    this.w = w;    
  }
  
  public float[] toArray()
  {
    return new float[] {x, y, z, w };
  }
  
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_ShadersGalore_Blinn_Toon_Bump_04" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
