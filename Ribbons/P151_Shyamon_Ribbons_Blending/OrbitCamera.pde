import damkjer.ocd.*;
import java.awt.event.*;

public class OrbitCamera
{
  Camera cam;
  
  float tgtX, tgtY, tgtZ;
  boolean oldMouseState = false;
  float damp = 0.3;
  float rotIntens = 0.8;
  float dollyIntens = 10.0;
  float cx, cy, cz, mx, my, mz;
  
  public OrbitCamera( PApplet p, float camX, float camY, float camZ )
  {
    tgtX = tgtY = tgtZ = 0.0;
    cam = new Camera(p, camX, camY, camZ, tgtX, tgtY, tgtZ, 0.1, 3000);
    
    // add mouse wheel event
    addMouseWheelListener( new MouseWheelListener(){
      public void mouseWheelMoved(MouseWheelEvent mwe) {
        mouseWheel(mwe.getWheelRotation());
      }});
  }
  
  public OrbitCamera( PApplet p, float camX, float camY, float camZ, float targetX, float targetY, float targetZ )
  {
    cam = new Camera(p, camX, camY, camZ, targetX, targetY, targetZ, 0.1, 2000);
    
    tgtX = targetX;
    tgtY = targetY;
    tgtZ = targetZ;
    
    // add mouse wheel event
    addMouseWheelListener( new MouseWheelListener(){
      public void mouseWheelMoved(MouseWheelEvent mwe) {
        mouseWheel(mwe.getWheelRotation());
      }});
  }
  
  public void feed()
  {
    doOrbit();
    cam.feed();
  }
  
  private void doOrbit()
  {
    boolean onClick = !oldMouseState & mousePressed;
    
    if( !onClick ) {
      cx = mousePressed ? mouseX : cx;
      cy = mousePressed ? mouseY : cy;
    
      float dx = (cx - mx) * damp;
      mx += dx;
    
      float dy = (cy - my) * damp;
      my += dy;
      
      cam.tumble( -radians(dx*rotIntens), -radians(dy*rotIntens) );
    }
    else {
      mx = mouseX;
      my = mouseY;
    }
    
    oldMouseState = mousePressed;
  }
  
  private void mouseWheel(int delta) 
  {
    cam.dolly( delta * dollyIntens * damp );
    cam.aim(tgtX, tgtY, tgtZ);
  }
}
