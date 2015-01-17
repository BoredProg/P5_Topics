class Obstacle {

  public int x, y, z, mySize, minDistance;

  Obstacle() {
    x = int(random(_world.x));
    //y = 0;
    y = int(random(_world.y));
    z = int(random(_world.z));
   mySize = int(random(10, 20));
    minDistance = mySize + OBSTACLE_DISTANCE;
  } 

  void draw() {
    strokeWeight(3);
   // stroke(0);
    noStroke();
    fill(50,50,100,150);
    pushMatrix();
    //translate(0,0,z);
    //ellipse(x, y, 10,10); 
    translate(x,y,z);
    box(mySize); 
    popMatrix();
  }

}
