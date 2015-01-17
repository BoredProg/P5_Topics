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

public class P5_211_OrthogonalGridCellsFading extends PApplet {

float radius = 40;

float x, y;
float prevX, prevY;

Boolean fade = true;

Boolean saveOne = false;

public void setup()
{
    size( 450, 400 );
    background( 0 );
    stroke( 255 );
    
    x = width/2;
    y = height/2;
    
    prevX = x;
    prevY = y;

    stroke(255);
    strokeWeight( 2 );
    point( x, y );

}

public void draw()
{
    if (fade) {
        noStroke();
        fill( 0, 4 );
        rect( 0, 0, width, height );
    }
    
    float angle = (TWO_PI / 6) * floor( random( 6 ));
    x += cos( angle ) * radius;
    y += sin( angle ) * radius;
    
    if ( x < 0 || x > width ) {
        x = prevX;
        y = prevY;
    }
    
    if ( y < 0 || y > height) {
        x = prevX;
        y = prevY;
    }
    
    stroke( 255, 64 );
    strokeWeight( 1 );
    line( x, y, prevX, prevY );
    
    strokeWeight( 3 );
    point( x, y );
    
    prevX = x;
    prevY = y;
    
    if (saveOne) {
        saveFrame("images/triangle-grid-#####.png");
        saveOne = false;
    }
    
}

public void keyPressed()
{
    if (key == 'f') {
        fade = !fade;
    }
    
    if (key == 's') {
        saveOne = true;
    }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_OrthogonalGridCellsFading" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
