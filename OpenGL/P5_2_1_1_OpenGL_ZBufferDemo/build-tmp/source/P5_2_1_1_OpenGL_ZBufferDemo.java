import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javax.media.opengl.*; 
import java.nio.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_2_1_1_OpenGL_ZBufferDemo extends PApplet {

 // \u00e7\u203a\u00b4\u00e6\u017d\u00a5OpenGL\u00e3\u0081\u00ae\u00e9\u2013\u00a2\u00e6\u2022\u00b0\u00e3\u201a\u2019\u00e5\u02c6\u00a9\u00e7\u201d\u00a8\u00e3\u0081\u2122\u00e3\u201a\u2039\u00e3\u0081\u0178\u00e3\u201a\u0081


PJOGL pgl;
GL2 gl;

boolean isZbuffer = true;
float theta = 0.f;

public void setup() 
{
  size(800, 600, P3D); // OpenGL\u00e3\u201a\u2019\u00e5\u02c6\u00a9\u00e7\u201d\u00a8\u00e3\u0081\u2122\u00e3\u201a\u2039\u00e5 \u00b4\u00e5\u0090\u02c6\u00e3\u0081\u00af\u00ef\u00bc\u01523\u00e7\u2022\u00aa\u00e7\u203a\u00ae\u00e3\u0081\u00ae\u00e5\u00bc\u2022\u00e6\u2022\u00b0\u00e3\u0081\u00ab OPENGL \u00e3\u201a\u2019\u00e6\u0152\u2021\u00e5\u00ae\u0161
  PFont font = createFont("Arial", 16);
  textFont(font, 24);
}

public void keyPressed(){
  switch(key){
    case 'z':
      isZbuffer = !isZbuffer;
      break;
  }
}

public void draw() {
  background(255);
  //PGraphicsOpenGL pgl = (PGraphicsOpenGL)g;
  //GL gl;
   pgl = (PJOGL)beginPGL();
   gl = pgl.gl.getGL2();
  
  //gl = pgl.beginGL(); // OpenGL\u00e3\u0081\u00ae\u00e5\u2021\u00a6\u00e7\u0090\u2020
    if(!isZbuffer) gl.glDisable(GL.GL_DEPTH_TEST); // Zbuffer\u00e3\u0081\u00aeoff
    gl.glColor4f(.7f, .0f, .0f, .6f);                  // \u00e8\u2030\u00b2\u00e3\u0081\u00ae\u00e6\u0152\u2021\u00e5\u00ae\u0161
    gl.glTranslatef(width / 2, height / 2, 0);     // \u00e5\u00b9\u00b3\u00e8\u00a1\u0152\u00e7\u00a7\u00bb\u00e5\u2039\u2022
    gl.glRotatef(-20, 1, 0, 0);                    // x\u00e8\u00bb\u00b8\u00e5\u2018\u00a8\u00e3\u201a\u0160\u00e3\u0081\u00ae\u00e5\u203a\u017e\u00e8\u00bb\u00a2
    gl.glRotatef(theta, 0, 1, 0);                  // y\u00e8\u00bb\u00b8\u00e5\u2018\u00a8\u00e3\u201a\u0160\u00e3\u0081\u00ae\u00e5\u203a\u017e\u00e8\u00bb\u00a2
    gl.glRectf(-200, -200, 200, 200);              // \u00e7\u0178\u00a9\u00e5\u00bd\u00a2\u00e3\u0081\u00ae\u00e6\u008f\u008f\u00e7\u201d\u00bb
    
    gl.glColor4f(.0f, .7f, .0f, .8f);
    gl.glRotatef(90, 0, 1, 0);
    gl.glRectf(-200, -200, 200, 200);
   endPGL();
  
  theta += 1;
  fill(0);
  text(isZbuffer ? "Zbuffer On" : "Zbuffer Off", 20, 30);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_2_1_1_OpenGL_ZBufferDemo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
