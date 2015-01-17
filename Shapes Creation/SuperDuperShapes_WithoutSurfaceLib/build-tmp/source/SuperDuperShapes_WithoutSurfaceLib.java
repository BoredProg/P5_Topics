import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.Color; 
import processing.dxf.*; 
import processing.pdf.*; 

import com.lowagie.text.pdf.collection.*; 
import processing.pdf.*; 
import com.lowagie.text.pdf.crypto.*; 
import com.lowagie.tools.*; 
import com.lowagie.text.pdf.*; 
import processing.dxf.*; 
import com.lowagie.text.*; 
import com.lowagie.text.factories.*; 
import com.lowagie.text.html.*; 
import processing.xml.*; 
import com.lowagie.text.pdf.codec.*; 
import processing.core.*; 
import com.lowagie.text.pdf.hyphenation.*; 
import com.lowagie.text.html.simpleparser.*; 
import com.lowagie.text.xml.simpleparser.*; 
import com.lowagie.text.pdf.draw.*; 
import com.lowagie.text.xml.*; 
import com.lowagie.text.pdf.fonts.*; 
import com.lowagie.text.xml.xmp.*; 
import com.lowagie.text.pdf.fonts.cmaps.*; 
import com.lowagie.text.pdf.codec.wmf.*; 
import com.lowagie.text.pdf.events.*; 
import com.lowagie.text.pdf.parser.*; 
import com.lowagie.text.pdf.interfaces.*; 
import com.lowagie.text.pdf.internal.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SuperDuperShapes_WithoutSurfaceLib extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/2638*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */


  /////////////////////////////////////
  //                                 //
  //  /////// superduper shapes      //                          
  //  //                             //
  //  /////////////////////////////////
  //
  /////////// (c) Martin Schneider 2009 
  
  // http://www.k2g2.org/blog:bit.craft
  


final static int LORES=0, MIXRES=1, HIRES=2;
boolean grid = false, faces = true, light = true, colors = true, output=false;
int loRes = 60, hiRes = 180;
int mode = LORES;
float minZoom = 1, maxZoom = 100;
float rotX=PI/4, rotY=-PI/8, rotZ=-PI*2/3, moveX, moveY, zoom = 2;
int[] mousePrecision = {1,2,0};

PGraphics g3d;
PFont font, bfont;

float[][][] m,  mHires;
fnCycle fns = new fnCycle();
shapeFn fn;
int mc0, mc1; // mesh update counters
int ic0, ic1; // image update counters

public void setup() {
  size(1280, 720, P3D);
  g3d = createGraphics(width, height, P3D);
  font = loadFont("FreeSans-12.vlw");
  bfont = loadFont("FreeSansBold-12.vlw");
  
  fns.add(new supershape(40, 4, 10, 10, 10, 4, 10, 10, 10)); // cube
  fns.add(new supershape(40, 6, 5, 10, 10, 4, 10, 10, 10)); // star
  fns.add(new supershape(40, 3, 1.5f, 12, 3, 0, 3, 0, 0)); // heart 
  fns.add(new supershell(20, 0, 10, 0, 0, 0, 10, 0, 0, 2, 1, 1, 5));  // cork screw
  fns.add(new supershell(20, 10, 3, 0, 3, 4, 10, 10, 10, 0.6f, 0.7f, 2.5f, 6)); // flower shell    
  fns.add(new superdonut(20, 10, 10, 10, 10, 10, 10, 10, 10, 2, 0)); // star donut
  fns.add(new superdonut(20, 0, 10, 10, 10, 5, 6, 12, 12,  3, 0.2f)); // umbilic donut
  fns.add(new superduper(20, 0, 10, 0, 0, 6, 10, 6, 10, 3, 0, 0, 0, 4, 0.5f, 0.25f));  // moebius donut 
  fns.add(new superduper(20, 0, 11, 0, 0, 7, 10, 15, 10, 4, 0, 0, 0, 5, 0.3f, 2.2f));  // superduper meobius
 
  fn = fns.next();
  updateMesh();
}

public void draw() {
  interact();
  if (ic0 > ic1) redrawImage();
  image(g3d, 0, 0); 
  drawDisplay();
}

