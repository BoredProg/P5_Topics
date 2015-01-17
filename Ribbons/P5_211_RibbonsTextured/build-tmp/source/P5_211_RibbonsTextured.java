import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import javax.media.opengl.*; 
import javax.media.opengl.glu.*; 
import com.jogamp.opengl.util.texture.*; 
import java.nio.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_RibbonsTextured extends PApplet {

/*
*  Ribbon by Christophe Gu\u00e9bert, 08/2011
*  A 2d Bezier patch which control points are moving autonomously,
*   textured, and its opacity depending on the distance of neighbor points.
*  Rendered in real time using OpenGL, with Buffer Objects for vertices, color and texture coordinates.
*  As I am not a drawing artist, I couldn't create textures I liked, so for now it's only a simple gradient.
* 
*  Keyboard interaction :
*  SPACE : new random control polygon
*  0-9 : change colors
*  +/- : increase/decrease subdivision (beware, it can become very slow very fast)
*  p : pause movement
*  o : toggle opacity computation
*  t : toggle texture
*  g : toggle drawing of the quads
*  c : toggle drawing of the control points
*
*  It is possible to move control points with the mouse, but as it is very tedious to place 50 points
*   they move randomly by default.
*/
 
 
            // Processing OpenGL library
          // JOgl




                     // For buffers
//import com.sun.opengl.util.BufferUtil; // Buffers creation utility functions
 

// OPENGL 
PJOGL pgl;
GL2 gl;


// Parameters
final int nbx = 7, nby = 7;          // Number of control points for each direction
final int texSize = 1024;            // Size of the texture (square)
final float opacityBase = 0.35f;      // Initial opacity
final float opacityCoefMin = 0.125f;  // How much it can be reduced
final float opacityCoefMax = 8;      // How much it can be augmented
// End of parameters
 
int sx = 16, sy = 16;  // Subdivision level (16 quads in each direction for each control polygon)
PVector[][] points;    // Control points
PVector[][] patch;     // The bezier patch
float[][][][] coef;    // Precomputation of Bernstein polynomials
float[][] opacity;     // Opacity of each points in the patch
float crossSize, crossCoefX, crossCoefY;  // Initial distance between points, ratio width / height
PVector selected;      // For moving a control point with the mouse
int[] texid = new int[1];  // OpenGL texture

boolean showControl = false, showGrid = false, pause = false;  // Flags for rendering
boolean useOpacity = true, useTexture = true;
FloatBuffer vbuffer, tbuffer, cbuffer; // Buffer objects (for speeding up the rendering)
PointsMovement pm;    // Gestion of the control points displacement
 
public void setup()
{
  size(1280, 720, OPENGL);        // If you download this sketch, blow this way up, it's beautiful !
  
  pgl = (PJOGL)beginPGL();
  gl = pgl.gl.getGL2();
  
  smooth(32);
  textureMode(NORMAL);       // Texture coordinates will be [0;1]
  pm = new PointsMovement(3.0f);  // 3 times per second we will pick a new velocity for each control point
   
  // I use a texture because it is smoother across the quads for the color gradients
  gl.glGenTextures(1, texid, 0);
  gl.glBindTexture(GL.GL_TEXTURE_2D, texid[0]);
  gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
  gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
  gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL2.GL_CLAMP);
  gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL2.GL_CLAMP);
  createTexture(0);

  createControlPolygon();
  createBezierPatch();
}
 
public void createControlPolygon()
{
  // Evenly distributed horizontaly, but many overlaps vertically
  points = new PVector[nbx][nby];
  float sw = width/(float)(nbx-1);
  for(int y=0; y<nby; y++)
    for(int x=0; x<nbx; x++) {
      points[x][y] = new PVector( constrain(x*sw + random(-sw*3, sw*3), 0, width)
                                , constrain(height/2 + random(-height/3, height/3), 0, height) );
      pm.add(points[x][y], sw);
    }
}
 
public FloatBuffer createFloatBuffer(int size)
{
  ByteBuffer tmp = ByteBuffer.allocateDirect(size*8);
  tmp.order(ByteOrder.nativeOrder());
  return tmp.asFloatBuffer();
}
 
