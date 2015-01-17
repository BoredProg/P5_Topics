import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javax.media.opengl.*; 
import processing.opengl.*; 
import com.sun.opengl.util.GLUT; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P151_PointMappedOnASphere extends PApplet {






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
float mspf = 16.6666f;

/*************************************************
 *
 *************************************************/
public void setup()
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
public void draw()
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
  
  mx = 0.99f*mx + 0.01f*(mouseX-width/2);
  my = 0.99f*my + 0.01f*(mouseY);

  pushMatrix();
  translate(width/1, height/2 +450,-1200); 
  rotateY(millis()/5000.0f);
  rotateY(mx/50.0f);
  rotateX(HALF_PI); 
  rotateX(0-my/50.0f); 

  gl.glDisable(gl.GL_DEPTH_TEST);
  gl.glEnable(gl.GL_BLEND);
  gl.glBlendFunc (sfact[a], dfact[b]);  
  
  for (int i=0; i<nPous; i++)
  {
    float d = 140 + 30 * noise(i+millis()/(i+147.0f));
    
    tint(134,175,255);
    pous[i].draw(R,d);
    //gl.glCallList(sphereList);

    tint(220,255,255);    
    pous[i].draw(R+3,d*0.50f);

  }
  
  drawConnections();
  
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





public void adjustPointCountForFrameRate()
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

public void drawConnections()
{
  /*
  int a, b;
  // Draw the connections between the points.
   a = (mouseX/10)%sfact.length; //4
   b = (mouseY/10)%dfact.length; //14;//(millis()/600)%dfact.length; //5
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
public void updateEu(){

  float sub = 0.47f;
  float C =  0.00002f * (noise(millis()/200.0f)-sub);
  if (mousePressed)
  {
    C = -0.00001f;
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


public void initGL(){
  pgl.beginGL();
  
  displayList = gl.glGenLists(1);
  gl.glNewList(displayList, GL.GL_COMPILE);
  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);    gl.glVertex2f(-.5f, -.5f);
  gl.glTexCoord2f(1, 0);    gl.glVertex2f( .5f, -.5f);
  gl.glTexCoord2f(1, 1);    gl.glVertex2f( .5f,  .5f);
  gl.glTexCoord2f(0, 1);    gl.glVertex2f(-.5f,  .5f);
  gl.glEnd();
  gl.glEndList();
  

  sphereList = gl.glGenLists(2);  
  glut    = new GLUT();
  gl.glNewList(sphereList, GL.GL_COMPILE);
  glut.glutSolidSphere(100,64,64);
  gl.glEndList();
  
  
  pgl.endGL();
}

// A handy data class
class LatLonPair {
  float lat;
  float lon;
}




//---------------------------------------
class PointOnUnitSphere 
{
  
  int textureId;
  int id;
  float eulat;
  float lat,lon;

  float x,y,z;
  float vx,vy,vz,vh;
  float ax,ay,az;
  float mass;
  float damp;

  PointOnUnitSphere (int i)
  {
    id = i;
    mass = random(0.10f,1.05f);
    damp = random(0.93f,0.98f);

    setLat(0);
    setLon(0);
    vh=vx=vy=vz=0;
    ax=ay=az=0;
    eulat = 0;
    computeEuclidean();
  }

  //---------------------------------------------
  public void setLatLon (float latitude, float longitude)
  {
    // assumes inputs are radians
    setLat(latitude); 
    setLon(longitude);
  }
  public void setLon (float longitude)
  {
    // assumes inputs are radians
    lon = longitude % TWO_PI;
  }
  public void setLat (float latitude)
  {
    // assumes inputs are radians
    lat = (latitude % PI);
    eulat = HALF_PI - lat;
  }

  public void setPositionFromCorrectLatLon (float correctLatitude, float correctLongitude)
  {
    lon = correctLongitude;
    lat = correctLatitude;
    eulat = HALF_PI - correctLatitude;
    float slat = sin(eulat);
    x = cos(correctLongitude) * slat;
    y = sin(correctLongitude) * slat; 
    z = cos(eulat);

  }



  //---------------------------------------------
  public void computeSpherical()
  {
    lat = HALF_PI - acos(z) ;     // phi 
    lon = atan2(y,x);  // theta
    eulat = HALF_PI - lat;
  }
  
  public void computeEuclidean()
  {
    float slat = sin(eulat);
    x = cos(lon) * slat;
    y = sin(lon) * slat; 
    z = cos(eulat);
  }



  //------------------------------------------------------------
  public void accumulateEuclideanForce (float fx, float fy, float fz)
  {
    ax += fx/mass;
    ay += fy/mass;
    az += fz/mass;
  }

  public void updateEuclideanForces()
  {
    vx += ax;
    vy += ay;
    vz += az;
    
    vx *= damp;
    vy *= damp;
    vz *= damp;

    float px = x + vx;
    float py = y + vy;
    float pz = z + vz;
    float pr = sqrt(px*px + py*py + pz*pz);

    float lat2 = HALF_PI - acos(pz/pr);   // phi 
    float lon2 = atan2(py,px);  // theta
    lat  = lat2;
    lon  = lon2; 
    eulat = HALF_PI- lat;

    float slat = sin(eulat);
    x = (cos(lon) * slat);
    y = (sin(lon) * slat); 
    z = (cos(eulat));
  }


  public void drawEllipse (float sphereR, float ellipseD)
  {
    pushMatrix();
    translate(x*sphereR,y*sphereR,z*sphereR); 
    rotateZ(lon);
    rotateY(eulat);

    ellipse(0,0,ellipseD,ellipseD);
    popMatrix();
  }


  public void draw (float R, float D){
    pushMatrix();
    translate(x*R,y*R,z*R); 
    rotateZ(lon);
    rotateY(eulat);
    scale(mass/1.4f);
    image(spot,-D/2,-D/2,D,D);
    //sphereDetail(3);    
    //sphere(D/10);
    //gl.glScalef(2.0f,2.0f,2.0f);
    //gl.glScalef(20, 20, 20); 
    //gl.glCallList(sphereList);
    //gl.glScalef(1, 10, 1);    
    //scale(10,10,1);
    //box(10);
    popMatrix();
  } 
}

class SphericalDistanceCalculator 
{
  // http://en.wikipedia.org/wiki/Great_circle_distance
  // http://williams.best.vwh.net/avform.htm#Crs

  LatLonPair pair; 
  SphericalDistanceCalculator (){
    pair = new LatLonPair();
  }

  public float getSphericalAngleArccos (PointOnUnitSphere S, PointOnUnitSphere F){
    // Inaccurate for small distances.
    float Flat = F.lat;
    float Slat = S.lat;
    float A = cos(Slat) * cos(Flat) * cos(S.lon - F.lon);
    float B = sin(Slat) * sin(Flat);
    return (acos (A + B));
  }

  public float getSphericalAngleArcsin (PointOnUnitSphere S, PointOnUnitSphere F){
    // Inaccurate for antipodal points.
    float dLat = S.lat - F.lat;
    float dLon = S.lon - F.lon;
    float A = sq(sin(dLat/2.0f));
    float B = cos(S.lat) * cos(F.lat) * sq(sin(dLon/2.0f));
    float dang = 2 * asin (sqrt(A + B));
    return (dang);
  }

  public float getSphericalAngleArctan (PointOnUnitSphere S, PointOnUnitSphere F){
    // accurate for all cases, but CPU-heavy.
    float cLatF = cos(F.lat); 
    float sLatF = sin(F.lat); 
    float cLatS = cos(S.lat); 
    float sLatS = sin(S.lat);
    float dLon  = S.lon - F.lon;
    float sdLon = sin(dLon);
    float cdLon = cos(dLon); 

    float A = cLatF * sdLon;
    float B = cLatS * sLatF - sLatS * cLatF * cdLon;
    float C = sLatS * sLatF;
    float D = cLatS * cLatF * cdLon;

    float top = sqrt(A*A + B*B);
    float bot = C + D;
    float dang = atan2(top,bot);
    return (dang);
  } 


  public LatLonPair getPointOnGreatCircle (PointOnUnitSphere S, PointOnUnitSphere F, float distance, float frac){
    float A = sin((1.0f-frac)*distance)/sin(distance);
    float B = sin(frac*distance)/sin(distance);
    float acsl = A*cos(S.lat);
    float bcfl = B*cos(F.lat);

    float x = acsl*cos(S.lon) +  bcfl*cos(F.lon);
    float y = acsl*sin(S.lon) +  bcfl*sin(F.lon);
    float z = A*sin(S.lat)    +  B*sin(F.lat);
    pair.lat = atan2(z,sqrt(x*x+y*y));
    pair.lon = atan2(y,x);
    return pair;
  }


  public LatLonPair getPointOnGreatCircle (float Slat, float Slon, float Flat, float Flon, float distance, float frac){
    float sind = sin(distance);
    float A = sin((1.0f-frac)*distance)/sind;
    float B = sin(frac*distance)      /sind;
    float acsl = A*cos(Slat);
    float bcfl = B*cos(Flat);

    float x = acsl*cos(Slon) +  bcfl*cos(Flon);
    float y = acsl*sin(Slon) +  bcfl*sin(Flon);
    float z = A*sin(Slat)    +  B*sin(Flat);
    pair.lat = atan2(z,sqrt(x*x+y*y));
    pair.lon = atan2(y,x);
    return pair;
  }

  // This doesn't just draw any old arc; it draws a pair of wiggly arcs....
  public void drawArcBetweenTwoPointsOnUnitSphere (PointOnUnitSphere P0, PointOnUnitSphere P1, float R, float distance){
    noFill();
    int np = (int)(degrees(distance)/1.0f) +1;

    float Slat = P0.lat;
    float Slon = P0.lon;
    float Flat = P1.lat;
    float Flon = P1.lon;
    float p0id = P0.id ;
    float mils = millis();
    
    pushMatrix();
    scale(R,R,R);
    for (int k=0; k<2; k++){
      float mlat = k + p0id + mils/(p0id+500.0f);
      float mlon = k + p0id + mils/(p0id+437.0f); 
      float npm1 = (float)(np-1);

      beginShape();
      for (int i=0; i<np; i++){
        float frac = (float)i/npm1;
        LatLonPair P = getPointOnGreatCircle (Slat, Slon, Flat, Flon, distance, frac);
        
        float f = sin(frac*PI);
        P.lat +=  f * 0.10f*(noise(frac + mlat)-0.5f);
        P.lon +=  f * 0.10f*(noise(frac + mlon)-0.5f);
        
        float eulat = HALF_PI - P.lat;
        float slat = sin(eulat);
        float x = cos(P.lon) * slat;
        float y = sin(P.lon) * slat; 
        float z = cos(eulat);
        vertex(x,y,z);  
      }
      endShape();
    }
    popMatrix();
  }



}

 int sfact[] = {
    gl.GL_ZERO, gl.GL_ONE, gl.GL_SRC_COLOR, gl.GL_ONE_MINUS_SRC_COLOR, gl.GL_DST_COLOR, 
    gl.GL_ONE_MINUS_DST_COLOR, gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA, gl.GL_DST_ALPHA, 
    gl.GL_ONE_MINUS_DST_ALPHA, gl.GL_CONSTANT_COLOR, gl.GL_ONE_MINUS_CONSTANT_COLOR,
    gl.GL_CONSTANT_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA, gl.GL_SRC_ALPHA_SATURATE  };
  int dfact[] = {
    gl.GL_ZERO, gl.GL_ONE, gl.GL_SRC_COLOR, gl.GL_ONE_MINUS_SRC_COLOR, gl.GL_DST_COLOR, 
    gl.GL_ONE_MINUS_DST_COLOR, gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA, gl.GL_DST_ALPHA, 
    gl.GL_ONE_MINUS_DST_ALPHA, gl.GL_CONSTANT_COLOR, gl.GL_ONE_MINUS_CONSTANT_COLOR, 
    gl.GL_CONSTANT_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA          };
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P151_PointMappedOnASphere" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
