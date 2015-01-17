import javax.media.opengl.*; 
import com.sun.opengl.util.FPSAnimator;  
 
GLCanvas canvas; 
 
void setup() { 
  size(400, 300); 
   
  canvas = new GLCanvas(); 
  canvas.setSize(200, 100); 
  canvas.addGLEventListener(new GLRenderer()); 
  FPSAnimator animator = new FPSAnimator(canvas, 60); 
  animator.start(); 
   
  add(canvas); 
   
} 
 
void draw() { 
  background(50); 
  fill(255); 
  rect(10,10,frameCount%100,10); 
} 
 
class GLRenderer implements GLEventListener { 
  GL gl; 
 
  public void init(GLAutoDrawable drawable) { 
    this.gl = drawable.getGL(); 
    gl.glClearColor(1, 0, 0, 0);    
    canvas.setLocation(100, 80);     
  } 
 
  public void display(GLAutoDrawable drawable) { 
    gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT ); 
    gl.glColor3f(1, 1, 1);  
    gl.glRectf(-0.8, 0.8, frameCount%100/100f -0.8, 0.7); 
  } 
   
  public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height) { 
  } 
 
  public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged) { 
  } 
} 
 