// First I made it so I could load texture images,
//  but I couldn't create textures that looked better than simple gradients !
public void createTexture(int i)
{
  float r1, r2, g1, g2, b1, b2;
  switch(i) {  // Simple gradient between 2 colors
    case 0: r1=1.0f; g1=0.5f; b1=0.5f; r2=0.5f; g2=0.5f; b2=1.0f; break;
    case 1: r1=1.0f; g1=0.5f; b1=1.0f; r2=0.5f; g2=1.0f; b2=1.0f; break;
    case 2: r1=0.5f; g1=0.0f; b1=1.0f; r2=0.0f; g2=0.5f; b2=0.5f; break;
    case 3: r1=0.5f; g1=0.5f; b1=1.0f; r2=0.5f; g2=1.0f; b2=0.5f; break;
    case 4: r1=0.0f; g1=0.0f; b1=0.5f; r2=0.0f; g2=0.5f; b2=0.5f; break;
    case 5: r1=0.0f; g1=1.0f; b1=1.0f; r2=0.5f; g2=1.0f; b2=0.5f; break;
    case 6: r1=0.0f; g1=0.5f; b1=0.0f; r2=0.5f; g2=0.5f; b2=0.0f; break;
    case 7: r1=1.0f; g1=0.5f; b1=0.0f; r2=1.0f; g2=0.0f; b2=1.0f; break;
    case 8: r1=0.5f; g1=0.0f; b1=0.0f; r2=0.5f; g2=0.0f; b2=0.5f; break;
    case 9: r1=0.0f; g1=0.0f; b1=0.0f; r2=1.0f; g2=1.0f; b2=1.0f; break;
    default : r1=r2=g1=g2=b1=b2=1.0f; break;
  }
   
  // Texture creation into a buffer
  FloatBuffer texbuf = createFloatBuffer(texSize*texSize*4);
  for(int y=0; y<texSize; y++) {
    float fy = (float)y / texSize, fy2 = 1.0f - fy;
    for(int x=0; x<texSize; x++) {
      float fx = (float)x/texSize*2-1;
      float r, g, b, a;
      r = r1 * fy2 + r2 * fy;
      g = g1 * fy2 + g2 * fy;
      b = b1 * fy2 + b2 * fy;
      a = 1.0f;
 
      texbuf.put(r); texbuf.put(g); texbuf.put(b); texbuf.put(a);
    }
  }
  
   InputStream stream = getClass().getResourceAsStream("palette.png");
   TextureData data = TextureIO.newTextureData(GLProfile.getDefault(), stream, false, "png");
   texture = TextureIO.newTexture(data);

  // Load the buffer into a texture
  texbuf.rewind();
  gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, 4, texSize, texSize, 0, GL.GL_RGBA, GL.GL_FLOAT, texbuf);
  
}
 
// These 3 functions are used to compute the bezier patch coefficients
public int fact(int f) { int tmp = 1; for( ; f>1; f--) tmp *= f; return tmp; }  // Factorial
public int binomial(int i, int n) { return fact(n) / (fact(i) * fact(n-i)); }   // Binomial coefficient
public float bernstein(int i, int n, float t) { return binomial(i, n) * pow(t, i) * pow(1-t, n-i); }  // Bernstein polynomial
 
