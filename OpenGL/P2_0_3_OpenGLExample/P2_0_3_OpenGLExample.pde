import processing.opengl.*;
import javax.media.opengl.GL;
import javax.media.opengl.GL2;
import javax.media.opengl.glu.GLU;
import java.util.*;

PVector[] v;
ArrayList<Quad> quads;

public void setup() {
  size(600, 480, OPENGL);
  
  //verts for da cube
  v = new PVector[8];
  v[0] = new PVector(1, 1, 1);
  v[1] = new PVector(-1, 1, 1);
  v[2] = new PVector(-1, -1, 1);
  v[3] = new PVector(1, -1, 1);
  v[4] = new PVector(1, 1, -1);
  v[5] = new PVector(-1, 1, -1);
  v[6] = new PVector(-1, -1, -1);
  v[7] = new PVector(1, -1, -1);
  
  quads = new ArrayList<Quad>();
  quads.add(new Quad(v[0], v[1], v[2], v[3])); //top
  quads.add(new Quad(v[4], v[5], v[6], v[7])); //bottom
  quads.add(new Quad(v[3], v[2], v[6], v[7])); //front
  quads.add(new Quad(v[1], v[0], v[4], v[5])); //back
  quads.add(new Quad(v[2], v[1], v[5], v[6])); //left
  quads.add(new Quad(v[0], v[3], v[7], v[4])); //right
  
}

public void draw() {
  
  background(0, 0, 0);
  
  //all the OpenGL setup bullshit
  //PGraphicsOpenGL pg = ((PGraphicsOpenGL)g);
  //PGL pgl = pg.beginPGL();
  
  PJOGL pgl = (PJOGL)beginPGL();
  GL2 gl2 = pgl.gl.getGL2();
  
  
  
  //GL gl = pgl.gl;
  //GL2 gl2 = pgl.gl.getGL2();
  GLU glu = pgl.glu;
 
 
  
  
  // additive blending
  gl2.glEnable(GL2.GL_BLEND);
  gl2.glBlendFunc(GL2.GL_SRC_ALPHA, GL2.GL_ONE);
  // disable depth test
  gl2.glDisable(GL2.GL_DEPTH_TEST); 
  
  //camera janks
  gl2.glMatrixMode(GL2.GL_MODELVIEW);
  gl2.glLoadIdentity();
  glu.gluPerspective(45.0, width/height, .1, 1000.0 ); 
  glu.gluLookAt(6, 6, 6,
                0, 0, 0, 
                0, 0, 1);
  
  //drawing the cube
  gl2.glPushMatrix();
  gl2.glRotatef(mouseX*2f/width * 360, 1.0, 0.0, 0.0);
  gl2.glRotatef(mouseY*2f/height * 360, 0.0, 1.0, 0.0);
  for (Quad q : quads) {
    gl2.glBegin(gl2.GL_POLYGON);
    
    gl2.glColor4f(.5f, .5f, .5f, .5f);
    gl2.glVertex3f(q.v1.x, q.v1.y, q.v1.z);
    gl2.glVertex3f(q.v2.x, q.v2.y, q.v2.z);
    gl2.glVertex3f(q.v3.x, q.v3.y, q.v3.z);
    gl2.glVertex3f(q.v4.x, q.v4.y, q.v4.z);
    
    gl2.glEnd();
  }
  gl2.glPopMatrix();
  
  endPGL();
}

class Quad {
  
  public PVector v1, v2, v3, v4;
  
  public Quad(PVector v1, PVector v2, PVector v3, PVector v4)
  {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
    this.v4 = v4;
  }
  
}

