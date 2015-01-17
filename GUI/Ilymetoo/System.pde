class System {

  Circle[] circles;
  float[] xpos;
  float[] ypos;

  float noiseValue = 0.010;   // base of random move
  float lw;                   // linkWeight
  int md;                     // maxDist
  int maxPop;                 // maximum population (max array size)
  int currentPop;

  System(int in) {
    circles = new Circle[in];
    xpos = new float[in];
    ypos = new float[in];
    lw = 1;
    md = 25;
    maxPop = in;
    currentPop=0;

    for(int i = 0; i< circles.length;i++) {
      circles[i] = new Circle(random(width),random(height)); 
    }
  }

  void draw(float speedMove, float linkWeight, int maxDist, int pop) {
  
    currentPop=pop;
    md = maxDist;

    //for(int i = 0; i < circles.length;i++) {
    for(int i = 0; i < currentPop; i++) {
      xpos[i]= circles[i].x;
      ypos[i]= circles[i].y;
      
      circles[i].nb=0;
      circles[i].selfmove=0;
      lw = linkWeight;
      linkIt(i);

      circles[i].move(noiseValue);        // noiseValue
      circles[i].display();

    }
    noiseValue = speedMove / 10000;
  }
  
  void linkIt(int ii) {
    float a,d;

    for (int j = ii; j < currentPop; j++) {
      d = dist(xpos[ii],ypos[ii],xpos[j],ypos[j]);
      if(d <= md && ii != j ) {
        //a = 160 - (d*3);
        a = 255 - (d * (255/md));
        strokeWeight(lw);
        stroke(180,180,220,a);
        line(xpos[ii],ypos[ii],xpos[j],ypos[j]);
        circles[ii].addnb(1);
      }
    }
  }
}