public void createBezierPatch()
{
  int pnx = (nbx-1)*sx+1, pny = (nby-1)*sy+1;
  float sw = width/(float)(pnx-1), sh = height/(float)(pny-1);
       
  crossSize = sw + sh;
  crossCoefX = 1; crossCoefY = 2;  // The patch is approximately 2 times wider than it is high
   
  // Creation of starting grid
  patch = new PVector[pnx][pny];
  for(int y=0; y<pny; y++)
    for(int x=0; x<pnx; x++)
      patch[x][y] = new PVector(x*sw, y*sh);
   
  // As the coefficients don't change, we store them to be faster subsequently
  coef = new float[pnx][pny][nbx][nby];
  float stx = 1.0f / (pnx-1), sty = 1.0f / (pny-1);
  for(int y=0; y<pny; y++)
    for(int x=0; x<pnx; x++) {
      float fx = x*stx, fy = y*sty;
      for(int iy=0; iy<nby; iy++)
        for(int ix=0; ix<nbx; ix++)
          coef[x][y][ix][iy] = bernstein(ix, nbx-1, fx) * bernstein(iy, nby-1, fy);
    }
   
  // Creation of OpenGL buffers
  int nbPts = (pnx-1)*(pny-1)*4*2;
  vbuffer = createFloatBuffer(nbPts);
  tbuffer = createFloatBuffer(nbPts);
  cbuffer = createFloatBuffer(nbPts*2);  // 4 color components instead of 2 coordinates
   
  // Texture coordinates are also constant, so we compute them only once
  tbuffer.rewind();
  for(int y=0; y<pny-1; y++) {
    float fy1 = (float)y / (pny-1), fy2 = (float)(y+1) / (pny-1);
    for(int x=0; x<pnx-1; x++) {
      float fx1 = (float)x / (pnx-1), fx2 = (float)(x+1) / (pnx-1);
      tbuffer.put(fx1); tbuffer.put(fy1);
      tbuffer.put(fx1); tbuffer.put(fy2);
      tbuffer.put(fx2); tbuffer.put(fy2);
      tbuffer.put(fx2); tbuffer.put(fy1);
    }
  }
   
  // Temp array for opacity values
  opacity = new float[pnx][pny];
   
  updatePatch();
   
  println(pnx*pny + " quads");
}
 
// Get a scalar from the distance of neighboring quads
public float getCrossSize(PVector px1, PVector px2, PVector py1, PVector py2, int cx, int cy)
{
  return dist(px1.x, px1.y, px2.x, px2.y) * crossCoefX / cx
       + dist(py1.x, py1.y, py2.x, py2.y) * crossCoefY / cy;
}
 
