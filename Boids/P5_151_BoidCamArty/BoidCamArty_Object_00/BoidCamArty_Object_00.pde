import processing.opengl.*; // commented out for online use only


// controls:
// spacebar: turn mouse on/off
// o: turn obstacles on/off
// b: turn walls on/off

// ************************* DRAWING VARIABLES **************************  


final int FRAME_RATE = 500;

final int NUM_BOIDS              = 100;
final int NUM_OBSTACLES          = 5000;
final int NUM_PREDATORS          = 0;//10;//75;
final int CENTER_PULL_FACTOR     = 1200;
final int TARGET_PULL_FACTOR     = 800;
final int FOOD_PULL_FACTOR       = 100;
final int OBSTACLE_DISTANCE      = 30;
final int PREDATOR_DISTANCE      = 18;
final int FOOD_DISTANCE          = 20;
final float BOUNCE_ABSORPTION    = 2.25; // initially .25 // negative values makes the boids go out of the world.
final int VELOCITY_PULL_FACTOR   = 100;
final int MIN_DISTANCE = 20;  // initially 18
 float VELOCITY_LIMITER = 180.0  ;

final float MAX_DISTANCE = sqrt(1500*1500+15000*1500);

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


PFont font;


Boid[]       flock      = new Boid[NUM_BOIDS];
Obstacle[]   obstacles  = new Obstacle[NUM_OBSTACLES+NUM_PREDATORS];
ArrayList    foods      = new ArrayList();

// Objects..
Background _background = new Background();
World      _world;




void setup()  
{
   //size(500, 500);  // for the browser only... take the other one for offline use
   size(1080, 720, OPENGL);    
   rectMode(CENTER);
   
   
   font = createFont("Courier", 12);
   
   // initialize entities & renderers..
   initializeEntities();   
   initializeRenderers();
   
   frameRate(FRAME_RATE);
   hint(ENABLE_OPENGL_4X_SMOOTH) ;

   
}

public void initializeRenderers()
{
   //_background.setRenderer(new SaturatedBackgroundRenderer());   
   _background.setRenderer(new NoiseGreyScaleBackgroundRenderer());
   
   _world.setRenderer(new WorldRenderer());
   
}




public void initializeEntities()
{
   
   _world = new World(15000,15000,15000);
     
   
   for(int i=0; i<NUM_BOIDS; i++)
   {
      flock[i] = new Boid();
      if (i % 2 ==0)
         flock[i].setRenderer(new BoidRenderer());
      else
         flock[i].setRenderer(new BoidGreyRenderer());

   } // end for


   for (int i=0; i<NUM_OBSTACLES; i++) {
      obstacles[i] = new Obstacle();
   }

   for (int i=0; i<NUM_PREDATORS; i++) {
      obstacles[NUM_OBSTACLES+i] = new Predator();
   }

}




float counter=0;

//color from,to, bg;

void draw()  
{
   

   
   
   
   //println((int)flock[0].xpos + ";" +  (int)flock[0].zpos + ";" +  (int)flock[0].zpos);

   _background.render();
   _world.render();

   
   
     colorMode(HSB);
    //background((millis()/1000)*200 ,255,255);
    
   
    
    //println(sin(frameCount));
    println(counter);

   
   
  
  /*
  hint(DISABLE_DEPTH_TEST);
  
  beginShape();
    fill(30,30,80);
    vertex(0,0);
    vertex(width, 0);
    fill(0,0,20);
    vertex(width, height);
    vertex(0, height);
  endShape(CLOSE);
  
   fill(150);  
   textFont(font);
   text("FPS: " + int(frameRate), 10, height-12);
  
    
    unhint(DISABLE_DEPTH_TEST); 
    
   */ 
    
   

   
   lights();

   translate(width/2,height/2,-300);
   //rotateY(xRot);
   //rotateX(yRot);
   
   /*
   rotateX(TWO_PI/height*mouseY);
   rotateY(TWO_PI/width*mouseX);
   */


   


   //camera(flock[0].xpos, flock[0].zpos, flock[0].zpos, CAVE_HEIGHT/2,CAVE_HEIGHT/2,CAVE_HEIGHT/2, 0,noise(-1.0,1.0),noise(-1.0,1.0));
   
   camera(flock[0].xpos-100, flock[0].ypos-1000, flock[0].zpos-1000, 
   flock[10].xpos, flock[10].ypos, flock[10].zpos, 
   1,1,1);
   
   /*
   camera(0,0,-500+frameCount, 
   750, 750,750,
   1,1,1);

   
   /*
   camera(750,750,750, 
   flock[10].xpos, flock[10].ypos, flock[10].zpos, 
   1,1,1);
   */
   
   //endCamera();

   
   



   //pointLight(50, 55, 45, flock[30].xpos, flock[30].zpos, flock[30].zpos);   
   //pointLight(noise(random(255))*255, noise(flock[0].xpos)*255, 255, flock[0].xpos, flock[0].zpos, flock[0].zpos);
   //pointLight(110, 110, 110, flock[0].xpos, flock[0].zpos, flock[0].zpos);


   for (int i=0; i<NUM_BOIDS; ++i)
   {
      // let's not see the camera-pointed entity (it's always in the center of the screen).
      if (i== 10)
         continue;
       
      if (frameCount %150 ==0)
      {
         //flock[i].setRenderer(new NetworkBoidRenderer());
      }   
      flock[i].drawMe();
    // end for
   }



   if (showObstacles) {
      for (int i=0; i<obstacles.length; i++) {
         obstacles[i].draw(); 
      }
   }
   
      /* Draw network between obstacles
      stroke(0,20);
      strokeWeight(1);
   
      for (int i=0; i<NUM_OBSTACLES-1; i++) 
      {         
         line(obstacles[i].x, obstacles[i].y, obstacles[i].z, obstacles[i+1].x, obstacles[i+1].y, obstacles[i+1].z);
      }
      */

   for (int i=0; i< foods.size(); i++) {
      ((Food)foods.get(i)).draw();
   }
   
   


   
   

}


void mousePressed() {

   foods.add(new Food(int(random(0, _world.x)), int(random(0,_world.y)), int(random(0,_world.z))));

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
      foods.add(new Food(int(random(0,_world.x)), int(random(0,_world.y)), int(random(0,_world.z))));  
   }  

   else if (key == 's') {
      saveFrame("BoidCamArty-####.tif");      
   } 
  
   else if (key == '+') {
      VELOCITY_LIMITER += 1.0;   
   }   
   else if (key == '-') {
      VELOCITY_LIMITER -= 1.0;   
   } 


}


// -> extrapixel  : http://processing.org/discourse/yabb_beta/YaBB.cgi?board=Syntax;action=display;num=1193175897;start=1#1
