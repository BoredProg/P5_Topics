//http://forum.processing.org/one/topic/new-opengl-skyboxviewer-3-8-2010.html

import peasy.PeasyCam;  //peasy camera control
import processing.opengl.PGraphicsOpenGL;
import javax.media.opengl.GL;
import com.sun.opengl.util.texture.Texture;
import com.sun.opengl.util.texture.TextureIO;
// set skybox filename without orientation part here...
String skyboxName = "besiege"; 
PeasyCam cam;
PGraphicsOpenGL pgl;
GL gl;
int skybox;
void setup()
{
  size(1280,720, OPENGL);
  //  size(screenWidth, screenHeight, OPENGL);  // fullscreen
  // frameRate(3000);
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  hint(DISABLE_DEPTH_TEST);
  gl.glDepthMask(false);
  gl.glDisable(GL.GL_DEPTH_TEST);
  loadSkybox(skyboxName, ".jpg");  // png
  pgl.beginGL();
  skybox = gl.glGenLists(1);
  gl.glNewList(skybox, GL.GL_COMPILE);
  noStroke();  // comment it to see cube edges
  gl.glFrontFace(GL.GL_CCW);
  gl.glEnable(GL.GL_CULL_FACE);
  TexturedCube();
  gl.glDisable(GL.GL_CULL_FACE);
  gl.glEndList();
  pgl.endGL();
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*100.0);
  //cam = new PeasyCam(this,100);
  //cam.setResetOnDoubleClick(false);
  //cam.setMinimumDistance(10);
  //cam.setMaximumDistance(width*10);
  // gl.glEnable(GL.GL_CULL_FACE);
}
void draw()
{
  // background(255);
  pgl.beginGL();
  gl.glCallList( skybox );
  pgl.endGL();
  //translate(width/2.0, height/2.0, -100);
  println("FPS: "+ frameRate);
}
float p = 40000;   // half skybox size
float m = -p;
// create cube edges
PVector P000 = new PVector (m,m,m);
PVector P010 = new PVector (m,p,m);
PVector P110 = new PVector (p,p,m);
PVector P100 = new PVector (p,m,m);
PVector P001 = new PVector (m,m,p);
PVector P011 = new PVector (m,p,p);
PVector P111 = new PVector (p,p,p);
PVector P101 = new PVector (p,m,p);
Texture tex1,tex2,tex3,tex4,tex5,tex6;   // texture images
// load six skybox images as cube texture
void loadSkybox(String skyboxName, String fExt)
{
  try {
    tex1 = TextureIO.newTexture(new File(dataPath(skyboxName + "_front" + fExt)), true);
    tex2 = TextureIO.newTexture(new File(dataPath(skyboxName + "_back" + fExt)), true);
    tex3 = TextureIO.newTexture(new File(dataPath(skyboxName + "_left" + fExt)), true);
    tex4 = TextureIO.newTexture(new File(dataPath(skyboxName + "_right" + fExt)), true);
    tex5 = TextureIO.newTexture(new File(dataPath(skyboxName + "_bottom" + fExt)), true);
    tex6 = TextureIO.newTexture(new File(dataPath(skyboxName + "_top" + fExt)), true);
  }
  catch (IOException e) {   
    println( e);
  }
  textureMode(NORMALIZED);
}
// Assign six texture to the six cube faces
void TexturedCube()
{
  TexturedCubeSide (P100, P000, P010, P110, tex1);   // -Z "front" face
  TexturedCubeSide (P001, P101, P111, P011, tex2);   // +Z "back" face
  TexturedCubeSide (P000, P001, P011, P010, tex3);   // -X "left" face
  TexturedCubeSide (P101, P100, P110, P111, tex4);   // +X "right" face
  TexturedCubeSide (P110, P010, P011, P111, tex5);   // +Y "base" face
  TexturedCubeSide (P101, P001, P000, P100, tex6);   // -Y "top" face
}
// create a cube side given by 4 edge vertices and a texture
void TexturedCubeSide(PVector P1, PVector P2, PVector P3, PVector P4, Texture tex)
{
  tex.enable();
  tex.bind();
  gl.glBegin(GL.GL_QUADS);
  gl.glTexCoord2f(1.0f, 0.0f);
  gl.glVertex3f(P1.x, P1.y, P1.z);
  gl.glTexCoord2f(0.0f, 0.0f);
  gl.glVertex3f(P2.x, P2.y, P2.z);
  gl.glTexCoord2f(0.0f, 1.0f);
  gl.glVertex3f(P3.x, P3.y, P3.z);
  gl.glTexCoord2f(1.0f, 1.0f);
  gl.glVertex3f(P4.x, P4.y, P4.z);
  gl.glEnd();
  tex.disable();
}
