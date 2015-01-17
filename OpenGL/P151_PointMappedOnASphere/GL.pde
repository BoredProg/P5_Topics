void initGL(){
  pgl.beginGL();
  
  displayList = gl.glGenLists(1);
  gl.glNewList(displayList, GL.GL_COMPILE);
  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);    gl.glVertex2f(-.5, -.5);
  gl.glTexCoord2f(1, 0);    gl.glVertex2f( .5, -.5);
  gl.glTexCoord2f(1, 1);    gl.glVertex2f( .5,  .5);
  gl.glTexCoord2f(0, 1);    gl.glVertex2f(-.5,  .5);
  gl.glEnd();
  gl.glEndList();
  

  sphereList = gl.glGenLists(2);  
  glut    = new GLUT();
  gl.glNewList(sphereList, GL.GL_COMPILE);
  glut.glutSolidSphere(100,64,64);
  gl.glEndList();
  
  
  pgl.endGL();
}