public void redrawImage() {
  g3d.beginDraw();
  beginOutput(g3d);
  g3d.background(0xff666699);
  if(light) {
    float al = 180, dl = 80;
    g3d.ambientLight(al,al,al);
    g3d.directionalLight(dl,dl,dl,1,1,0);
    g3d.directionalLight(dl,dl,dl,-1,1,0);
  };
  g3d.translate(width/2, height/2);
  g3d.translate(moveX, moveY);
  g3d.rotateX(rotX); g3d.rotateY(rotY); g3d.rotateZ(rotZ); 
  g3d.scale(zoom);
  render(m, g3d);
  endOutput(g3d);
  g3d.endDraw();
  ic1=ic0;
}

public void updateImage() {
  ic0++; 
}

public void updateResolution() { 
  if (mode > LORES && !mousePressed) {
    if(mc0 > mc1) mHires = mesh(fn, yres(hiRes), hiRes);
    m = mHires; mc1 = mc0;
  } else {
    m = mesh(fn, yres(loRes), loRes);
  } 
  updateImage();
}

public void updateMesh() {
   int res = (mode > LORES && !mousePressed) ? hiRes : loRes;
   m = mesh(fn, yres(res), res ); mc0++;
   updateImage();
}

public float[][][] mesh(shapeFn fn, int imax, int jmax) { 
 float[][][] m = new float[imax+1][jmax+1][3];
 for(int i=0; i<=imax; i++) {
    for(int j=0; j<=jmax; j++) {
      float u = map(i, 0, imax, 0, 1);
      float v = map(j, 0, jmax, 0, 1);
      m[i][j] = fn.eval(u,v);   
    } 
  }   
  return m;
}

public void render(float[][][] mesh, PGraphics g) {
  int imax = mesh.length;
  int jmax = mesh[0].length;
  if (grid) g.stroke(255,255,255,50); else g.noStroke();  
  for(int i=0; i<imax-1; i++) {
    float p[];
    if (faces) g.fill(colors ? Color.HSBtoRGB(PApplet.parseFloat(i)/imax, 0.5f, 1.0f) : 255); else g.noFill();    
    g.beginShape(QUAD_STRIP);  
    for(int j=0; j<jmax; j++) {
       p = m[i][j]; g.vertex(p[0],p[1],p[2]);
       p = m[i+1][j]; g.vertex(p[0],p[1],p[2]);
    }
    g.endShape();
  }
}

public int yres(int res) {
  return  PApplet.parseInt(fn.getRatio() * res);
}

/// DISPLAY PANE ///

boolean xchange = true, help = true, info = true, params = true;
int fontSize = 12, cols;
float cWidth = 100, blendSpeed = .1f;
String[] infoStyle = {"",":  "}, helpStyle = {"[ "," ] "};

float hHelp, hInfo, tableTop, yInfo, yHelp;
String[] cellStyle;

public void drawDisplay() {
  float t;
  // info bar
  t = (info && xchange)  ? hInfo : (info && !xchange ? -hInfo : 0);
  yInfo = lerp(yInfo,t,blendSpeed) ;
  tableTop = yInfo + height; drawInfo(); 
  hInfo = tableTop-yInfo-height; 
  tableTop = yInfo - hInfo; drawInfo();
  // help bar
  t = (help && !xchange) ? hHelp : (help && xchange ? -hHelp : 0);
  yHelp = lerp(yHelp,t,blendSpeed);
  tableTop = yHelp + height; drawHelp();
  hHelp = tableTop-yHelp-height; 
  tableTop = yHelp - hHelp;  drawHelp(); 
}

