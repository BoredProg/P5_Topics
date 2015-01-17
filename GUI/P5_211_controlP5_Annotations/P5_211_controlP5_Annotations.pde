


import controlP5.*;

@ControlElement (properties = { "min=0", "max=255", "value=15"} , x=10, y=10, label="Brightness")
public int x = 100;

ControlP5 cp5;

void setup() {
  size(500, 500);
  cp5 = new ControlP5(this);
  cp5.addControllersFor(this);
}

void draw() {
  background(x);
}

@ControlElement (properties = { "min=0.0", "max=1.0","value=0.5"}, x=100, y=110, label="Speed")
public void setSpeed(float val) {
  println("speed : " + val);
}

@ControlElement (properties = { "width=200", "type=dropdown", "items=hello,world,how,is it,going"}, x=100, y=150, label="Track")
public void setTrack(int val) {
  println("track : " + val);
}

