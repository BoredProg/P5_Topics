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

public class rosa_lupa_giro extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/17416*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
PImage prova;
PImage aux01;

public void setup() {
  size(410, 308); 
  prova = loadImage("rosa.jpg");
 
 

 
 
// loadPixels();
 }



public void draw( ) {
    
 image(prova,0,0);
 translate(350,10);
rotate(PI/2);
 aux01=prova.get(mouseX,mouseY,70,70);
 image(aux01,mouseX,mouseY,100,100);




}

public void mousePressed( ) {
    
}
public void mouseReleased( ) {
    
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "rosa_lupa_giro" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
