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

public class DynamicTextures2D extends PApplet {


/*

 Dynamic Textures 2D by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating textured QUADS with dynamically generated texture coordinates.
 With the OpenGL renderer this can be done at interactive framerates.

 HORIZONTAL MOUSE MOVE = change the density of the grid

 Built with Processing 2.0b8 / 2.0b9 / 2.0 Final

*/

int DIM, NUMQUADS; // variables to hold the grid dimensions and total grid size
PImage img; // the image

public void setup() {
  img = loadImage("image.jpg"); // load the image (from the /data subdirectory)
  size(img.width*2, img.height, P2D); // set the width of the sketch to twice the image width
  textureMode(NORMAL); // use normalized (0 to 1) texture coordinates
  noStroke(); // turn off stroke (for the rest of the sketch)
  smooth(6); // set smooth level 6 (default is 2)
}

public void draw() {
  DIM = (int) map(mouseX, 0,width, 1, 40); // set DIM in the range from 1 to 40 according to mouseX
  NUMQUADS = DIM*DIM; // calculate the total number of cells in the grid
  beginShape(QUAD); // draw a Shape of QUADS
  texture(img); // use the image as a texture
  // draw all the QUADS in the grid...
  for (int i=0; i<NUMQUADS; i++) {
    // ...through a custom drawQuad method that takes as input parameters
    // the index for the position and the index for the texture coordinates
    // therefore: drawQuad(i, i); would look like the regular image
    // currently frameCount-based noise determines the index for the texture coordinates
    drawQuad(i, PApplet.parseInt(i+noise(i+frameCount*0.001f)*NUMQUADS)%NUMQUADS);
  }
  endShape(); // finalize the Shape
  image(img, width/2, 0); // display the regular image on the right side of the sketch
  frame.setTitle(PApplet.parseInt(frameRate) + " fps"); // the fps remains 60 even with dynamic texture changes and a high-density grid
}

public void drawQuad(int indexPos, int indexTex) {
  // calculate the position of the vertices
  float x1 = PApplet.parseFloat(indexPos%DIM)/DIM*width/2;
  float y1 = PApplet.parseFloat(indexPos/DIM)/DIM*height;
  float x2 = PApplet.parseFloat(indexPos%DIM+1)/DIM*width/2;
  float y2 = PApplet.parseFloat(indexPos/DIM+1)/DIM*height;

  // calculate the texture coordinates
  float x1Tex = PApplet.parseFloat(indexTex%DIM)/DIM;
  float y1Tex = PApplet.parseFloat(indexTex/DIM)/DIM;
  float x2Tex = PApplet.parseFloat(indexTex%DIM+1)/DIM;
  float y2Tex = PApplet.parseFloat(indexTex/DIM+1)/DIM;

  // use the above calculations for 4 vertex() calls
  vertex(x1, y1, x1Tex, y1Tex);
  vertex(x2, y1, x2Tex, y1Tex);
  vertex(x2, y2, x2Tex, y2Tex);
  vertex(x1, y2, x1Tex, y2Tex);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DynamicTextures2D" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
