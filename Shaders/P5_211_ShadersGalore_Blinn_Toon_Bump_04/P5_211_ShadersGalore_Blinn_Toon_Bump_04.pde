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

import com.jogamp.opengl.util.gl2.GLUT;
import java.nio.*;
import java.util.*;
import javax.media.opengl.GL2;
import javax.media.opengl.glu.GLU;
import remixlab.proscene.*;


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

void setup() 
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
void draw() 
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
  gl.glRotatef(angle * 1.02 ,1,0,0);  
  
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
    rotateY(angle * 0.02); 
    rotateX(angle * 0.002);  
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
    gl.glRotatef(angle * 1.02 ,1,0,0);  
    
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
    rotateY(angle * 0.02); 
    rotateX(angle * 0.002);  
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
  bumpMapShader.set("BumpSize",  0.02 * 2.0f, 0.02 * - 1.0f);        
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

