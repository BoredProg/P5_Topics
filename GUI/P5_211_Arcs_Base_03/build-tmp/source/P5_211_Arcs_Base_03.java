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

public class P5_211_Arcs_Base_03 extends PApplet {

int[] c = {
  color(244,225,211), color(66,66,104), color(204,178,29), color(222,47,44),
  color(146,40,86), color(84,166,66), color(240,117,49), color(110,32,46)
};
 
int rings = 7;
int ringDensity = 4;
int number = 24;
 
public void setup() {
  size(width,height);
  strokeWeight(13);
  strokeCap(SQUARE);
  noFill();
  smooth();
}
 
public void draw() {
  background(c[0]);
  translate(width/2, height/2);
  for (int h=1; h<(ringDensity*2); h=h+2) {
    for (int i=h; i<(rings*10); i=i+10) {
      for (int j=1; j<number+1; j++) {
        stroke(randomColor(i,j));
        arc(0, 0, i*26, i*26, radians(j*(360/number)), radians((j+1)*(360/number)));
      }
    }
    rotate(radians(7.5f));
    for (int i=h+1; i<(rings*10); i=i+10) {
      for (int j=1; j<number+1; j++) {
        stroke(randomColor(i,j));
        arc(0, 0, i*26, i*26, radians(j*(360/number)), radians((j+1)*(360/number)));
      }
    }
  }
}
 
public int randomColor(float i, float j) {
  int colorSelect = PApplet.parseInt(7.5f*abs(sin(i*j*j*j)));
  return c[colorSelect];
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Arcs_Base_03" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
