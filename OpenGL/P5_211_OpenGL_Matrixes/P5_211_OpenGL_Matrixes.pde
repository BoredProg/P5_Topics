import javax.media.opengl.GL2;
 
float a; 
GL2 gl; 
PJOGL pgl;
float[] projMatrix;
float[] mvMatrix;
PGraphicsOpenGL thePGL;
 
void setup() {
  size(800, 600, OPENGL);
   pgl = (PJOGL)beginPGL();
 
  gl = pgl.gl.getGL2();

  thePGL = (PGraphicsOpenGL) g;
  projMatrix = new float[16];
  mvMatrix = new float[16]; 
}
 
void draw() {
  background(255);
  loadMatrix();
  
  beginPGL();
  // Do some things with gl.xxx functions here.
  // For example, the program above is translated into:
  gl.glColor4f(0.7, 0.7, 0.7, 0.8);
  gl.glTranslatef(width/2, height/2, 0);
  gl.glRotatef(a, 1, 0, 0);
  gl.glRotatef(a*2, 0, 1, 0);
  gl.glRectf(-200, -200, 200, 200);
  gl.glRotatef(90, 1, 0, 0);
  gl.glRectf(-200, -200, 200, 200);
 
  endPGL();
 
  a += 0.5;
}
 
 
void loadMatrix() {
 
  gl.glMatrixMode(GL2.GL_PROJECTION);
  projMatrix[0] = thePGL.projection.m00;
  projMatrix[1] = thePGL.projection.m10;
  projMatrix[2] = thePGL.projection.m20;
  projMatrix[3] = thePGL.projection.m30;
 
  projMatrix[4] = thePGL.projection.m01;
  projMatrix[5] = thePGL.projection.m11;
  projMatrix[6] = thePGL.projection.m21;
  projMatrix[7] = thePGL.projection.m31;
 
  projMatrix[8] = thePGL.projection.m02;
  projMatrix[9] = thePGL.projection.m12;
  projMatrix[10] = thePGL.projection.m22;
  projMatrix[11] =thePGL.projection.m32;
 
  projMatrix[12] = thePGL.projection.m03;
  projMatrix[13] = thePGL.projection.m13;
  projMatrix[14] = thePGL.projection.m23;
  projMatrix[15] = thePGL.projection.m33;
 
  gl.glLoadMatrixf(projMatrix, 0);
 
  gl.glMatrixMode(GL2.GL_MODELVIEW);
  mvMatrix[0] = thePGL.modelview.m00;
  mvMatrix[1] = thePGL.modelview.m10;
  mvMatrix[2] = thePGL.modelview.m20;
  mvMatrix[3] =thePGL.modelview.m30;
 
  mvMatrix[4] = thePGL.modelview.m01;
  mvMatrix[5] = thePGL.modelview.m11;
  mvMatrix[6] = thePGL.modelview.m21;
  mvMatrix[7] = thePGL.modelview.m31;
 
  mvMatrix[8] = thePGL.modelview.m02;
  mvMatrix[9] = thePGL.modelview.m12;
  mvMatrix[10] = thePGL.modelview.m22;
  mvMatrix[11] = thePGL.modelview.m32;
 
  mvMatrix[12] = thePGL.modelview.m03;
  mvMatrix[13] = thePGL.modelview.m13;
  mvMatrix[14] = thePGL.modelview.m23;
  mvMatrix[15] = thePGL.modelview.m33;
  gl.glLoadMatrixf(mvMatrix, 0);
}
