// FloatingWindow.pde
// Marius Watz - http://workshop.evolutionzone.com
// 
// Provides a method for creating frame-less windows with smaller 
// than typical sizes. Also demonstrates how to set the precise
// location of the window on screen, as well as make it float over
// all other windows.
//
// Can be useful if you'd like to make a persistent "debug" app of
// some sort, or just because it's neat when things don't look like
// your everyday operating system.
//
// Works both with P2D and OPENGL.Uses a trick from this Processing hack:
// http://processing.org/hacks/hacks:undecoratedframe
 
PFont fnt;
int W,H,PX,PY;
 
void setup() {
  // W x H == desired size of frame. 
  // Normally, Processing will not create a frame smaller than ~120x120,
  // but will pad the window with blank pixels.
  W=100;
  H=40;
 
  // initial position of frame
  PX=100;
  PY=100;
 
  size(W,H);
  fnt=createFont("Arial",12,false);
}
 
// overriding PApplet.init() to add a hack of our own
void init() {
 
  // trick to make it possible to change the frame properties
  frame.removeNotify(); 
 
  // comment this out to turn OS chrome back on
  frame.setUndecorated(true); 
 
  // comment this out to not have the window "float"
  frame.setAlwaysOnTop(true); 
 
  frame.setResizable(true);  
  frame.addNotify(); 
 
  // making sure to call PApplet.init() so that things 
  // get  properly set up.
  super.init();
}
 
void draw() {
  background(0);
 
  // resize and set initial location a few frames after sketch start. 
  // our window will now be tiny and located at position PX,PY.
 
  if(frameCount==5) {
    frame.resize(W,H);
    frame.setLocation(PX,PY);
  }
 
  // draw window outline
  noStroke();
  fill(255,100,0);
  rect(0,0, width,height);
  fill(0);
  rect(3,3, width-6,height-6);
 
  textFont(fnt);
  fill(255,255,0);
  text(frameCount/10+" | "+
    frame.getLocation().x+","+
    frame.getLocation().y,16,24);
}
 
// the cursor keys may be used to move the window around
void keyPressed() {
  if(key==CODED) {
    if(keyCode==LEFT) frame.setLocation(
      frame.getLocation().x-5,
      frame.getLocation().y);
    if(keyCode==RIGHT) frame.setLocation(
      frame.getLocation().x+5,
      frame.getLocation().y);
    if(keyCode==UP) frame.setLocation(
      frame.getLocation().x,
      frame.getLocation().y-5);
    if(keyCode==DOWN) frame.setLocation(
      frame.getLocation().x,
      frame.getLocation().y+5);
  }  
}
