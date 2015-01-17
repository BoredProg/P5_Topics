//------ COLLIDER ------//
//colliders are slightly more sophisticated than particles
//they have mass and can maintain their radius from other colliders
class Collider extends Particle{
  int n;
  float m;
  Collider(float $x,float $y,float $z,float $vx,float $vy,float $vz,float $r){
    super($x,$y,$z,$vx,$vy,$vz,$r);
    m = PI*sq(r)*global.density;
    //n = global.ncolliders;
    //global.colliders[global.ncolliders++] = this;
  }
  void bump(Collider $c){
    //xy coordinates only
    float d = dist($c.x,$c.y,x,y);
    float rr = $c.r+r;
    if(d<rr&&d!=0){
      //this part taken mostly from bit-101 (www.bit-101.com)
      float a = atan2($c.y-y,$c.x-x);
      float cosa = cos(a);
      float sina = sin(a);
      float vx1p = cosa*vx+sina*vy;
      float vy1p = cosa*vy-sina*vx;
      float vx2p = cosa*$c.vx+sina*$c.vy;
      float vy2p = cosa*$c.vy-sina*$c.vx;
      float p = vx1p*m+vx2p*$c.m;
      float v = vx1p-vx2p;
      vx1p = (p-$c.m*v)/(m+$c.m);
      vx2p = v+vx1p;
      vx = cosa*vx1p-sina*vy1p;
      vy = cosa*vy1p+sina*vx1p;
      $c.vx = cosa*vx2p-sina*vy2p;
      $c.vy = cosa*vy2p+sina*vx2p;
      float diff = global.bounce*((r+$c.r)-d)/2;
      float cosd = cosa*diff;
      float sind = sina*diff;
      x -= cosd;
      y -= sind;
      $c.x += cosd;
      $c.y += sind;
    }
  }
  void step(){
    vy += global.gravity;
    vx *= 1-global.friction;
    vy *= 1-global.friction;
    super.step();
  }
  void echo(int $indent){
    String indent = "";
    while(indent.length()<$indent){
      indent += "  ";
    }
    println(indent+"---- COLLIDER #"+n+" ----");
  }
  void render(){
    super.render();
  }
}