public void drawHelp() {
  cols = 4; cellStyle = helpStyle;
  drawTable("display", new String[][] {{"h", "help"}, {"i", "info"}, {"p", "params"}, {"x", "xchange"}});
  drawTable("render", new String[][] {{"m", "mode"}, {"c", "color"}, {"l", "light"}, {"g", "grid"}});
  drawTable("shape", new String[][] {{"space",  "next"}, {"u", "undo"}, {"o", "output"}});  
  int p =  fn.labels.length; 
  String[][] pt = new String[p][];
  for(int i=0; i< p; i++) pt[i] = new String[] {str(paramKeys.charAt(i)), fn.labels[i] };
  drawTable("params", pt);  
  String[] speed = {"superfast", "fast", "slow", "superslow"};
  String[][] mt = navigationMode ? 
    new String[][] {{"left", "tumble"}, {"middle", "move"}, {"right", "rotate & zoom"}} :
    new String[][] {{"left", speed[mousePrecision[0]]}, {"middle", speed[mousePrecision[1]]}, {"right", speed[mousePrecision[2]]}};
  drawTable("mouse buttons", mt);  
}

public void drawInfo() {
  cellStyle = infoStyle;
  if(params) {
    cols = 4; 
    int p = fn.labels.length;
    String[][] pt = new String[p][];
    String name = fn.getName();
    for(int i=0; i< p; i++) 
      pt[i] = new String[] {fn.labels[i], str(fn.r[i])};
    drawTable(name + " params", pt);
  }
  else {
    String[] res = {"lores", "dynamic", "hires"};
    int ures = mode > 0 ? hiRes : loRes;
    int vres = PApplet.parseInt(ures * fn.getRatio());
    cols = 3; drawTable("render params", new String[][] {
      {"mode",res[mode]}, {"u", str(ures) }, {"v", str(vres)}, 
      {"color", colors ? "on" : "off" },  {"light", light ? "on" : "off"}, {"grid", grid ? "on" :"off"}
    });
  }
}

public void drawTable(String headline, String[][] t) {
  float lh = fontSize + 2, bx = 6, by = 3, ts = 1;
  float ty, tw = width - 2 * by;
  float th = (1 + ceil(PApplet.parseFloat(t.length) / cols)) * lh + 4*by ;
  ty = tableTop; tableTop += th + ts;
  noStroke(); fill(255,30); rect(0, ty, width, th);
  pushMatrix(); 
  translate(bx, ty + by + fontSize);
  fill(255); textFont(bfont,fontSize); text(headline,0,0); 
  translate(0, lh+by);
  for(int i=0; i<t.length; i++) 
    drawCell(t[i],  min(cWidth,width/cols) * (i%cols), i/cols * lh);
  popMatrix();    
}

public void drawCell(String[] entry, float x, float y) {
  PFont[] f = {font, bfont, font};
  String[] s = {cellStyle[0], entry[0], cellStyle[1] + entry[1]};
  float w, x1 = x;
  for(int i=0; i<3; i++) {
    textFont(f[i], fontSize); w=textWidth(s[i]); text(s[i], x1, y); x1+=w;
  } 
}

/// INTERACTION ///

boolean navigationMode = true;
int precision = mousePrecision[0];
int paramKey=0;
String paramKeys = "1234qwerasdf789";

// FRAME-BASED INTERACTION 

public void interact() {    
  if( mousePressed && !navigationMode) {
    fn.modify(paramKey, mouseX-pmouseX-mouseY+pmouseY);
    updateMesh();
  } 
}


// EVENT-BASED INTERACTION 

public void keyPressed() {
  if (keyCode == 112) key='h'; // F1
  switch(key) {
    case ' ': fn = fns.next(); updateMesh(); break;
    case 'u': fn.reset(); updateMesh(); break;
    case 'm': mode = (mode+1) % 3; updateResolution(); break; 
    case 'g': grid = !grid; faces = !faces; updateImage(); break;
    case 'c': colors = !colors; updateImage();  break;
    case 'l': light = !light;  updateImage(); break;
    case 'o': output = true; updateImage(); break;
    case 'x': xchange =! xchange; break;
    case 'h': help = !help; break;    
    case 'i': info = !info; break;
    case 'p': params = !params; break;
  } 
  if(paramKey()) {
    navigationMode = false; 
    paramKey = paramKeys.indexOf(key);
  }
}

public boolean paramKey() {
   return paramKeys.substring(0, fn.r.length).indexOf(key) != -1;
}

