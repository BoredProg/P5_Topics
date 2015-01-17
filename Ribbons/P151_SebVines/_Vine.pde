class Vine extends Polyline{
  float x,y,z,tx,ty,tz,vx,vy,vz;
  float speed = .005;
  float damping = .02;
  float th = 12;
  float dthd1 = 200;
  float dthd2 = 70;
  float dthm = 11;
  float target_distance = 100;
  float redirect_distance = 60;
  Vector v;
  Graphic[] graphics = new Graphic[200];
  int ngraphics = 0;
  Vine(float $x,float $y,float $z,int $nsegments){
    super();
    segments = new Segment[$nsegments];
    tx = x = $x; ty = y = $y; tz = z = $z;
    vx = vy = vz = 0;
    v = new Vector(0,0,0);
    add_point(new Point($x,$y,$z));
  }
  void step(){
    float d = dist(x,y,z,tx,ty,tz);
    if(d<target_distance){
      tx += random(-redirect_distance,redirect_distance);
      ty += random(-redirect_distance,redirect_distance);
      //tx = global.constrainX(tx);
      //ty = global.constrainY(ty);
      //tz = 0;
    }
    vx += (tx-x)*speed;
    vy += (ty-y)*speed;
    //vz += (tz-z)*speed;
    vx *= 1-damping;
    vy *= 1-damping;
    //vz *= 1-damping;
    x += vx;
    y += vy;
    //z += vz;
    add_point(new Point(x,y,depth));
    if(nsegments%50==0){
      if(random(4)<1){
        graphics[ngraphics%graphics.length] = new Graphic(img2,x,y,0,random(TWO_PI),1,150,5);
      }else if(random(4)<1){
        graphics[ngraphics%graphics.length] = new Graphic(img3,x,y,0,random(TWO_PI),1,150,5);
      }else{
        graphics[ngraphics%graphics.length] = new Graphic(img1,x,y,0,random(TWO_PI),1,150,5);
      }
      ngraphics++;
    }
  }
  void render(){
    int l = max(ngraphics-graphics.length,0);
    for(int i=l;i<ngraphics;i++){
      graphics[i%graphics.length].step();
      graphics[i%graphics.length].render();
    }
    l = max(nsegments-segments.length,0);
    pg.beginShape(QUAD_STRIP);
    for(int i=l;i<nsegments;i++){
      float p = (i-l)/float(min(nsegments,segments.length));
      float dx = 0;
      float dy = 0;
      if(i>l){
        float dth = 0;
        if(i-l<dthd1){
          dth = dthm-min(dthm*(i-l)/dthd1,dthm);
        }else if(i-l>min(nsegments,segments.length)-dthd2){
          dth = dthm-min(dthm*(min(segments.length,nsegments)-(i-l))/dthd2,dthm);
        }
        if(abs(segments[(i-1)%segments.length].p2.y-segments[i%segments.length].p2.y)>global.distance_tolerance){
          v.vx = segments[(i-1)%segments.length].p2.y-segments[i%segments.length].p2.y;
          v.vy = -(segments[(i-1)%segments.length].p2.x-segments[i%segments.length].p2.x);
          v.vz = 0;
          v.unitize();
          v.scale(max(th/2-dth/2,0));
          dx = v.vx;
          dy = v.vy;
        }else{
          dx = 0;
          dy = max(th/2-dth/2,0);
        }
      }
      //fill(52+43*p,50+50*p,10+10*p);
      fill(30-30*p);
      //stroke(75,100,20);
      //fill(240*p,250*p,30*p);
      pg.vertex(segments[i%segments.length].p2.x-dx,segments[i%segments.length].p2.y-dy,segments[i%segments.length].p2.z);
      pg.vertex(segments[i%segments.length].p2.x+dx,segments[i%segments.length].p2.y+dy,segments[i%segments.length].p2.z);
    }
    pg.endShape();
    
    
    //stroke(255,0,0);
    //super.render();
    //pg.ellipse(tx,ty,10,10);
  }
}
