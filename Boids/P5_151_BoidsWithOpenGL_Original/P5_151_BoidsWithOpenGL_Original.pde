import processing.opengl.*;
import javax.media.opengl.*;

PGraphicsOpenGL pgl;
GL gl;

Target target[];
Boid boid[];


void setup(){
  size(1024, 600, OPENGL);
  background(0);
  smooth();
  target = new Target[numT];
  for(int i=0; i<numT; i++){
    target[i] = new Target();
  }
  boid = new Boid[numBoids];
  for(int i=0; i<numBoids; i++){
    boid[i] = new Boid(target[0]);
  }
}

void draw(){
 background(10);
  pointLight(30,20,90,width/2, height/2, 200);
   glowStuff();
  for(int i=0; i<numT; i++){
    target[i].mover();
   // target[i].render();
  }
  for(int i=0; i<numBoids; i++){
    boid[i].checkDistCurrentTarget();
    boid[i].checkNearestTarget(target);
    boid[i].mover();
    boid[i].render();
  }
  println(frameRate);
}

void glowStuff(){
   pgl = (PGraphicsOpenGL) g; 
  gl = pgl.beginGL(); 
//  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  pgl.endGL(); 
}
  

