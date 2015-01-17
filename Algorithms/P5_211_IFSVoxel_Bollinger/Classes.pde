
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
    float [] demo = {1.3, -0.5, -1.3, -0.8, 1.1, 0.6, 0.9, 2.2, 0.3};
    for (int i=0; i<ncoefs; i++)
      coefs[i] = demo[i];
    estimate(100,100,100);
  }
  void create() {
    for (int i=0; i<ncoefs; i++)
      coefs[i] = random(-PI,PI);
    estimate(100,100,100);
  }
  void apply() {
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
  void estimate(int ncp, int nprime, int niter) {
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
  void iterate(int ncp, int nprime, int niter) {
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
  void create() {
    x = random(-1.0,1.0);
    y = random(-1.0,1.0);
    z = random(-1.0,1.0);
  }
  void draw(Extent ex) {
    float n = float(vox.n);
    int ix = int((x - ex.minx) / ex.width * n);
    int iy = int((y - ex.miny) / ex.height * n);
    int iz = int((z - ex.minz) / ex.depth * n);
    vox.mark(ix,iy,iz);
  }
} 

class Extent {
  float minx,miny,maxx,maxy,minz,maxz;
  float width, height, depth;
  Extent() {}
  void calc() {
    width = maxx - minx;
    height = maxy - miny;
    depth = maxz - minz;
  }
  void untrack() {
    minx = miny = minz = 9999;
    maxx = maxy = maxz = -9999;
  }
  void track(float x, float y, float z) {
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
    m = float(n) / 2.0f;
    scaler = width / 2.0f / float(n);
    boxsize = scaler * 0.7f;
    cells = new int[n][n][n];
    rgbs = new int[n];
    for (int i=0; i<n; i++)
      rgbs[i] = int(40.0f + float(i) / float(n-1) * 160.0f);
  }
  void boxsize(float ratio) {
    boxsize = scaler * ratio;
  }
  void wipe() {
    for (int z=0; z<n; z++)
      for (int y=0; y<n; y++)
        for (int x=0; x<n; x++)
          cells[z][y][x] = 0;
  }
  void mark(int x, int y, int z) {
    if ((x>=0) && (x<n) && (y>=0) && (y<n) && (z>=0) && (z<n)) {
      ++cells[z][y][x];
    }
  }
  void draw() {
    noStroke();
    for (int z=0; z<n; z++) {
      float tz = (z-m+0.5)*scaler;
      for (int y=0; y<n; y++) {
        float ty = (y-m+0.5)*scaler;
        for (int x=0; x<n; x++) {
          float tx = (x-m+0.5)*scaler;
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

