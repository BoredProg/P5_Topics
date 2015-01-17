class Food extends Obstacle{

  public int filling;
  float maxSize = 15;
  float currentSize = 15;
  float vx, vy, vz;

  Food(int x, int y, int z) 
  {
    super();
    this.x = x;
    this.y = y;
    this.z = z;
    minDistance = FOOD_DISTANCE;
    filling = 200;
  } 

  void draw() 
  {

    if (vx > 0) {
      vx *= .9; 
    }
    if (vy > 0) {
      vy *= .9; 
    }
    if (vz > 0) {
      vz *= .9; 
    }

    if (x + vx < 0 || x + vx > _world.x)
      vx = -vx*BOUNCE_ABSORPTION;
    if (y + vy < 0 || y + vy > _world.y)
      vy = -vy*BOUNCE_ABSORPTION;
    if (z + vz < 0 || z + vz > _world.z)
      vz = -vz*BOUNCE_ABSORPTION;

    x += vx;
    y += vy;
    z  += vz;

    //strokeWeight(3);
    //stroke(0);
    noStroke();
    fill(0,200,0);
    currentSize = maxSize/200.0*filling;
    pushMatrix();
    translate(x,y,z);
    box(currentSize);
    //ellipse(x, y, currentSize,currentSize); 
    popMatrix();
    if (filling <= 0) {
      foods.remove(this); 
    }
  }

}
