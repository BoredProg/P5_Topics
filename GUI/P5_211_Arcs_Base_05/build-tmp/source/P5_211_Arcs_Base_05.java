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

public class P5_211_Arcs_Base_05 extends PApplet {

/*
DRAWING ARCS
Jeff Thompson
March 2012
Uses the 'arc' command to randomly draw in different directions.
www.jeffreythompson.org
*/

public void setup() {

  // basic setup stuff
  size(900, 400);
  background(150);
  noFill();
  smooth();

  // draw a center line
  stroke(255, 0, 0);
  line(0, height/2, width, height/2);

  // draw 10 random arcs
  for (int i=0; i<10; i++) {

    // create L and R sides for arc
    int L = PApplet.parseInt(random(0, width));    // left side
    int R = PApplet.parseInt(random(0, width));    // right side
    int diff = abs(R - L);            // diff b/w the two - the width of the arc
    float arcHeight = map(diff, 0, width, 0, height/2);    // scale height based on width

    // if we're drawing from L to R...
    if (L < R) {
      stroke(0);
      // x/y center of arc, width and height, start/stop angle**
      arc(L + diff/2, height/2, diff/2, arcHeight, PI, TWO_PI);
      
      // ** the angles are in polar coords from 0 - TWO_PI; here PI means start
      //    at the center-L and draw around to center-R (same as 0, but this ensures
      //    the correct direction for the line

      // draw a dot in the center
      stroke(255, 0, 0);
      strokeWeight(5);
      point(L + diff/2, height/2);
      strokeWeight(1);
    }
    
    // if in other direction
    else {
      stroke(0);
      // draw the line upside-down from 0-PI
      arc(L - diff/2, height/2, diff/2, arcHeight, 0, PI);

      stroke(255, 0, 0);
      strokeWeight(5);
      point(L - diff/2, height/2);
      strokeWeight(1);
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Arcs_Base_05" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
