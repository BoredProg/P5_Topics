import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javax.media.opengl.glu.*; 
import javax.media.opengl.GL2; 
import com.jogamp.opengl.util.gl2.GLUT; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_MultipleViewPorts extends PApplet {







PGraphicsOpenGL pg;
PJOGL pgl;
GL2 gl;
GLU glu;
GLUT glut;


public void setup() 
{ 
  size(800,600,OPENGL); 
  frame.setLocation(0,0);
   pg = (PGraphicsOpenGL) g;
   pgl = (PJOGL) beginPGL();
   gl = pgl.gl.getGL2();
   glu = pgl.glu;
   glut = new GLUT();
} 
 
public void draw() 
{ 
  background(0); 
  
   gl = pgl.gl.getGL2();
  
  //required.... 
  //pgl.beginGL(); 
  gl.glViewport(0,0,200,200);   
  
  perspective(PI/3.0f,200/200,0.001f,10000);  
  camera(0,0,-300,0,0,0,0,-1,0); 
  //end of required. 
  noStroke();
  translate(100,100,0); 
  sphere(50); 
  endPGL(); 
   
  //pgl.beginGL(); 
  gl.glViewport(400,0,200,200); 

  perspective(PI/3.0f,200/200,0.001f,10000); 
  //camera(0,0,-300 + frameCount,0,0,0,0,-1,0);
 camera(0,0,-300,0,0,0,0,-1,0);  
  noStroke(); 
  
  box(50);
  endPGL();
  
} 
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_MultipleViewPorts" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
