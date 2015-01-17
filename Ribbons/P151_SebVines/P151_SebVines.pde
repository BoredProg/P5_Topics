import processing.opengl.*;

Global global; //always create the global variable before using any of the default classes (created by Don)

PApplet pg; 
//PGraphics pg;
//PFont f1;

int frame = 0;
int timer = 0;
boolean rendering = true;

float depth = 0;

Camera c;

Vine v,v1,v2;

Vine[] sebVines;
int numVines = 8;


PImage img1,img2,img3;

void setup(){
  size(1400,1000,OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  //f1 = loadFont("ArialMT-48.vlw");
  //textFont(f1,12);
  //textAlign(LEFT,TOP);
  pg = this; //createGraphics(3000,2000,P3D);
  //pg.beginDraw();
  pg.smooth();
  pg.background(30);
  //initialize global
  global = new Global(width,height);
  global.init();
  //load images
  img1 = loadImage("bg1.png");
  img2 = loadImage("bg2.png");
  img3 = loadImage("bg3.png");
  //initialize camera
  c = new Camera(0,0,0);
  //initialize vine
  v = new Vine(0,0,0,1500);
  
  sebVines = new Vine[numVines];
  for (int i =0; i < numVines; i++)
  {
    sebVines[i] = new Vine(0,0,0,100);
  }
  
  v1 = new Vine(0,0,0,100);
  v2 = new Vine(0,0,0,45);
  
  
}

void draw(){
  render();
}

void render(){
  frame++;
  if(rendering){
    depth += .001;
    pg.background(50);
    pg.pushMatrix();
    pg.translate(global.w/2,global.h/2,0);
    pg.noStroke();
    pg.fill(200);
    //move camera
    c.target(-v.tx,-v.ty,v.tz-depth);
    c.step();
    //render vine
    v.step();
    v.render();
    
    
   for (int i =0; i < numVines; i++)
  {
    sebVines[i].step();
    sebVines[i].render();
  }
    

    
    pg.popMatrix();
    //image(pg,0,0,width,height);
  }
  if(frame%100==0){
    println(100/((millis()-timer)/1000.0f));
    timer = millis();
  }
}

float randomize(float $n,float $r){
  return $n+random(-$r/2,$r/2);
}

void keyPressed(){
  if(rendering&&key=='s'){
    //pg.endDraw();
    pg.save("ss.tif");
    rendering = false;
  }
}
