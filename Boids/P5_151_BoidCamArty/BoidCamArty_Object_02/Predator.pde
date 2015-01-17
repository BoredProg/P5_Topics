class Predator extends Obstacle {
  float vx = 0;
  float vy = 0;
  float vz = 0;

  Predator() {
    super();
    while(vx==0 || vy ==0 || vz ==0) {
      vx = int(random(-1.1, 1.1));
      vy = int(random(-1.1, 1.1));
      vz = int(random(-1.1, 1.1));
    }
    minDistance = PREDATOR_DISTANCE;

  }
  void draw() {
    if (x+vx > _world.x || x+vx < 0) {
      vx*=-1;
    } 
    if (y+vy > _world.y || y+vy<0) {
      vy*=-1; 
    }
    
    if (z+vz> _world.z || z+vz <0) {
     vz*=-1; 
    }
    x += vx;
    y += vy;
    z += vz;

    // super.draw();

    //strokeWeight(1.5);
    noStroke();
    fill(255,0,0,100);
    pushMatrix();
    translate(x,y,z);
    box(9); 
    popMatrix();
  }
}