public void mousePressed() {
  precision = mousePrecision[mouseEvent.getButton()-1];
  if(mode==MIXRES) updateResolution();
}

public void mouseReleased() {
  precision = mousePrecision[0];
  if(mode==MIXRES) updateResolution();
}

public void keyReleased() {
  if(paramKey()) navigationMode = true;
}

public void mouseDragged() {
  if (navigationMode) {
    if (mouseButton == LEFT) {
      rotX -= PApplet.parseFloat(mouseY-pmouseY) * 4/ height;
      rotY += PApplet.parseFloat(mouseX-pmouseX) * 4/ width;
      rotX = constrain(rotX, -HALF_PI, HALF_PI);
    }
    if (mouseButton == RIGHT) {
      zoom -= PApplet.parseFloat(mouseY-pmouseY) * 4/ height;
      zoom = constrain(zoom, minZoom, maxZoom);
      rotZ += ( height/2+moveY-mouseY >0 ? 1 : -1) * PApplet.parseFloat(mouseX-pmouseX) * 4/ width;
    }
    if (mouseButton == CENTER) {
      moveY += PApplet.parseFloat(mouseY-pmouseY) ;
      moveX += PApplet.parseFloat(mouseX-pmouseX) ;
    }
    updateImage();
  }
}


/// OUTPUT IMAGE ///




PGraphics og;

public void beginOutput(PGraphics g) {
  if (!output) return;
  output = false;
  String writer = null;
  String filename = selectOutput("Output "+fn.getName());
  if(filename == null) return;
  String ext = filename.substring(filename.lastIndexOf('.') + 1, filename.length()).toLowerCase();
  if (ext.equals("pdf")) writer = PDF; 
  if (ext.equals("dxf")) writer = DXF;
  if (writer == null) {
    g.format = RGB; // fix jpg transparency bug in processing
    g.save(filename);
    return; 
  }
  output = true;   
  og = createGraphics(width, height, writer, filename);
  g.hint(ENABLE_DEPTH_SORT);
  g.beginRaw(og);
}

public void endOutput(PGraphics g) {
  if (!output) return;
  g.endRaw();
  g.hint(DISABLE_DEPTH_SORT);   
  output = false;
}

/// PARAMERIC SHAPE ///

abstract class shapeFn {
  float[] r, rbackup, rmax;
  int[] p;
  int min=0, max=100, maxp = 3;
  String[] labels = {};
  float r0, resRatio = 1;
  shapeFn(float _r0, float[] _r, String[] _labels) {
    r0 = _r0; labels = _labels; r = _r;
    int n = r.length;
    rmax = new float[n]; p = new int[n];
    for (int i=0; i<n; i++) {rmax[i] = max; p[i] = maxp; }
    backup();
  }
  
  public abstract float[] eval( float u, float v);
  
  public void modify(int i, float delta) {
    if(i<r.length) {
      int f = min(precision, p[i]);
      r[i] = round(r[i] + pow(10,-precision) * delta, f);
      limit(i);
    }
  }
  public void limit(int i) {
    r[i] = constrain(r[i], 0, min(rmax[i],max));
  }
  public void backup() {
    rbackup = new float[r.length]; 
    arrayCopy(r, rbackup);
  }
  public void reset() {
    arrayCopy(rbackup, r);
  } 
  public float getRatio() { 
    return resRatio; 
  }
  public String getName() {
     return split(getClass().getName(),"$")[1];
  }
}

public float round(float n, int d) { return round(n*pow(10,d))/pow(10,d); }

/// SHAPE JUKEBOX ///
  
class fnCycle extends ArrayList {
  int current = 0;
  public shapeFn next() {
    shapeFn r = (shapeFn) get(current);
    current = (current + 1) % size();
    return r;
  }
}


/// SUPERSHAPES ///

class supershape extends shapeFn {
  supershape(float zoom, float m1, float n11, float n12, float n13, float m2, float n21, float n22, float n23) {
    super( zoom, 
      new float[] {m1, n11, n12, n13, m2, n21, n22, n23},
      new String[] {"m1", "n11", "n12", "n13", "m2", "n21", "n22", "n23"}
    );
  }
  public float[] eval(float u, float v)  {
    return superduperformula(r0, u, v, 1, 1, 0, r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], 0, 0, 0, 0);
  } 
}

