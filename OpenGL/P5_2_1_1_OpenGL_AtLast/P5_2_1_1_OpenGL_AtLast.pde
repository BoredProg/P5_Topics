/*
Code from updated processing wiki for processing 2.1.1
*/

import javax.media.opengl.glu.*;
import javax.media.opengl.GL2;
import com.jogamp.opengl.util.gl2.GLUT;
import java.nio.*;
 
float[] projMatrix;
float[] mvMatrix;
 


PGraphicsOpenGL pg;
PJOGL pgl;
GL2 gl;
GLU glu;
GLUT glut;

int quadlength;
int[] quad_vbo = new int[1];
int SIZEOF_FLOAT = 4;
 
void setup() 
{
  size(1280, 720, OPENGL);
  projMatrix   = new float[16];
  mvMatrix     = new float[16];
  initVBO();
}
 
void draw() 
{
   pg = (PGraphicsOpenGL) g;
   pgl = (PJOGL) beginPGL();
   gl = pgl.gl.getGL2();
   glu = pgl.glu;
   glut = new GLUT();

   //gl = pgl.gl.getGL2();  // don't forget "endPGL at the end"??
   //gl = GLU.getCurrentGL().getGL2();
  
  loadMatrix();
  gl.glEnableClientState(GL2.GL_VERTEX_ARRAY);
  gl.glBindBuffer(GL2.GL_ARRAY_BUFFER, quad_vbo[0]);
  gl.glVertexPointer(2, GL2.GL_FLOAT, 0, 0);
  gl.glDrawArrays(GL2.GL_QUADS, 0, quadlength);
  gl.glBindBuffer(GL2.GL_ARRAY_BUFFER, 0);
  gl.glDisableClientState(GL2.GL_VERTEX_ARRAY);
  
  endPGL();
}
 
void initVBO() 
{
  pgl = (PJOGL)beginPGL();
  gl = pgl.gl.getGL2(); 
  
  ArrayList quadvbo = new ArrayList();
  quadvbo.add(new ms_vector2(20, 20));
  quadvbo.add(new ms_vector2(200, 20));
  quadvbo.add(new ms_vector2(200, 200));
  quadvbo.add(new ms_vector2(20, 200));
 
  quadlength = quadvbo.size();
  if (quadlength > 0) {
    gl.glGenBuffers(1, quad_vbo, 0);
    gl.glBindBuffer(GL2.GL_ARRAY_BUFFER, quad_vbo[0]);
    gl.glBufferData(GL2.GL_ARRAY_BUFFER, quadlength * 2 * SIZEOF_FLOAT, ms_vector2_to_float_buffer(quadvbo), GL2.GL_STATIC_DRAW);
    gl.glBindBuffer(GL2.GL_ARRAY_BUFFER, 0);
    quadvbo = null;
  }
  endPGL();
}
 
class ms_vector2 {
  float x, y;
 
  // constructor
  ms_vector2() {
    this.x = 0;
    this.y = 0;
  }
 
  ms_vector2( float _x, float _y) {
    this.x = _x;
    this.y = _y;
  }
}
 
// buffer converters
FloatBuffer ms_vector2_to_float_buffer(ArrayList _vector) {
  FloatBuffer a = ByteBuffer.allocateDirect(_vector.size() * 2 * SIZEOF_FLOAT).order(ByteOrder.nativeOrder()).asFloatBuffer();
 
  for (int i = 0; i < _vector.size(); i++) {
    ms_vector2 v = (ms_vector2) _vector.get(i);
    a.put(v.x);
    a.put(v.y);
  }
  a.rewind();
  return a;
}
 
void loadMatrix() {
  gl.glMatrixMode(GL2.GL_PROJECTION);
  PGraphicsOpenGL pg = (PGraphicsOpenGL)g;
  projMatrix[0] = pg.projection.m00;
  projMatrix[1] = pg.projection.m10;
  projMatrix[2] = pg.projection.m20;
  projMatrix[3] = pg.projection.m30;
 
  projMatrix[4] = pg.projection.m01;
  projMatrix[5] = pg.projection.m11;
  projMatrix[6] = pg.projection.m21;
  projMatrix[7] = pg.projection.m31;
 
  projMatrix[8] = pg.projection.m02;
  projMatrix[9] = pg.projection.m12;
  projMatrix[10] = pg.projection.m22;
  projMatrix[11] = pg.projection.m32;
 
  projMatrix[12] = pg.projection.m03;
  projMatrix[13] = pg.projection.m13;
  projMatrix[14] = pg.projection.m23;
  projMatrix[15] = pg.projection.m33;
 
  gl.glLoadMatrixf(projMatrix, 0);
 
  gl.glMatrixMode(GL2.GL_MODELVIEW);
  mvMatrix[0] = pg.modelview.m00;
  mvMatrix[1] = pg.modelview.m10;
  mvMatrix[2] = pg.modelview.m20;
  mvMatrix[3] = pg.modelview.m30;
 
  mvMatrix[4] = pg.modelview.m01;
  mvMatrix[5] = pg.modelview.m11;
  mvMatrix[6] = pg.modelview.m21;
  mvMatrix[7] = pg.modelview.m31;
 
  mvMatrix[8] = pg.modelview.m02;
  mvMatrix[9] = pg.modelview.m12;
  mvMatrix[10] = pg.modelview.m22;
  mvMatrix[11] = pg.modelview.m32;
 
  mvMatrix[12] = pg.modelview.m03;
  mvMatrix[13] = pg.modelview.m13;
  mvMatrix[14] = pg.modelview.m23;
  mvMatrix[15] = pg.modelview.m33;
  gl.glLoadMatrixf(mvMatrix, 0);
}
