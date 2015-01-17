import processing.opengl.*; // commented out for online use only

// by extrapixel 2007
// started by MisterCrow
// -> http://processing.org/discourse/yabb_beta/YaBB.cgi?board=Syntax;action=display;num=1193175897;start=1#1


// controls:
// spacebar: turn mouse on/off
// o: turn obstacles on/off
// b: turn walls on/off

// ************************* DRAWING VARIABLES **************************  
final int CAVE_WIDTH  = 1500;
final int CAVE_HEIGHT =  1500;
final int CAVE_DEPTH = 1500;
final int FRAME_RATE = 100;

final int NUM_BOIDS              = 200;
final int NUM_OBSTACLES          = 1000;
final int NUM_PREDATORS          = 75;
final int CENTER_PULL_FACTOR     = 1200;
final int TARGET_PULL_FACTOR     = 800;
final int FOOD_PULL_FACTOR       = 100;
final int OBSTACLE_DISTANCE      = 30;
final int PREDATOR_DISTANCE      = 18;
final int FOOD_DISTANCE          = 20;
final float BOUNCE_ABSORPTION    = .25;
final int VELOCITY_PULL_FACTOR   = 100;
final int MIN_DISTANCE = 18;
final float VELOCITY_LIMITER = 6.0  *100000;
final float MAX_DISTANCE = sqrt(CAVE_WIDTH*CAVE_WIDTH+CAVE_HEIGHT*CAVE_HEIGHT);

// new damping variables.
float r1Damping = 1.0;
float r2Damping = .2;
float r3Damping = 1.0;
float r4Damping = 0.0;
float r5Damping = 1.0;
float r6Damping = 1.0;

float xRot = 0;
float yRot = 0;

boolean showObstacles = true;
boolean bounceFromWalls = true;

color backColor = color(0);

PImage _boidImage;


PFont font;


Boid[] flock = new Boid[NUM_BOIDS];
Obstacle[] obstacles = new Obstacle[NUM_OBSTACLES+NUM_PREDATORS];
ArrayList foods = new ArrayList();

PGraphicsOpenGL pgl;



void setup()  
{
   //size(500, 500);  // for the browser only... take the other one for offline use
   size(1280, 920, OPENGL); 
   //  background(backColor);
   rectMode(CENTER);
   ellipseMode(CENTER);
   sphereDetail(2);

   pgl           = (PGraphicsOpenGL) g;


   _boidImage = loadImage("emitter.png");

   font = createFont("Courier", 12);

   for(int i=0; i<NUM_BOIDS; i++)
   {
      flock[i] = new Boid();


   } // end for

   for (int i=0; i<NUM_OBSTACLES; i++) {
      obstacles[i] = new Obstacle();
   }

   for (int i=0; i<NUM_PREDATORS; i++) {
      obstacles[NUM_OBSTACLES+i] = new Predator();
   }


   frameRate(FRAME_RATE);
   hint(ENABLE_OPENGL_4X_SMOOTH) ;
   //hint(ENABLE_OPENGL_2X_SMOOTH) ;
   // hint(ENABLE_DEPTH_SORT);
}

float counter=0;

   color from,to, bg;