class supershell extends shapeFn {
  supershell(float zoom, float m1, float n11, float n12, float n13, float m2, float n21, float n22, float n23, float t, float d1, float d2, float c) {
     super( zoom,
       new float[] {m1, n11, n12, n13, m2, n21, n22, n23, t, d1, d2, c},
       new String[] {"m1", "n11", "n12", "n13", "m2", "n21", "n22", "n23", "t", "d1", "d2", "c"}
     );
     rmax[11] = 10;
  } 
  public float[] eval(float u, float v)  {
    return superduperformula(r0, u, v, r[11], 1, 0, r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], 0, r[8], r[9], r[10]);
  }
  public float getRatio() { 
    return r[11]; 
  }
}

class superdonut extends shapeFn {
  superdonut(float zoom, float m1, float n11, float n12, float n13, float m2, float n21, float n22, float n23, float t, float c) {
    super( zoom,
      new float[] {m1, n11, n12, n13, m2, n21, n22, n23, t, c},
      new String[] {"m1", "n11", "n12", "n13", "m2", "n21", "n22", "n23", "t", "c"}
    );
    rmax[9] = 10;
  } 
  public float[] eval(float u, float v)  {
    return superduperformula(r0, u, v, 1, 2, r[9], r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], 0, 0, 0);
  }
  public float getRatio() { 
    return r[8]; 
  }   
}

class superduper extends shapeFn {
  superduper(float zoom, float m1, float n11, float n12, float n13, float m2, float n21, float n22, float n23, float t1, float t2, float d1, float d2, float c1, float c2, float c3) {
    super(zoom,
      new float[] {m1, n11, n12, n13, m2, n21, n22, n23, t1, t2, d1, d2, c1, c2, c3},
      new String[] {"m1", "n11", "n12", "n13", "m2", "n21", "n22", "n23", "t1", "t2", "d1", "d2", "c1", "c2", "c3"}
    );
   rmax[12] = 10; rmax[13] = 2; rmax[14] = 10;  
   
  } 
  public float[] eval(float u, float v)  {
    return superduperformula(r0, u, v, r[12], r[13], r[14], r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11]);
  }
  public float getRatio() { 
    return r[12] * sqrt(1 + r[14]); 
  }   
}
  

/// HELPER FUNCTIONS ///

public float superformula(float phi, float a, float b, float m, float n1, float n2, float n3) {
   return pow(pow(abs(cos(m * phi / 4) / a), n2) + pow(abs(sin(m * phi / 4) / b),n3), - 1/n1);
}

public float[] superduperformula(
  float r0, float u, float v, 
  float c1, float c2, float c3, 
  float m1, float n11, float n12, float n13, 
  float m2, float n21, float n22, float n23, 
  float t1, float t2, float d1, float d2
  ) {
    float t2c = r0 * pow(c2, d2) * t2 * c1 / 2;
    t2 =  t2 * c1 * u;
    d1 = pow(u * c1, d1); 
    d2 = pow(u * c2, d2);
    u = lerp(-PI , PI, u) * c1;
    v = lerp(-HALF_PI, HALF_PI, v) * c2;
    float v2 = v + c3 * u;
    float r1 = superformula(u, 1, 1, m1, n11, n12, n13);
    float r2 = superformula(v, 1, 1, m2, n21, n22, n23);
    float x = r0 * r1 * (t1 + d1 * r2 * cos(v2)) * sin(u);
    float y = r0 * r1 * (t1 + d1 * r2 * cos(v2)) * cos(u);
    float z = r0 * d2 * (r2 * sin(v2)  - t2) + t2c;
    return gPoint(x,y,z); 
  }
  
// limit coords to prevent processing bug
public float[] gPoint(float x, float y, float z) { 
  float pmax=MAX_INT;
  return new float[] {constrain(x, -pmax, pmax), constrain(y, -pmax, pmax), constrain(z, -pmax, pmax)};
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SuperDuperShapes_WithoutSurfaceLib" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
