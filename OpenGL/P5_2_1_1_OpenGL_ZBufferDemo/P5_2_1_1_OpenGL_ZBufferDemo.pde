import javax.media.opengl.*; // ç›´æŽ¥OpenGLã®é–¢æ•°ã‚’åˆ©ç”¨ã™ã‚‹ãŸã‚
import java.nio.*;

PJOGL pgl;
GL2 gl;

boolean isZbuffer = true;
float theta = 0.;

void setup() 
{
  size(800, 600, P3D); // OpenGLã‚’åˆ©ç”¨ã™ã‚‹å ´åˆã¯ï¼Œ3ç•ªç›®ã®å¼•æ•°ã« OPENGL ã‚’æŒ‡å®š
  PFont font = createFont("Arial", 16);
  textFont(font, 24);
}

void keyPressed(){
  switch(key){
    case 'z':
      isZbuffer = !isZbuffer;
      break;
  }
}

void draw() {
  background(255);
  //PGraphicsOpenGL pgl = (PGraphicsOpenGL)g;
  //GL gl;
   pgl = (PJOGL)beginPGL();
   gl = pgl.gl.getGL2();
  
  //gl = pgl.beginGL(); // OpenGLã®å‡¦ç†
    if(!isZbuffer) gl.glDisable(GL.GL_DEPTH_TEST); // Zbufferã®off
    gl.glColor4f(.7, .0, .0, .6);                  // è‰²ã®æŒ‡å®š
    gl.glTranslatef(width / 2, height / 2, 0);     // å¹³è¡Œç§»å‹•
    gl.glRotatef(-20, 1, 0, 0);                    // xè»¸å‘¨ã‚Šã®å›žè»¢
    gl.glRotatef(theta, 0, 1, 0);                  // yè»¸å‘¨ã‚Šã®å›žè»¢
    gl.glRectf(-200, -200, 200, 200);              // çŸ©å½¢ã®æç”»
    
    gl.glColor4f(.0, .7, .0, .8);
    gl.glRotatef(90, 0, 1, 0);
    gl.glRectf(-200, -200, 200, 200);
   endPGL();
  
  theta += 1;
  fill(0);
  text(isZbuffer ? "Zbuffer On" : "Zbuffer Off", 20, 30);
}

