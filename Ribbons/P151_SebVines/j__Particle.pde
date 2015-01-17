//------ PARTICLE ------//
//the particle class is stage-aware, in that it can wrap its position from one side of the screen to the other
//particles have no mass, but have a display radius
class Particle extends Point{
  int n;
  float vx,vy,vz,tvx,tvy,tvz,r;
  boolean wrap = true;
  boolean bounce = false;
  Particle(float $x,float $y,float $z,float $vx,float $vy,float $vz,float $r){
    super($x,$y,$z);
    vx = tvx = $vx; vy = tvy = $vy; vz = tvz = $vz; r = $r;
    //n = global.nparticles;
    //global.particles[global.nparticles++] = this;
  }
  void attract(Particle $p){
    float d = get_distance_to($p.x,$p.y,$p.z);
    if(d<global.particle_attraction_max_distance){
      float dx = ($p.x-x)*global.particle_attraction_speed;
      float dy = ($p.y-y)*global.particle_attraction_speed;
      float dz = ($p.z-z)*global.particle_attraction_speed;
      tvx = dx; tvy = dy; tvz = dz;
      $p.tvx = -dx; $p.tvy = -dy; $p.tvz = -dz;
    }
  }
  void wander(boolean $z){
    tvx += random(-global.particle_wander_speed,global.particle_wander_speed);
    tvy += random(-global.particle_wander_speed,global.particle_wander_speed);
    if($z){
      tvz += random(-global.particle_wander_speed,global.particle_wander_speed);
    }
  }
  void step(){
    vx += (tvx-vx)*global.particle_speed;
    vy += (tvy-vy)*global.particle_speed;
    vz += (tvz-vz)*global.particle_speed;
    vx *= 1-global.friction;
    vy *= 1-global.friction;
    vz *= 1-global.friction;
    move(vx,vy,vz);
    super.step();
    if(bounce){
      //xy coordinates only
      if(x>global.w/2-r||x<-global.w/2+r){
        vx *= -1*global.bounce;
        x = constrain(x,-global.w/2+r,global.w/2-r);
      }
      if(y>global.h/2-r||y<-global.h/2+r){
        vy *= -1*global.bounce;
        y = constrain(y,-global.h/2+r,global.h/2-r);
      }
    }else if(wrap){
      //xy coordinates only
      if(x>global.w/2-r||x<-global.w/2+r){
        x += 3*global.w/2;
        x %= global.w;
        x -= global.w/2;
      }
      if(y>global.h/2-r||y<-global.h/2+r){
        y += 3*global.h/2;
        y %= global.h;
        y -= global.h/2;
      }
    }
  }
  void echo(int $indent){
    String indent = "";
    while(indent.length()<$indent){
      indent += "  ";
    }
    println(indent+"---- PARTICLE #"+n+" ----");
  }
  void render(){
    if(r>1){
      pg.pushMatrix();
      pg.translate(x,y,z);
      pg.ellipse(0,0,r*2,r*2);
      pg.popMatrix();
      pg.point(x,y,z);
    }else{
      pg.point(x,y,z);
    }
  }
}
