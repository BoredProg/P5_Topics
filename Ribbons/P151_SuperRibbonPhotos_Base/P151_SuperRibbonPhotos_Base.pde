import processing.opengl.*;

//import moviemaker.*;  
//MovieMaker mm;  

PImage[] textures = new PImage[6];
Ribbon[] ribbons = new Ribbon[50];

PFont font;
boolean group = false;

void setup()
{
  font = createFont("Arial",30);
  textFont(font);
  size(1280,800,OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  //mm = new MovieMaker(this,width,height,"p5test.mov", MovieMaker.JPEG, MovieMaker.HIGH,20);
  
  for(int i=0;i<textures.length;i++)
  {
    textures[i] = loadImage("0"+(i+1)+".gif");
  }
  for(int i=0;i<ribbons.length;i++)
  {
    ribbons[i] = new Ribbon();
  }
  background(255);
}

void draw()
{
  if(random(1)>0.995) group = !group;
  background(255);
  pushMatrix();
  translate(width/2,height/2,-500);
  rotateX(-0.5);
  for(int i=0;i<ribbons.length;i++)
  {
    ribbons[i].update();
  }
  popMatrix();
  
  //loadPixels();
  //mm.addFrame(pixels,width,height);
}

void mousePressed()
{
  //mm.finishMovie();
}