void draw()  
{

   println((int)flock[0].xpos + ";" +  (int)flock[0].zpos + ";" +  (int)flock[0].zpos);
   background((abs(flock[0].xpos)/1500)*255,(abs(flock[0].zpos)/1500)*255,250);
   //colorMode(HSB); 
   
   /*
   if (counter++ >= 100)
   {
      randomSeed(frameCount);
      from = color((int)random(255),(int)random(100,255),(int)random(255));
      counter = 0;
   }
   else
   {
      //color from    = color(backColor);     
      to      = color(backColor);
      bg       = lerpColor(from, to, counter * 0.05);
      //bg = (int)(noise(from)*1.05);

      background(bg);
      backColor = bg;
      //background(backColor  ,255,200+ (millis()/1000));
   }
   
   //background((millis()/1000)*10  ,255,noise(155,220)*1.5);
   
   //colorMode(RGB);

   //println(sin(frameCount));
   println(counter);
   */

   hint(DISABLE_DEPTH_TEST);
   /*
  beginShape();
    fill(30,30,80);
    vertex(0,0);
    vertex(width, 0);
    fill(0,0,20);
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    
    fill(150);
    */
   textFont(font);
   text("FPS: " + int(frameRate), 10, height-12);

   hint(DISABLE_DEPTH_TEST);
   lights();



   translate(width/2,height/2,-300);
   //rotateY(xRot);
   //rotateX(yRot);

   rotateX(TWO_PI/height*mouseY);
   rotateY(TWO_PI/width*mouseX);

   translate(-CAVE_WIDTH/2,-CAVE_HEIGHT/2,-CAVE_DEPTH/2);


   stroke(200,100);
   strokeWeight(1);
   /*
  line(0,0,0,0,0,CAVE_DEPTH);
    line(CAVE_WIDTH, 0, 0, CAVE_WIDTH, 0, CAVE_DEPTH);
    line(CAVE_WIDTH, CAVE_HEIGHT, 0, CAVE_WIDTH, CAVE_HEIGHT, CAVE_DEPTH);
    line(0, CAVE_HEIGHT, 0, 0, CAVE_HEIGHT, CAVE_DEPTH);
    
    line(0,0,0, CAVE_WIDTH, 0,0);
    line(0, CAVE_HEIGHT, 0, CAVE_WIDTH, CAVE_HEIGHT, 0);
    line(0,0,CAVE_DEPTH, CAVE_WIDTH, 0,CAVE_DEPTH);
    line(0, CAVE_HEIGHT, CAVE_DEPTH, CAVE_WIDTH, CAVE_HEIGHT, CAVE_DEPTH);
    
    line(0,0,0, 0, CAVE_HEIGHT, 0);
    line(CAVE_WIDTH,0,0, CAVE_WIDTH, CAVE_HEIGHT,0); 
    line(0,0, CAVE_DEPTH,  0, CAVE_HEIGHT,  CAVE_DEPTH);
    line(CAVE_WIDTH,0, CAVE_DEPTH, CAVE_WIDTH, CAVE_HEIGHT, CAVE_DEPTH); 
    */
   
   //beginCamera();
   //camera(flock[0].xpos, flock[0].zpos, flock[0].zpos, CAVE_HEIGHT/2,CAVE_HEIGHT/2,CAVE_HEIGHT/2, 0,noise(-1.0,1.0),noise(-1.0,1.0));
   camera(flock[0].xpos, flock[0].zpos, flock[0].zpos, 
   flock[10].xpos, flock[10].ypos, flock[10].zpos, 
   1,1,1);
   //endCamera();
   
   //pointLight(50, 55, 45, flock[30].xpos, flock[30].zpos, flock[30].zpos);   
   //pointLight(noise(random(255))*255, noise(flock[0].xpos)*255, 255, flock[0].xpos, flock[0].zpos, flock[0].zpos);


   for (int i=0; i<NUM_BOIDS; ++i)
   {
      //flock[i].updateBoid();   
      flock[i].drawMe();
   } // end for
   
   

   if (showObstacles) {
      for (int i=0; i<obstacles.length; i++) {
         obstacles[i].draw(); 
      }
   }

   for (int i=0; i< foods.size(); i++) {
      ((Food)foods.get(i)).draw();
   }

}


void mousePressed() {

   foods.add(new Food(int(random(0,CAVE_WIDTH)), int(random(0,CAVE_HEIGHT)), int(random(0,CAVE_DEPTH))));

}

void keyPressed() {

   // switch mouse attraction on/off
   /*
  if (key== ' ' ) {
    if (r4Damping==0.0) {
    println("mouse on");
    r4Damping = 1.0;
    } 
    else {
    println("mouse off");
    r4Damping = 0.0; 
    }
    } 
    else */   if (key == 'o') {
      if (!showObstacles) {
         println("obstacles on");
         showObstacles = true;
         r5Damping = 1.0;
      } 
      else {
         println("obstacles off");
         showObstacles = false;
         r5Damping = 0.0; 
      }
   } /*
  else if (key == 'b') {
    if (!bounceFromWalls) {
    println("walls on");
    bounceFromWalls = true;
    } 
    else {
    println("walls off");
    bounceFromWalls = false;
    }
    } */
   else if (keyCode == UP) {
      yRot += .1;
   }  
   else if (keyCode == DOWN) {
      yRot -=.1;
   }
   else if (keyCode == RIGHT) {
      xRot += .1;
   }    
   else if (key == 'f')    // new food at camera-holding boid position..
   {
      foods.add(new Food((int)flock[0].xpos, (int)flock[0].zpos, (int)flock[0].zpos));
      ;
   }  

   else if (key == 'r')   // new food at random position..
   {
      foods.add(new Food(int(random(0,CAVE_WIDTH)), int(random(0,CAVE_HEIGHT)), int(random(0,CAVE_DEPTH))));  
   }  

   else if (key == 's') {
      saveFrame("BoidCamArty-####.tif");      
   }  


}
