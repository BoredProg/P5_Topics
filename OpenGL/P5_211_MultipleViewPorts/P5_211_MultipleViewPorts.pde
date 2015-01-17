import javax.media.opengl.glu.*;
import javax.media.opengl.GL2;
import com.jogamp.opengl.util.gl2.GLUT;



PGraphicsOpenGL pg;
PJOGL pgl;
GL2 gl;
GLU glu;
GLUT glut;


void setup() 
{ 
  size(800,600,OPENGL); 
  frame.setLocation(0,0);
   pg = (PGraphicsOpenGL) g;
   pgl = (PJOGL) beginPGL();
   gl = pgl.gl.getGL2();
   glu = pgl.glu;
   glut = new GLUT();
} 
 
void draw() 
{ 
  background(0); 
  
   gl = pgl.gl.getGL2();
  
  //required.... 
  //pgl.beginGL(); 
  gl.glViewport(0,0,200,200);   
  
  perspective(PI/3.0,200/200,0.001,10000);  
  camera(0,0,-300,0,0,0,0,-1,0); 
  //end of required. 
  noStroke();
  translate(100,100,0); 
  sphere(50); 
  endPGL(); 
   
  //pgl.beginGL(); 
  gl.glViewport(400,0,200,200); 

  perspective(PI/3.0,200/200,0.001,10000); 
  //camera(0,0,-300 + frameCount,0,0,0,0,-1,0);
 camera(0,0,-300,0,0,0,0,-1,0);  
  noStroke(); 
  
  box(50);
  endPGL();
  
} 
