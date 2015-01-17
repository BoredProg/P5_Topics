class Target{
  float x, y, z;
  float vx, vy, vz, ax, ay, az;
  Target(){
    x = random(width);
    y = random(height);
    z = 0;
  }
  void mover(){
    ax = var(tVar);
    vx += ax;
    vx *= tDamp;
    x += vx;

    ay = var(tVar);
    vy += ay;
    vy *= tDamp;
    y += vy;

    az = var(tVar);
    vz += az;
    vz *= tDamp;
    z += vz;

    if(x<0){
      x = 0;
      vx *= -1;
    }
    if(x>width){
      x = width;
      vx *= -1;
    }
    if(y<0){
      y = 0;
      vy *= -1;
    }
    if(y>height){
      y = height;
      vy *= -1;
    }
    if(z<minZ){
      z = minZ;
      vz *= -1;
    }
    if(z>maxZ){
      z = maxZ;
      vz *= -1;
    }
  }
  void render(){
    pushMatrix();
    fill(0);
    translate(x, y, z);    
    //ellipse(0, 0, 10,10);
    
    fill(240,20,150);
    box(70);
    popMatrix();
  }
  float var(float _var){
    return(random(-_var, _var));
  }
}
