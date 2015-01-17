import javax.media.opengl.*;
import processing.opengl.*;

import com.sun.opengl.util.GLUT;

PFont font;
PImage spot;
SphericalDistanceCalculator SDC;
PointOnUnitSphere pous[];

PGraphicsOpenGL pgl;
GL gl;
GLUT              glut;

int displayList;
int sphereList;

int nPous;
int maxNPous;
float mx = 0;
float my = 0;


long lastFrameTime = 0;
long lastAddTime = 0;
float mspf = 16.6666;

/*************************************************
 *
 *************************************************/
void setup()
{
  size(1500,1000,OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);

  spot = loadImage("particle230x230.png"); 

  nPous = 1;
  maxNPous = 256;
  pous = new PointOnUnitSphere[maxNPous];
  SDC  = new SphericalDistanceCalculator();

  for (int i=0; i<maxNPous; i++)
  {
    float lat = acos(random(-1,1)) - HALF_PI;
    float lon = random(0, TWO_PI); 

    pous[i] = new PointOnUnitSphere(i);
    pous[i].setPositionFromCorrectLatLon(lat, lon);
  }


}






/*************************************************
 *
 *************************************************/
void draw()
{


  updateEu();

  background(60,60,60);
  noStroke();
  lights();

  //adjustPointCountForFrameRate();
  nPous = maxNPous;

  // Choose the right blend function.
  
  
  //fill(255);
  int a,b;
  pgl = (PGraphicsOpenGL) g;  // g may change
  gl = pgl.beginGL(); 

  
  a = 2; //2
  b = 8; //8

  // Rotate and draw the points.
  float R = 1200;
  
  mx = 0.99*mx + 0.01*(mouseX-width/2);
  my = 0.99*my + 0.01*(mouseY);

  pushMatrix();
  translate(width/1, height/2 +450,-1200); 
  rotateY(millis()/5000.0);
  rotateY(mx/50.0);
  rotateX(HALF_PI); 
  rotateX(0-my/50.0); 

  gl.glDisable(gl.GL_DEPTH_TEST);
  gl.glEnable(gl.GL_BLEND);
  gl.glBlendFunc (sfact[a], dfact[b]);  
  
  for (int i=0; i<nPous; i++)
  {
    float d = 140 + 30 * noise(i+millis()/(i+147.0));
    
    tint(134,175,255);
    pous[i].draw(R,d);
    //gl.glCallList(sphereList);

    tint(220,255,255);    
    pous[i].draw(R+3,d*0.50);

  }
  
  
  /*
  
  gl.glBlendFunc (sfact[1], dfact[0]);
  gl.glDisable(gl.GL_DEPTH_TEST);
  gl.glDisable(gl.GL_BLEND);
  gl.glDepthMask( false );	

  sphere(300);
  */
  
  
  popMatrix();

  pgl.endGL();
}





void adjustPointCountForFrameRate()
{
  /*
  // Hold the framerate constant by adjusting the number of points we see.
   
   long now = millis();
   float A = 0.95;
   float B = 1.0-A;
   mspf = A*mspf + B*(now - lastFrameTime);
   lastFrameTime = now;
   if (mspf > 24)
   {
   nPous = max(20, nPous-4);
   } 
   if (frameCount % 10 == 0){
   if ((mspf < 16.66666) || (millis()<5000)) {
   nPous = min(maxNPous, nPous+1);
   lastAddTime = now;
   } 
   else if (mspf > 17.66666){
   if (millis()>5000){
   nPous = max(20, nPous-1);
   }
   }
   }
   */
}

void drawConnections()
{
  /*
  // Draw the connections between the points.
   a = 4;//(mouseX/10)%sfact.length; //4
   b = 5;//(mouseY/10)%dfact.length; //14;//(millis()/600)%dfact.length; //5
   gl.glBlendFunc (sfact[a], dfact[b]);
   
   stroke(255,255,255,10);
   float M = 0.45;
   for (int i=0; i<nPous; i++){
   PointOnUnitSphere S = pous[i];
   for (int j=0; j<i; j++){
   PointOnUnitSphere F = pous[j];
   float distance = SDC.getSphericalAngleArccos (S, F);
   if (distance < M){
   SDC.drawArcBetweenTwoPointsOnUnitSphere (S, F, R, distance);
   }
   }
   
   
   }
   */

}



//--------------------------------------------
// Update the forces on the points, 
// so that they mutually repel or attract.
//
void updateEu(){

  float sub = 0.47;
  float C =  0.00002 * (noise(millis()/200.0)-sub);
  if (mousePressed)
  {
    C = -0.00001;
  }

  for (int i=0; i<nPous; i++)
  {
    PointOnUnitSphere S = pous[i];
    for (int j=0; j<i; j++)
    {
      PointOnUnitSphere F = pous[j];

      float dx = S.x - F.x;
      float dy = S.y - F.y; 
      float dz = S.z - F.z;
      float dh2 = (dx*dx + dy*dy + dz*dz); 

      float fx = C * dx/dh2;
      float fy = C * dy/dh2;
      float fz = C * dz/dh2;

      S.accumulateEuclideanForce ( fx, fy, fz);
      F.accumulateEuclideanForce (-fx,-fy,-fz);

    }
  }
  for (int i=0; i<nPous; i++)
  {
    pous[i].updateEuclideanForces();
  }
}


