import javax.media.opengl.*; 
import processing.opengl.*; 
 
PGraphicsOpenGL pgl; 
GL gl; 

// http://processing.org/discourse/yabb_beta/YaBB.cgi?board=OpenGL;action=display;num=1210007450

int count = 10; 
int[] xcoords =  new int[count]; 
int[] ycoords =  new int[count]; 
int[] zcoords =  new int[count]; 
 
void setup(){ 
  size(400, 400, OPENGL); 
  hint(ENABLE_OPENGL_4X_SMOOTH); 
  colorMode(RGB, 1.0, 1.0, 1.0); 
 
  pgl = (PGraphicsOpenGL) g; 
  gl = pgl.beginGL(); 
 
  for(int i=0; i<count; i++){ 
    xcoords[i] = (int) random(width); 
    ycoords[i] = (int) random(width); 
    zcoords[i] = (int) random(-200, 200); 
  } 
} 
void draw(){ 
  background(1); 
  pgl.beginGL();   
  gl.glEnable(GL.GL_LINE_SMOOTH); //Antialiasing 
  gl.glEnable(GL.GL_LINE_STIPPLE); 
  gl.glHint (GL.GL_LINE_SMOOTH_HINT, GL.GL_NICEST); 
 
  gl.glEnable(GL.GL_POINT_SMOOTH); //This is important so that the joins are round 
 
  gl.glColor3f(0,0,0); 
  gl.glLineWidth(10); //line width and pointsize Should have the same value 
  gl.glPointSize(10.0); 
  gl.glRotatef(frameCount, 1,1,1); 
 
//draw the lines 
  gl.glBegin(GL.GL_LINE_STRIP); 
  for(int i=1; i<count; i++){ 
    //strokeWeight(10 * sin((HALF_PI / count) * i)); 
    //line(xcoords[i], ycoords[i], zcoords[i], xcoords[i-1], ycoords[i-1], zcoords[i-1]); 
    gl.glVertex3f(xcoords[i], ycoords[i], zcoords[i]); 
  } 
  gl.glEnd(); 
 
//draw the round points as joins 
 
  gl.glBegin(GL.GL_POINTS); 
  for(int i=1; i<count; i++){ 
    //strokeWeight(10 * sin((HALF_PI / count) * i)); 
    //line(xcoords[i], ycoords[i], zcoords[i], xcoords[i-1], ycoords[i-1], zcoords[i-1]); 
    gl.glVertex3f(xcoords[i], ycoords[i], zcoords[i]); 
  } 
  gl.glEnd(); 
  pgl.endGL(); 
} 
