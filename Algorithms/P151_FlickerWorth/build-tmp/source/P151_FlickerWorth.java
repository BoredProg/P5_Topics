import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P151_FlickerWorth extends PApplet {



float noiseVal;
float noiseScale = 0.005f;
float noiseCount = 0.0f;
float noiseSpeed = 0.05f;

float xCount, xSpeed;
float yCount, ySpeed;

float theta;
float angle;
float angleDelta;
float xv, yv;
float speed = 10;

boolean lines = false;
boolean _invertColors = false;

int noiseRes = 10;      // Seems to control the dark/light color settings (by the noise).

int xSize = 1000;
int ySize = 1000;

float _xMaxRandom = 500.0f;
float _xMinRandom = - _xMaxRandom;
float _yMaxRandom = _xMaxRandom;
float _yMinRandom = - _yMaxRandom;

/* Original
float randomx = xSize/2 + random(-200.0f, 200.0f);
float randomy = ySize/2 + random(-200.0f, 200.0f);
*/
float randomx = xSize/2 + random(_xMinRandom, _xMaxRandom);
float randomy = ySize/2 + random(_yMinRandom, _yMaxRandom);

Vehicle[][] vehicle;


int xTotal = PApplet.parseInt(xSize / noiseRes);
int yTotal = PApplet.parseInt(ySize / noiseRes);

PFont _font = createFont("Consolas",12);
int   _backgroundColor = 0;  

int _colorNormal;
int _colorInverted;

PImage _bgImage;


public void setup()

{
   /***********************************
   TODO :
   
      - Test it with a color Palette;
      - Write Params to Screen
      - Make Vehicles Threaded. (Runnable).
   ***********************************/
   
   //setRenderer(P3D);
   setRenderer(OPENGL);
   
   // just when bg = black;
   _invertColors = !_invertColors;
   
   _bgImage = loadImage("bg.jpg");
   image(_bgImage,0,0,xSize,ySize);
   
   ellipseMode(CENTER);
   colorMode(RGB, 360);  
   background(_backgroundColor);

   textFont(_font);
      
   initGraph();

}

public void setRenderer(String rendererName)
{
   if ( rendererName == P3D )
   {
      size(xSize,ySize,P3D);

   }
   else if ( rendererName == OPENGL )
   {
    // OpenGL Slower but antialiasing is better.
    size(xSize,ySize,OPENGL);
   
    hint(ENABLE_OPENGL_4X_SMOOTH);
    
   }

}


public void initGraph()
{
  
   noiseDetail((int)random(4.0f,8.0f), random(0.2f,0.8f));
   float noiseScale = random(0.001f, 0.03f);
   
   // Create Vehicles.
   vehicle = new Vehicle[yTotal][xTotal];
   for (int y=0; y<yTotal; y++)
   {
      for (int x=0; x<xTotal; x++)
      {
         vehicle[y][x] = new Vehicle(x, y);
      }
   }
}

public void keyPressed()
{
   if (key == ' ')
   {
      lines = !lines;
   }
   if (key == 'r')
   {
      image(_bgImage,0,0,xSize,ySize);
      initGraph();
   }
   if (key == 'p')
   {
      // Change the drawing Origin
      randomx = xSize/2 + random(_xMinRandom, _xMaxRandom);
      randomy = ySize/2 + random(_yMinRandom, _yMaxRandom);
   }
   
   if (key == 'n')
   {      
      initGraph();
   }
   if (key == 'i')
   {      
      _invertColors = !_invertColors;
   }
   if (key == 's')
   {      
      saveFrame("PocWorth-####.tiff");
        saveFrame("C:\\Documents and Settings\\SEB\\My Documents\\My Pictures\\@Production\\" +
                "PocWorthOpengl\\" + 
                "PocWorthOpenGl" + "-####.tiff");
   }
}

public void mousePressed()
{
     randomx = mouseX;
     randomy = mouseY;
     initGraph();
}

/*****************************************
* Drawing Routine
*****************************************/
public void draw() 
{
   
   /*
   pushMatrix();
   fill(255);
   textMode(SCREEN);
   text("FPS : " + (int)frameRate ,10,20); 
   popMatrix();
   */
   
   // Uncomment this line to get a Ribbon (when drawing black on white bg);
   //background(51);
   xSpeed = ((width/2) - mouseX)/10.0f;
   ySpeed = ((height/2) - mouseY)/10.0f;

   xCount += xSpeed;
   yCount += ySpeed;

   

   for(int y=0; y<=height; y++) {
      for(int x=0; x<=width; x++) {

         if (x%noiseRes == 0 && y%noiseRes == 0){
            noiseVal=noise((x - xCount)*noiseScale, (y - yCount)*noiseScale, noiseCount);
            float g = noiseVal*1400.0f;
            theta = (-(g * PI))/180.0f;
            xv = cos(theta) * speed;
            yv = sin(theta) * speed;
            
            // Draws the grid points and lines.
            if (lines)
            {
               // draws the grid point
               stroke(0, 10);
               
               line (x - (xv/4.0f), y - (yv/4.0f), x, y);
            }
            
            // To show the "grid" that the drawing is following :
            /*
            point(x - xv, y - yv);
            stroke(255,0,0, 25);
            line (x + (xv), y + (yv), x, y);
            */
         }
      }
      
   }

   noiseCount += noiseSpeed;
   for (int y=0; y<yTotal; y++){
      for (int x=0; x<xTotal; x++){
         vehicle[y][x].exist();
      }
   }
}







class Vehicle {
   float x;
   float y;

   float xv, yv;
   float xf, yf;

   float theta;
   float angle;
   float angleDelta;
   float speed = random(2.0f, 10.0f);

   Vehicle (int xSent, int ySent){
      x = randomx;
      y = randomy;
   }

   public void exist(){
      findVelocity();
      move();
      render();
   }

   public void findVelocity(){
      noiseVal=noise((x - xCount)*noiseScale, (y - yCount)*noiseScale, noiseCount);
      
      angle -= (angle - noiseVal*720.0f) * .4f;
      
      theta = (-(angle * PI))/180.0f;
      
      xv = cos(theta) * speed;
      yv = sin(theta) * speed;
   }

   public void move()
   {
      x -= xv;
      y -= yv;
     
     /* Uncomment this to continue the drawing on the opposite border.
    if (x < -50){
       x += width + 100;
       } else if (x > width + 50){
       x -= width + 100;
       }
       
       if (y < -50)
       {
          y += height + 100;
       } 
       else if (y > height + 50)
       {
          y -= height + 100;
       }
      */
   }

   public void render(){
      //stroke(0, 1);  
      if ( ! _invertColors )
         stroke(0,(angle - 180)/100.0f + 1);
      else
         stroke(360,(angle - 180)/100.0f + 5);
      
      //stroke(0,(angle - 180)/100.0f + 1);
      line(x,y, x+xv, y+yv);
   }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P151_FlickerWorth" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