public void updatePatch()
{
  // Use the precomputed coefficients to update the position of the patch points
  int pnx = (nbx-1)*sx+1, pny = (nby-1)*sy+1;
  for(int y=0; y<pny; y++) {
    for(int x=0; x<pnx; x++) {
      float px = 0, py = 0;
      for(int iy=0; iy<nby; iy++) {
        for(int ix=0; ix<nbx; ix++) {
          PVector p = points[ix][iy];
          float f = coef[x][y][ix][iy];
          px += f * p.x; py += f * p.y;
        }
      }
      patch[x][y].set(px, py, 0);
    }
  }
   
  // Update vertices buffer
  vbuffer.rewind();
  for(int y=0; y<pny-1; y++) {
    float fy1 = (float)y / (pny-1), fy2 = (float)(y+1) / (pny-1);
    for(int x=0; x<pnx-1; x++) {
      float fx1 = (float)x / (pnx-1), fx2 = (float)(x+1) / (pnx-1);
      vbuffer.put(patch[x][y].x); vbuffer.put(patch[x][y].y);
      vbuffer.put(patch[x][y+1].x); vbuffer.put(patch[x][y+1].y);
      vbuffer.put(patch[x+1][y+1].x); vbuffer.put(patch[x+1][y+1].y);
      vbuffer.put(patch[x+1][y].x); vbuffer.put(patch[x+1][y].y);
    }
  }
   
  // Update opacity
  if(useOpacity) {
    for(int y=0; y<pny; y++) {
      for(int x=0; x<pnx; x++) {
        int x1 = max(0, x-1), x2 = min(x+1, pnx-1), y1 = max(0, y-1), y2 = min(y+1, pny-1);
        float es = getCrossSize(patch[x1][y], patch[x2][y], patch[x][y1], patch[x][y2], x2-x1, y2-y1);
        opacity[x][y] = min(255, opacityBase * constrain(crossSize / es, opacityCoefMin, opacityCoefMax));
      }
    }
     
    // Fill color buffer
    cbuffer.rewind();
    for(int y=0; y<pny-1; y++) {
      for(int x=0; x<pnx-1; x++) {
        cbuffer.put(1); cbuffer.put(1); cbuffer.put(1); cbuffer.put(opacity[x][y]);
        cbuffer.put(1); cbuffer.put(1); cbuffer.put(1); cbuffer.put(opacity[x][y+1]);
        cbuffer.put(1); cbuffer.put(1); cbuffer.put(1); cbuffer.put(opacity[x+1][y+1]);
        cbuffer.put(1); cbuffer.put(1); cbuffer.put(1); cbuffer.put(opacity[x+1][y]);
      }
    }
  }
}

 
public void draw()
{
  background(0);
  pm.update();    // Move control points
  updatePatch();  // Update bezier patch
 
  int pnx = (nbx-1)*sx+1, pny = (nby-1)*sy+1;
//  PGraphicsOpenGL pgl = (PGraphicsOpenGL)g;
//  pgl.beginGL();  // Before any drawing call can be used
 
  pgl = (PJOGL)beginPGL();
  gl = pgl.gl.getGL2();
 
  // Draw control polygon
  if(showControl && selected==null)
  {
    // Draw each side of the quads, but don't fill them
    gl.glPolygonMode(GL.GL_FRONT, GL2.GL_LINE);
    gl.glPolygonMode(GL.GL_BACK, GL2.GL_LINE);
    for(int y=0; y<nby-1; y++) {
      float fy1 = (float)y/(nby-1), fy2 = (float)(y+1)/(nby-1);
      gl.glBegin(GL2.GL_QUAD_STRIP);  // Drawing horizontal quad strips
      for(int x=0; x<nbx; x++) {
        float fx = (float)x/(nbx-1);
        gl.glColor4f(1-fx, fy1, fx, 0.5f);
        gl.glVertex2f(points[x][y].x, points[x][y].y);
        gl.glColor4f(1-fx, fy2, fx, 0.5f);
        gl.glVertex2f(points[x][y+1].x, points[x][y+1].y);
      }
      gl.glEnd();
    }
  }
   
  // Use the ADD blending function and don't consider background opacity
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  gl.glBlendEquation(GL.GL_FUNC_ADD);    
   
  // Fill quads
  gl.glPolygonMode(GL.GL_FRONT, GL2.GL_FILL);
  gl.glPolygonMode(GL.GL_BACK, GL2.GL_FILL);
   
  // Prepare vertices buffer
  vbuffer.rewind();
  gl.glEnableClientState (GL2.GL_VERTEX_ARRAY);
  gl.glVertexPointer(2, GL.GL_FLOAT, 0, vbuffer);   
   
  if(useOpacity) {  // Prepare color buffer
    cbuffer.rewind();
    gl.glEnableClientState (GL2.GL_COLOR_ARRAY);
    gl.glColorPointer(4, GL.GL_FLOAT, 0, cbuffer);
  } else  // Or use a constant color for all points
    gl.glColor4f(1.0f, 1.0f, 1.0f, opacityBase);
     
  if(useTexture) {  // Prepare texture coordinates buffer
    tbuffer.rewind();
    gl.glEnable(GL.GL_TEXTURE_2D);
    gl.glEnableClientState(GL2.GL_TEXTURE_COORD_ARRAY);    
    gl.glTexCoordPointer(2, GL.GL_FLOAT, 0, tbuffer);
  }
   
  // Start the drawing
  int nbPts = (pnx-1)*(pny-1)*4;
  gl.glDrawArrays(GL2.GL_QUADS, 0, nbPts);
   
  // Disable all buffers
  if(useOpacity)
    gl.glDisableClientState(GL2.GL_COLOR_ARRAY);
  if(useTexture) {
    gl.glDisableClientState(GL2.GL_TEXTURE_COORD_ARRAY);
    gl.glDisable(GL.GL_TEXTURE_2D);
  }
  gl.glDisableClientState(GL2.GL_VERTEX_ARRAY); 
   
  // Change back the blending function
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA);
 
  // Draw grid
  if(showGrid)
  {
    // Again, lines only
    gl.glPolygonMode(GL.GL_FRONT, GL2.GL_LINE);
    gl.glPolygonMode(GL.GL_BACK, GL2.GL_LINE);
    gl.glColor4f(0.5f, 0.5f, 0.5f, 0.25f);
    for(int y=0; y<pny-1; y++) {
      gl.glBegin(GL2.GL_QUAD_STRIP);
      for(int x=0; x<pnx; x++) {
        gl.glVertex2f(patch[x][y].x, patch[x][y].y);
        gl.glVertex2f(patch[x][y+1].x, patch[x][y+1].y);
      }
      gl.glEnd();
    }
  }
  endPGL();  // We have finished all rendering calls
}
 
