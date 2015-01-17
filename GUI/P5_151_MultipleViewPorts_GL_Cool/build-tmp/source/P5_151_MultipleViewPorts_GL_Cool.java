import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import javax.media.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_151_MultipleViewPorts_GL_Cool extends PApplet {




GL gl;

float a = 0.0f;
boolean bFlush = true;

public void setup() {
  size(600, 600, OPENGL);
  //  noStroke();
  colorMode(RGB,1);
  frameRate(60);
}

public void draw() {
  println(frameRate);
  background(0);
  // bottom Left port - FRONT View
  gl = ((PGraphicsOpenGL)g).beginGL();
  gl.glViewport (0, 0, 300, 300);  
  ((PGraphicsOpenGL)g).endGL();
  perspective(PI/6f, 1f, 10, 1000);
  camera(0,0,600, 0,0,0, 0,1,0);
  renderGeometry();
  if (bFlush) {
    gl.glFlush();
  }
  ((PGraphicsOpenGL)g).endGL();

  // bottom right viewport - BACK View
  gl = ((PGraphicsOpenGL)g).beginGL();
  gl.glViewport(300, 0, 300, 300);  
  ((PGraphicsOpenGL)g).endGL();
  perspective(PI/6f, 1f, 10, 1000);
  camera(0,0,-600, 0,0,0, 0,1,0);
  renderGeometry();
  if (bFlush) {
    gl.glFlush();
  }
  ((PGraphicsOpenGL)g).endGL();

  // top left port - LEFT Viewport
  gl = ((PGraphicsOpenGL)g).beginGL();
  gl.glViewport (0, 300, 300, 300);  
  ((PGraphicsOpenGL)g).endGL();
  perspective(PI/6f, 1f, 10, 1000);
  camera(-600,0,0, 0,0,0, 0,1,0);
  renderGeometry();
  if (bFlush) {
    gl.glFlush();
  }
  ((PGraphicsOpenGL)g).endGL();

  // top right port - RIGHT Viewport
  gl = ((PGraphicsOpenGL)g).beginGL();
  gl.glViewport(300, 300, 300, 300);  
  ((PGraphicsOpenGL)g).endGL();
  perspective(PI/6f, 1f, 10, 1000);
  camera(600,0,0, 0,0,0, 0,1,0);
  renderGeometry();
  if (bFlush) {
    gl.glFlush();
  }
  ((PGraphicsOpenGL)g).endGL();

  a += 0.005f;
}

public void renderGeometry() {
  lights();
  rotateX(a*1);
  rotateY(a*1);

  pushMatrix(); 

  translate(50, 50);  

  scale(60);
  beginShape(QUADS);

  fill(0, 1, 1); 
  vertex(-1,  1,  1);
  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);

  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(1, 1, 0); 
  vertex( 1,  1, -1);
  fill(1, 0, 0); 
  vertex( 1, -1, -1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);

  fill(1, 1, 0); 
  vertex( 1,  1, -1);
  fill(0, 1, 0); 
  vertex(-1,  1, -1);
  fill(0, 0, 0); 
  vertex(-1, -1, -1);
  fill(1, 0, 0); 
  vertex( 1, -1, -1);

  fill(0, 1, 0); 
  vertex(-1,  1, -1);
  fill(0, 1, 1); 
  vertex(-1,  1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);
  fill(0, 0, 0); 
  vertex(-1, -1, -1);

  fill(0, 1, 0); 
  vertex(-1,  1, -1);
  fill(1, 1, 0); 
  vertex( 1,  1, -1);
  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(0, 1, 1); 
  vertex(-1,  1,  1);

  fill(0, 0, 0); 
  vertex(-1, -1, -1);
  fill(1, 0, 0); 
  vertex( 1, -1, -1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);

  endShape();

  popMatrix();
}

public void keyPressed() {
  if (key == 'f') {
    bFlush = !bFlush;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_151_MultipleViewPorts_GL_Cool" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
