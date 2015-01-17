import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_IFSVoxel_Bollinger extends PApplet {

// IFSVoxel
// Dave Bollinger, Nov 2006
// http://www.davebollinger.com
// for Processing 0121 Beta

/**
Press space to generate next<br>
Press '1'..'0' to set box size from small..large<br>
Press 'r' to toggle auto-rotate<br>
Click and drag to manually rotate<br>
*/

IFS ifs;
RGBVoxelCube vox;
float rotx=0f, roty=0f;
boolean autoRotate=true;

public void setup() { 
  size(1280, 720, P3D); // or OPENGL
  smooth(32);
  ifs = new IFS();
  vox = new RGBVoxelCube(12);
} 
 
public void next() {
  vox.wipe();
  ifs.create();
}

public void draw() { 
  ifs.iterate(10,100,10);
  background(0);
  translate(width/2.0f, height/2.0f, 0.0f);
  directionalLight(255, 255, 255, 0.5f, 0.5f, -0.5f);
  directionalLight(255, 255, 255, 0.5f, 0.5f, -0.5f);
  rotateX(rotx);
  rotateY(roty);
  vox.draw();
  if (autoRotate) {
    rotx += 0.013f;
    roty += 0.017f;
  }
} 
 
public void keyPressed() {
  if (key==' ') next();
  if (key=='r') autoRotate=!autoRotate;
  if (key=='1') vox.boxsize(0.1f);
  if (key=='2') vox.boxsize(0.2f);
  if (key=='3') vox.boxsize(0.3f);
  if (key=='4') vox.boxsize(0.4f);
  if (key=='5') vox.boxsize(0.5f);
  if (key=='6') vox.boxsize(0.6f);
  if (key=='7') vox.boxsize(0.7f);
  if (key=='8') vox.boxsize(0.8f);
  if (key=='9') vox.boxsize(0.9f);
  if (key=='0') vox.boxsize(1.0f);
}

public void mouseDragged() {
  rotx += (pmouseY-mouseY) * 0.01f;
  roty += (mouseX-pmouseX) * 0.01f;
}

class IFS {
  static final int ncoefs = 9;
  float [] coefs;
  ControlPoint cp;
  Extent ex;
  IFS() {
    coefs = new float[ncoefs]; 
    cp = new ControlPoint();
    ex = new Extent();
    //
    float [] demo = {1.3f, -0.5f, -1.3f, -0.8f, 1.1f, 0.6f, 0.9f, 2.2f, 0.3f};
    for (int i=0; i<ncoefs; i++)
      coefs[i] = demo[i];
    estimate(100,100,100);
  }
  public void create() {
    for (int i=0; i<ncoefs; i++)
      coefs[i] = random(-PI,PI);
    estimate(100,100,100);
  }
  public void apply() {
    float x = cp.x;
    float y = cp.y;
    float z = cp.z;
    float xp =  cos(coefs[0]*x) + sin(coefs[1]*y) - sin(coefs[2]*z);
    float yp =  sin(coefs[3]*x) - cos(coefs[4]*y) + sin(coefs[5]*z);
    float zp = -cos(coefs[6]*x) + cos(coefs[7]*y) + cos(coefs[8]*z);
    cp.x = xp;
    cp.y = yp;
    cp.z = zp;
  }
  public void estimate(int ncp, int nprime, int niter) {
    ex.untrack();
    for (int i=ncp; i>0; i--) {
      cp.create();
      for (int j=nprime; j>0; j--)
        apply();
      for (int j=niter; j>0; j--) {
        apply();
        ex.track(cp.x,cp.y,cp.z);
      }
    }
    ex.calc();
  }    
  public void iterate(int ncp, int nprime, int niter) {
    for (int i=ncp; i>0; i--) {
      cp.create();
      for (int j=nprime; j>0; j--)
        apply();
      for (int j=niter; j>0; j--) {
        apply();
        cp.draw(ex);
      }
    }
  }   
}

class ControlPoint {
  float x, y, z;
  ControlPoint() {}
  public void create() {
    x = random(-1.0f,1.0f);
    y = random(-1.0f,1.0f);
    z = random(-1.0f,1.0f);
  }
  public void draw(Extent ex) {
    float n = PApplet.parseFloat(vox.n);
    int ix = PApplet.parseInt((x - ex.minx) / ex.width * n);
    int iy = PApplet.parseInt((y - ex.miny) / ex.height * n);
    int iz = PApplet.parseInt((z - ex.minz) / ex.depth * n);
    vox.mark(ix,iy,iz);
  }
} 

class Extent {
  float minx,miny,maxx,maxy,minz,maxz;
  float width, height, depth;
  Extent() {}
  public void calc() {
    width = maxx - minx;
    height = maxy - miny;
    depth = maxz - minz;
  }
  public void untrack() {
    minx = miny = minz = 9999;
    maxx = maxy = maxz = -9999;
  }
  public void track(float x, float y, float z) {
    if (x < minx) minx = x;
    if (x > maxx) maxx = x;
    if (y < miny) miny = y;
    if (y > maxy) maxy = y;
    if (z < minz) minz = z;
    if (z > maxz) maxz = z;
  }
}

class RGBVoxelCube {
  int n;
  int [][][] cells;
  int [] rgbs;
  float m, scaler, boxsize;
  RGBVoxelCube(int _n) {
    n = _n;
    m = PApplet.parseFloat(n) / 2.0f;
    scaler = width / 2.0f / PApplet.parseFloat(n);
    boxsize = scaler * 0.7f;
    cells = new int[n][n][n];
    rgbs = new int[n];
    for (int i=0; i<n; i++)
      rgbs[i] = PApplet.parseInt(40.0f + PApplet.parseFloat(i) / PApplet.parseFloat(n-1) * 160.0f);
  }
  public void boxsize(float ratio) {
    boxsize = scaler * ratio;
  }
  public void wipe() {
    for (int z=0; z<n; z++)
      for (int y=0; y<n; y++)
        for (int x=0; x<n; x++)
          cells[z][y][x] = 0;
  }
  public void mark(int x, int y, int z) {
    if ((x>=0) && (x<n) && (y>=0) && (y<n) && (z>=0) && (z<n)) {
      ++cells[z][y][x];
    }
  }
  public void draw() {
    noStroke();
    for (int z=0; z<n; z++) {
      float tz = (z-m+0.5f)*scaler;
      for (int y=0; y<n; y++) {
        float ty = (y-m+0.5f)*scaler;
        for (int x=0; x<n; x++) {
          float tx = (x-m+0.5f)*scaler;
          if (cells[z][y][x] > 0) {
            fill(color(rgbs[x], rgbs[y], rgbs[z]));
            pushMatrix();
            translate(tx, ty, tz);
            box(boxsize);
            popMatrix();
          }
        }
      }
    }
    noFill();
    stroke(128);
    box(n*scaler);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_IFSVoxel_Bollinger" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