public void keyPressed()
{
  if(key >= '0' && key <= '9') {
    createTexture(key - '0');
    return;
  }
   
  switch(key)
  {
    case ' ' : createControlPolygon(); updatePatch(); break;
    case 'c' : showControl = !showControl; break;
    case 'g' : showGrid = !showGrid; break;
    case '+' : sx*=2; sy*=2; createBezierPatch(); break;
    case '-' : sx=max(2, sx/2); sy=max(2, sy/2); createBezierPatch(); break;
    case 'f' : println(floor(frameRate)); break;
    case 'o' : useOpacity = !useOpacity; break;
    case 't' : useTexture = !useTexture; break;
    case 'p' : pause = !pause; break;
  }
}
 
public void mousePressed()
{
  // Select the closest control point
  float minDist = width*width + height*height;
  for(int y=0; y<nby; y++)
    for(int x=0; x<nbx; x++) {
      PVector p = points[x][y];
      float dx = mouseX - p.x, dy = mouseY - p.y;
      float d = dx*dx+dy*dy;
      if(d < minDist && d < 1000) {  // If it is less than 30 pixels away
        minDist = d;
        selected = p;
      }
    }
}
 
public void mouseReleased()
{
  // Deselect
  selected = null;
}
 
public void mouseDragged()
{
  // Move selected control point
  if(selected != null) {
    selected.set(mouseX, mouseY, 0);  // Change position
    pm.reset(selected);               // Reset particle movement so that it doesn't go back to where it was
    updatePatch();                    /// And update the bezier patch
  }
}
// Trying to give a more fluid sensation than with a noise based movement
// It is a physics based simulation of particles, with a random force added to them (which changes often),
//  and a spring wich limit the distance they can get from the initial position.
class Particle
{
  final float friction = 0.25f;  // Limit the velocity
  PVector pos, // The position we want to change
  pos0,        // Initial position
  posS,        // Spring attach position
  vel,         // Velocity
  acc,         // Acceleration
  force;       // Force
  float radius;  // Approximately the maximum distance from the initial position
  Particle(PVector p, float r) {
    radius = r;
    pos = p; pos0 = p.get(); posS = new PVector();
    vel = new PVector(random(-radius, radius), random(-radius, radius));  // Give a non zero initial velocity
    acc = new PVector(); force = new PVector();
    changeDirection();
  }
   
  public void reset() {  // Used when user move the point with the mouse
    pos0.set(pos); posS.set(pos);
    //vel.set(0, 0, 0); acc.set(0, 0, 0); force.set(0, 0, 0);
  }
 
  public void changeDirection() {  // Change random force
    force.set(random(-radius, radius), random(-radius, radius), 0);
    posS.set(pos0.x + random(-radius/2, radius/2), pos0.y + random(-radius/2, radius/2), 0);
  }
 
  public void update(float dt) {  // Time integration
    float dt2 = dt*dt;
    float sx = posS.x - pos.x, sy = posS.y - pos.y; // We simulate a spring to the initial position
    pos.x += vel.x*dt + 0.5f*acc.x*dt2; pos.y += vel.y*dt + 0.5f*acc.y*dt2;
    acc.x = force.x - vel.x * friction + sx; acc.y = force.y - vel.y * friction + sy;
    vel.x += 0.5f*acc.x*dt; vel.y += 0.5f*acc.y*dt;
  }
}
 
// Gestion of all the particles
class PointsMovement
{
  float time = 0;  // Time since sketch start
  float tempo;     // How many times per second will a new random force be computed ?
  int lastTime;    // Last frame timestep
  Vector<Particle> particles;
   
  PointsMovement(float t) {
    tempo = t;
    lastTime = millis();
    particles = new Vector<Particle>();
  }
   
  public void clear() { particles.clear(); }
   
  public void add(PVector p, float r) { particles.add(new Particle(p, r)); }
   
  public void reset(PVector p) { // To be called when the particle is moved by the user
    for(Particle pe : particles) {
      if(pe.pos == p) {
        pe.reset();
        return;
      }
    }
  }
   
  public void update() {
    int newTime = millis();
    float dt = (newTime - lastTime) / 1000.0f;
    lastTime = newTime;
    if(pause) return;
     
    // Is it time to choose new random forces ?
    if(floor(time * tempo) != floor( (time + dt) * tempo))
      for(Particle pe : particles)
        pe.changeDirection();
     
    for(Particle pe : particles)
      pe.update(dt);
    time += dt;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_RibbonsTextured" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
