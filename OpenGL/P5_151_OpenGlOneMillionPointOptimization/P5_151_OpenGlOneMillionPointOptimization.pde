/**
1000000points taken from http://processinghacks.com/hacks:1000000points
@author Tom Carden
*/
 
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.*;
import processing.opengl.*;
import java.nio.*;
 
// let's try 1,000,000 points
int numPoints = 1000000;
 
// pan, zoom and rotate
float tx = 0, ty = 0;
float sc = 1;
float a = 0.0;
 
// you'd better leave these here
// otherwise they get garbage collected after setup
// and everything will crash
FloatBuffer vbuffer;
FloatBuffer cbuffer;
 
void setup() {
  size(screen.width/2, screen.height/2, OPENGL);
 
  smooth();
 
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
  GL gl = pgl.beginGL();  // always use the GL object returned by beginGL
 
  vbuffer = BufferUtil.newFloatBuffer(numPoints * 2);
  cbuffer = BufferUtil.newFloatBuffer(numPoints * 3);
  for (int i = 0; i < numPoints; i++) {
    // random x,y
    vbuffer.put(random(width));
    vbuffer.put(random(height));
    // random r,g,b
    cbuffer.put(random(1.0));
    cbuffer.put(random(1.0));
    cbuffer.put(random(1.0));
  }
  vbuffer.rewind();
  cbuffer.rewind();
 
  gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
  gl.glVertexPointer(2, GL.GL_FLOAT, 0, vbuffer);
 
  gl.glEnableClientState(GL.GL_COLOR_ARRAY);
  gl.glColorPointer(3, GL.GL_FLOAT, 0, cbuffer);
 
  gl.setSwapInterval(0);
  pgl.endGL();
 
}
 
void draw() {
  //  if (currentTime == startTime)
  background(0);
 
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
  GL gl = pgl.beginGL();  // always use the GL object returned by beginGL

  gl.glPushMatrix();
  gl.glTranslatef(width/2, height/2, 0);
  gl.glScalef(sc,sc,sc);
  gl.glRotatef(a, 0.0, 0.0, 1.0);
  gl.glTranslatef(-width/2, -height/2, 0);
  gl.glTranslatef(tx,ty, 0);
 
  gl.glPointSize(2.0);
 
  gl.glDrawArrays(GL.GL_POINTS, 0, numPoints);
 
  gl.glPopMatrix();
 
  pgl.endGL();
 
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        a -= 1;
      }
      else if (keyCode == RIGHT) {
        a += 1;        
      }
    }
    else if (key == '+' || key == '=') {
      sc *= 1.05;
    }
    else if (key == '_' || key == '-' && sc > 0.1) {
      sc *= 1.0/1.05;
    }
    else if (key == ' ') {
      sc = 1.0;
      tx = 0;
      ty = 0; 
      a = 0;
    }
  }
 
}
 
void mouseDragged() {
  float dx = (mouseX - pmouseX) / sc;
  float dy = (mouseY - pmouseY) / sc;
  float angle = radians(-a);
  float rx = cos(angle)*dx - sin(angle)*dy;
  float ry = sin(angle)*dx + cos(angle)*dy;
  tx += rx;
  ty += ry;
}
 
