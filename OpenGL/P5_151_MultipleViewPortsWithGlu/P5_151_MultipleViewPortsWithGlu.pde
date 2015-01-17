import processing.opengl.*; 
import javax.media.opengl.*; 
import javax.media.opengl.glu.*; 
 
GL gl; 
GLU glu; 
PGraphicsOpenGL pgl; 
void setup() 
{ 
  size(2048,768,OPENGL); 
  pgl=((PGraphicsOpenGL)g); 
  gl=pgl.gl; 
  glu=pgl.glu; 
} 
 
void draw() 
{ 
  background(0); 
  //required.... 
  pgl.beginGL(); 
  gl.glViewport(0,0,1024,768); 
  pgl.endGL(); 
  perspective(PI/3.0,1024.0/768.0,0.001,10000);  
  camera(0,0,-300,0,0,0,0,-1,0); 
  //end of required. 
  noStroke(); 
  sphere(50); 
   
  pgl.beginGL(); 
  gl.glViewport(1024,0,1024,768); 
  pgl.endGL(); 
  perspective(PI/3.0,1024.0/768.0,0.001,10000); 
  camera(0,0,-300 + frameCount,0,0,0,0,-1,0); 
  noStroke(); 
  box(50); 
} 
