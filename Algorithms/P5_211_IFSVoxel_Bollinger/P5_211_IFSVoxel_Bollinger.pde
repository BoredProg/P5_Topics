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

void setup() { 
  size(1280, 720, P3D); // or OPENGL
  smooth(32);
  ifs = new IFS();
  vox = new RGBVoxelCube(12);
} 
 
void next() {
  vox.wipe();
  ifs.create();
}

void draw() { 
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
 
void keyPressed() {
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

void mouseDragged() {
  rotx += (pmouseY-mouseY) * 0.01f;
  roty += (mouseX-pmouseX) * 0.01f;
}
