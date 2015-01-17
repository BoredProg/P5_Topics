class Boid{
  Target t;
  Point p[] = new Point[numP];
  float dist2T;

  Boid(Target _t){
    t = _t;
    for(int i=0; i<numP; i++){
      p[i] = new Point();
      p[i].x = t.x;
      p[i].y = t.y;
      p[i].z = 0;
    }
    p[0].x = t.x+var(bVar);
    p[0].y = t.y+var(bVar);
  } 
  void mover(){
    p[0].ax = ((t.x - p[0].x) * bK)+var(bVar);
    p[0].vx += p[0].ax;
    p[0].vx *= bDamp;
    p[0].x += p[0].vx;

    p[0].ay = ((t.y - p[0].y) * bK)+var(bVar);
    p[0].vy += p[0].ay;
    p[0].vy *= bDamp;
    p[0].y += p[0].vy;

    p[0].az = ((t.z - p[0].z) * bK)+var(bVar);
    p[0].vz += p[0].az;
    p[0].vz *= bDamp;
    p[0].z += p[0].vz;
    for(int i=1; i<numP; i++){
      p[i].ax = (p[i-1].x - p[i].x) * pK;
      p[i].vx += p[i].ax;
      p[i].vx *= pDamp;
      p[i].x += p[i].vx;

      p[i].ay = (p[i-1].y - p[i].y) * pK;
      p[i].vy += p[i].ay;
      p[i].vy *= pDamp;
      p[i].y += p[i].vy;

      p[i].az = (p[i-1].z - p[i].z) * pK;
      p[i].vz += p[i].az;
      p[i].vz *= pDamp;
      p[i].z += p[i].vz;
    }
  }
  void render(){
    noStroke();
    float ang;
    beginShape(QUAD_STRIP);
    for(int i=0; i<numP-1; i++){
       fill(250-(250/numP*i), 250-(250/numP*i));
      ang = atan2(p[i+1].y-p[i].y, p[i+1].x-p[i].x);
      p[i].offY = cos(ang)*larg*sin(PI/(numP-2)*(i));
      p[i].offX = sin(ang)*larg*sin(PI/(numP-2)*(i));
      vertex(p[i].x-p[i].offX, p[i].y+p[i].offY);
      vertex(p[i].x+p[i].offX, p[i].y-p[i].offY);
    }
    endShape();

    stroke(20);
    
    beginShape(LINES);
    for(int i=1; i<numP; i++){
      vertex(p[i].x-p[i].offX, p[i].y+p[i].offY);
      vertex(p[i-1].x-p[i-1].offX, p[i-1].y+p[i-1].offY);
    }
    for(int i=1; i<numP; i++){
      vertex(p[i].x+p[i].offX, p[i].y-p[i].offY);
      vertex(p[i-1].x+p[i-1].offX, p[i-1].y-p[i-1].offY);
    }
    endShape();
  }

  float var(float _var){
    return(random(-_var, _var));
  }

  void checkDistCurrentTarget(){
    float dx = t.x-p[0].x;
    float dy = t.y-p[0].y;
    float dz = t.z-p[0].z;
    float dXY_SQ = (dx*dx+dy*dy);
    dist2T = (dXY_SQ + dz*dz); 
  } 

  void checkNearestTarget(Target _t[]){
    for(int i=0; i<numT; i++){
      float dx = _t[i].x-p[0].x;
      float dy = _t[i].y-p[0].y;
      float dz = _t[i].z-p[0].z;
      float dXY_SQ = (dx*dx+dy*dy);
      float distNearT = (dXY_SQ + dz*dz); 
      if(distNearT<dist2T){
        t = _t[i];
      }
    }

  }


}
