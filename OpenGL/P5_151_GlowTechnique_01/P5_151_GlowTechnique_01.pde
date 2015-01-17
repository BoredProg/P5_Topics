import processing.opengl.*;


//  bloom code found at http://everyware.cc/files/codes/Bloom/ by EveryWare creative computing group 
//  modified and optimized by Flux http://www.ghost-hack.com 
 
 
 
import processing.opengl.*; 
import javax.media.opengl.*;   
 
GL gl; 
 
//  offscreen buffer to draw the bloom onto 
PGraphics pg; 
 
//  blur passes, the higher the number the more blurry the bloom becomes 
int pass = 6; 
 
//  the lower the number the higher quality the bloom (less flickering) 
int bufferScale = 6; 
 
void setup() { 
  size(640, 480, OPENGL); 
  hint(ENABLE_OPENGL_4X_SMOOTH);
  gl=((PGraphicsOpenGL)g).gl;     
  pg = createGraphics(width/bufferScale, height/bufferScale, P3D); 
} 
 
void draw() { 
 
  //  draw renders normally 
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA); 
  background(0);   
  stroke(255); 
  fill(255); 
  rectMode(CENTER);   
  ellipse(mouseX, mouseY, 50,50); 
 
  //  dump contents into pg's pixel buffer 
  pg.beginDraw();   
  pg.copy(g,0, 0, width, height, 0, 0, pg.width, pg.height); 
  pg.endDraw();   
 
  //  apply brightness pass 
  brightPass(pg); 
 
  //  blur the brightness pass 
  for(int i=0; i<pass; i++) 
    blur(pg); 
 
  //  display the brightpass as an additive blend 
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);   
  pushMatrix();   
  image(pg, 0, 0, width, height);   
  popMatrix(); 
} 
 
 
 
 
//  brightpass utils 
 
void brightPass(PGraphics buffer) { 
  for(int i=0; i<buffer.pixels.length; i++) 
    buffer.pixels[i] = red(buffer.pixels[i])>150 ? 255:0; 
} 
 
float[][] kernel = {   
  { 
    1.0, 1.0, 1.0, 1.0, 1.0   } 
  ,   
  { 
    1.0, 1.0, 1.0, 1.0, 1.0   }   
  , 
  { 
    1.0, 1.0, 1.0, 1.0, 1.0   }   
  , 
  { 
    1.0, 1.0, 1.0, 1.0, 1.0   }   
  , 
  { 
    1.0, 1.0, 1.0, 1.0, 1.0   } 
}; 
 
void blur(PGraphics buffer) { 
  int n2 = 5/2; 
  int m2 = 5/2; 
  int[][] output = new int[buffer.width][buffer.height]; 
 
 
  // Convolve the image 
  for(int y=0; y<buffer.height; y++) { 
    for(int x=0; x<buffer.width; x++) { 
 float sum = 0; 
 for(int k=-n2; k<=n2; k++) { 
   for(int j=-m2; j<=m2; j++) { 
     // Reflect x-j to not exceed array boundary 
     int xp = x-j; 
     int yp = y-k; 
 
     if (xp < 0) { 
  continue; 
     }  
     else if (x-j >= buffer.width) { 
  continue; 
     } 
     // Reflect y-k to not exceed array boundary 
     if (yp < 0) { 
  continue;       
     }  
     else if (yp >= buffer.height) { 
  continue; 
     }      
     //  avoid using get for a pinch of extra speed 
     sum = sum + kernel[j+m2][k+n2]/25.0 * brightness(buffer.pixels[yp*buffer.width + xp]);  
     //     sum = sum + kernel[j+m2][k+n2]/25.0 * brightness(buffer.get(xp, yp));   
   } 
 } 
 output[x][y] = int(sum);   
    } 
  } 
 
  for(int i=0; i<buffer.pixels.length; i++) 
    buffer.pixels[i] = color(output[i%buffer.width][i/buffer.width]); 
 
}  
 
