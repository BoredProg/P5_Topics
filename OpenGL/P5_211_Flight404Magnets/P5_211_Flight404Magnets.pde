
import processing.opengl.*;
import javax.media.opengl.*;






int xSize           = 1400;
int ySize           = 1000;
float xGrav         = xSize/2;
float yGrav         = ySize/2;
float gravity       = 0.1;

int totalParticles  = 0;
int maxParticles    = 360;
Particle[] particle;

PImage myField;
PJOGL pgl;
GL2 gl;

int counter = 0;

void setup(){
  size(xSize, ySize, OPENGL);
  background(255);
  //smooth();
  ellipseMode(CENTER);
  colorMode(RGB,255);
  
  myField = loadImage("particle.png");
  //brightToAlpha(myField);
  particle  = new Particle[maxParticles];
}

void glowStuff(){
  // pgl = (PGraphicsOpenGL) g; 
  //gl = pgl.beginGL(); 
  pgl = (PJOGL)beginPGL();
  gl = pgl.gl.getGL2();
  
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  endPGL(); 
}


void draw()
{
  if (mousePressed && counter == 0 && totalParticles < maxParticles - 1){
    particle[totalParticles] = new Particle(mouseX, mouseY, totalParticles, 10.0, 1.0);
    totalParticles ++;
    counter ++;
  }
  
  
  if (mouseX != pmouseX && mouseY != pmouseY){
    counter = 0;
  }

  background(200);
   pushMatrix();
   translate(width/2,height/2,0);
   rotateY(radians(frameCount));
   popMatrix();
   
   //glowStuff();
   
  //if (totalParticles > 1){
    for (int i=0; i<totalParticles; i++){
      particle[i].field();
    }
    for (int i=0; i<totalParticles; i++){
      particle[i].render();
    }
    for (int i=0; i<totalParticles; i++){
      particle[i].move();
    }
    for (int i=0; i<totalParticles; i++){
      particle[i].applyGravity();
    }
  //}
}

void mouseReleased(){
  counter = 0;
}


class Particle {
  int index;
  
  float[] x;
  float[] y;
  
  float xv = random(-1.0,1.0);
  float yv = random(-1.0,1.0);
  
  int tailLength = 3;

  float myVel;
  float myAngle;
  float myDist;
  
  float[] E;      // energy
  float[] R;      // radius
  float[] F;      // force
  float[] P;      // Pauli force
  float[] A;      // accel
  float[] Angle;  // angle to field
  float Q;        // charge
  float M;        // mass

  float r = random(200.0,255.0);
  float g = random(10.0,200.0);
  float b = random(10.0);

  float totalConnections;

  float gAngle;                 // Angle to gravity center in degrees
  float gTheta;                 // Angle to gravity center in radians
  float gxv;                    // Gravity velocity along x axis
  float gyv;                    // Gravity velocity along y axis
  
  Particle(float xSent, float ySent, int sentIndex, float sentQ, float mass)
  {
      x         = new float[tailLength];
    y         = new float[tailLength];
    for (int i=0; i<tailLength; i++){
      x[i]    = xSent;
      y[i]    = ySent;
    }

    E         = new float[maxParticles];
    R         = new float[maxParticles];
    F         = new float[maxParticles];
    P         = new float[maxParticles];
    A         = new float[maxParticles];
    Angle     = new float[maxParticles];

    index     = sentIndex;
    
    M         = mass;
    Q         = sentQ;
      
  }
  
  Particle(float xSent, float ySent, int sentIndex, float sentQ)
  {
      this(xSent, ySent, sentIndex, sentQ, 1.0);  
  }
  
  void field(){
    totalConnections = 0.0;
    for (int i=0; i<totalParticles; i++){
      if (i != index){
        R[i]             = findDistance(particle[i].x[0], particle[i].y[0], x[0], y[0]);
        if (R[i] < 51.0){
          totalConnections += 0.2;
          stroke(0, (51 - R[i]) * 5.0);
          line(particle[i].x[0], particle[i].y[0], x[0], y[0]);
        }
        E[i]             = (particle[i].Q/(R[i] * R[i]));
        E[i]             = constrain(E[i], -0.01, 0.01);
        
        P[i]             = abs(Q) * abs(particle[i].Q) / pow(R[i],12);
        F[i]             = (Q * E[i]) + P[i];
        F[i]             = (Q * E[i]);
        A[i]             = (F[i]/M) * 10.0;
        Angle[i]         = PI-radians(findAngle(x[0], y[0], particle[i].x[0], particle[i].y[0]));
      
        xv += cos(Angle[i]) * A[i];
        yv += sin(Angle[i]) * A[i];
      }
    }
    xv *= .96;
    yv *= .96;
    Q -= (Q - (totalConnections + .5)) * .1;
  }

  void move(){
    for (int i=tailLength - 1; i>0; i--){
      x[i] = x[i-1];
      y[i] = y[i-1];
    }
    
    x[0] += xv;
    y[0] += yv;
    
    myVel   = findDistance(x[0], y[0], x[1], y[1]);
    myAngle = findAngle(x[0], y[0], x[1], y[1]);
    myDist  = findDistance(x[0], y[0], mouseX, mouseY);
  }

  void applyGravity(){
    gAngle        = -radians(findAngle(x[0],y[0],xGrav,yGrav));
    gxv           = cos(gAngle) * gravity;
    gyv           = sin(gAngle) * gravity;
    xv += gxv;
    yv += gyv;
  }
  
  void render(){
    float mySize = abs(Q) * 20.0;
    image(myField, x[0] - mySize/2.0, y[0] - mySize/2.0, mySize, mySize);
  }
}

void brightToAlpha(PImage b){
   //b.format = PConstants.RGBA;
   for(int i=0; i < b.pixels.length; i++) {
     b.pixels[i] = color(0,0,0,255 - brightness(b.pixels[i]));
   }
 }

float findDistance(float x1, float y1, float x2, float y2){
  float xd = x1 - x2;
  float yd = y1 - y2;
  float td = sqrt(xd * xd + yd * yd);
  return td;
}
  
float findAngle(float x1, float y1, float x2, float y2){
  float xd = x1 - x2;
  float yd = y1 - y2;

  float t = atan2(yd,xd);
  float a = (180 + (-(180 * t) / PI));
  return a;
}

//
