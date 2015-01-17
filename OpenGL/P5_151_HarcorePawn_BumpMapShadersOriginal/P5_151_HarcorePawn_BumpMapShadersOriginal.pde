//import hardcorepawn.opengl.*;
import processing.opengl.*;
import java.nio.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.*;

PImage tex0,tex1,nulltex;
float a,b;

GL gl;
GLU glu;
GLSL glsl;
int[] tex;
int[] shaderimgloc;

int tangentLoc;
int binormalLoc;
int uir;
int cbs;

void setup()
{
//  size(800,600,"hardcorepawn.opengl.HCPGL");
  size(800,600,OPENGL);
  gl=((PGraphicsOpenGL)g).gl;
  glu=((PGraphicsOpenGL)g).glu;
  gl.glEnable(GL.GL_CULL_FACE);
  gl.glCullFace(GL.GL_FRONT);

  tex0=loadImage("img.png");
  tex1=loadImage("bump.png");
  nulltex=loadImage("img2.png");
  perspective(PI/3.0,4.0/3.0,1,1000);
  camera(0,0,-800,0,0,1,0,1,0);
  tex=new int[2];
  
  gl.glGenTextures(2,tex,0);
  gl.glBindTexture(GL.GL_TEXTURE_2D,tex[0]);
  gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 4,tex0.width, tex0.height,
                          0, GL.GL_BGRA, GL.GL_UNSIGNED_BYTE,
                          IntBuffer.wrap(tex0.pixels));
  gl.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_MIN_FILTER,GL.GL_LINEAR);	// Linear Filtering
  gl.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_MAG_FILTER,GL.GL_LINEAR);	// Linear Filtering
  gl.glBindTexture(GL.GL_TEXTURE_2D,tex[1]);
  gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 4,tex1.width, tex1.height,
                          0, GL.GL_BGRA, GL.GL_UNSIGNED_BYTE,
                          IntBuffer.wrap(tex1.pixels));
  gl.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_MIN_FILTER,GL.GL_LINEAR);	// Linear Filtering
  gl.glTexParameteri(GL.GL_TEXTURE_2D,GL.GL_TEXTURE_MAG_FILTER,GL.GL_LINEAR);	// Linear Filtering
  glsl=new GLSL();
//  glsl.loadVertexShader("textureSimple.vert");
//  glsl.loadFragmentShader("textureSimple.frag");
  glsl.loadVertexShader("shiny.vert");
  glsl.loadFragmentShader("shiny.frag");
  glsl.useShaders();
  shaderimgloc=new int[2];
//  shaderimgloc[0]=glsl.getUniformLocation("Tex");
  shaderimgloc[0]=glsl.getUniformLocation("Base");
  shaderimgloc[1]=glsl.getUniformLocation("NormalHeight");
  tangentLoc=glsl.getAttribLocation("tangent");
  binormalLoc=glsl.getAttribLocation("binormal");
  uir=glsl.getUniformLocation("u_invRad");
  cbs=glsl.getUniformLocation("cBumpSize");
  a=0;
  b=0;
//  printCamera();
  textureMode(NORMALIZED);
  gl.glEnable(GL.GL_LIGHTING);
}

void draw()
{
  float mx=(mouseX-width/2.0)/(width/2.0);
  float my=(mouseY-height/2.0)/(height/2.0);
  a+=0.003;
  b+=0.00063;
//  pointLight(255,255,255,0,0,-400);
//  camera(0,0,-400,0,0,0,0,1,0);
//  glu.gluLookAt(0,0,400,0,0,0,0,1,0);
//  glu.
  background(50,0,0);
  glsl.startShader();
  fill(255,255,255);
//  specular(0,0,0);
  ambient(250,250,250);
//  shininess(2.0);
  gl.glActiveTexture(GL.GL_TEXTURE0+2);
  gl.glBindTexture(GL.GL_TEXTURE_2D, tex[0]);
  gl.glActiveTexture(GL.GL_TEXTURE0+1);
  gl.glBindTexture(GL.GL_TEXTURE_2D, tex[1]);
  
  gl.glUniform1i(shaderimgloc[0],2);
  gl.glUniform1i(shaderimgloc[1],1);
  gl.glVertexAttrib3f(tangentLoc,-1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
//  pointLight(220,220,250,40,0,-400);
  camera(400*sin(mx),0,-400*cos(mx),0,0,0,0,1,0);
  perspective(PI/3.0,4.0/3.0,1,1000);

  pointLight(255,255,255,0,0,-100);
  ((PGraphicsOpenGL)g).beginGL();
  gl.glPushMatrix();
  rotateY(a);
//  gl.glRotatef(360*a,0,1,0);
  
  gl.glBegin(GL.GL_QUADS);
  gl.glNormal3f(0,0,-1);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-100,100,-100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-100,-100,-100);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(100,-100,-100);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(100,100,-100);
//  gl.glEnd();
//  gl.glBegin(GL.GL_QUADS);
  gl.glNormal3f(1,0,0);
  gl.glVertexAttrib3f(tangentLoc,0,0,1);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(100,-100,100);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(100,100,100);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(100,100,-100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(100,-100,-100);

  gl.glNormal3f(0,0,1);
  gl.glVertexAttrib3f(tangentLoc,-1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-100,-100,100);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-100,100,100);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(100,100,100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(100,-100,100);
  
  gl.glNormal3f(-1,0,0);
  gl.glVertexAttrib3f(tangentLoc,0,0,-1);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-100,100,100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-100,-100,100);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-100,-100,-100);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-100,100,-100);

  gl.glNormal3f(0,1,0);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,0,-1);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(100,100,100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-100,100,100);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-100,100,-100);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(100,100,-100);
  
  gl.glNormal3f(0,-1,0);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,0,-1);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-100,-100,100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(100,-100,100);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(100,-100,-100);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-100,-100,-100);
    
  gl.glEnd();
  gl.glPopMatrix();
/*  gl.glBegin(GL.GL_QUADSS);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,1,0);
  gl.glNormal3f(0,0,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(100,100,-100);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-100,100,-100);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-100,-100,-100);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(100,-100,-100);
  gl.glEnd();*/
  
  
  
  glsl.endShader();
    ((PGraphicsOpenGL)g).endGL();
}

