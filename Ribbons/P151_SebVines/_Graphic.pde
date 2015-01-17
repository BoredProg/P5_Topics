class Graphic{
  PImage img;
  float x,y,z,r,s,w,h,ta;
  float a = 0;
  int ftl,f;
  float aspeed = .007;
  Graphic(PImage $img,float $x,float $y,float $z,float $r,float $s,float $ta,int $ftl){
    img = $img; x = $x; y = $y; z = $z; r = $r; s = $s; ta = $ta; ftl = $ftl;
    w = img.width;
    h = img.height;
  }
  boolean is_dead(){
    if(ta==0&&a<1){ return true; }
    return false;
  }
  void step(){
    a += (ta-a)*aspeed;
    if(abs(ta-a)<1){
      f++;
      if(f>=ftl){ ta = 0; }
    } 
  }
  void render(){
    if(!is_dead()){
      pushMatrix();
      translate(x,y,z);
      rotateZ(r);
      tint(255,a);
      image(img,-w/2,-h/2);
      popMatrix();
    }
  }
}
