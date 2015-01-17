class Circle {

  float x,y;
  float rx,ry;                // x,y random position
  float z1;                   // size of central dot 
  float z2;                   // size of first circle
  int c1, c2;               // circles colors

  int c1MaxSize = 4;
  int c2MaxSize = 9;

//  float c2Alpha = 0;

  int i, maxi;                // range of secondary circles
  int nb;                      // nb of neighbor
  float selfmove;


  Circle(float irx,float iry) { // initial random x & y position
    rx = irx;
    ry = iry; 
    x = (noise(rx)*width);
    y = (noise(ry)*height);
    nb = 0;
    selfmove = 0;
    c1 = 124;
    c2 = 124;
  }

  void move(float noiseValue) {
    x = (noise(rx)*width);
    y = (noise(ry)*height);
    rx+=noiseValue + selfmove;
    ry+=noiseValue + selfmove;
    z1 = (random(1,c1MaxSize));
    if ( nbProp )
      z2 = (random(z1,nb*3));
    else
      z2 = (random(0,c2MaxSize));
    //c1 = random(c1,255-c1);      // color of central dot
    c1 = (int) random(70+(nb*2),150+((nb*3)%105));      // color of central dot => from 70 to 255
    //println(c1);
    //c2 = random(c1,c1/2+50-c2);
    c2 = (int) random(c1-70,c1);                        // from 0 to c1
  }    

  void display() {
    if (c2Alpha > 0) {
      if (c2Fill) {
        noStroke();
        fill(c2,c2Alpha);
      }
      else {
        stroke(c2,c2Alpha);
        strokeWeight(0.2);
        fill(0,c2Alpha);
      }
      ellipse(x,y,z2,z2);
    }
    if (c1Alpha > 0) {
      noStroke();
      fill(c1,c1Alpha);
      ellipse(x,y,z1,z1);
    }
  }

  void addnb(int n) {
    nb += n;
    selfmove += speedMove * (nb / 500);
  }
}
