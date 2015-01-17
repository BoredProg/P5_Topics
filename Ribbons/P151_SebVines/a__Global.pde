//------ GLOBAL ------//
//the global class holds all other default classes
//its only purpose is for organization and to imitate actionscript
class Global{
  float particle_speed = .02;
  float particle_wander_speed = .1;
  float particle_attraction_max_distance = 1000;
  float particle_attraction_speed = .1;
  float distance_tolerance = .0001;
  float slope_tolerance = .001;
  float angle_tolerance = .001;
  float point_speed = .01;
  Point zero_point;
  float gravity = 0;
  float friction = 0;
  float bounce = .9;
  float density = 1.5;
  int w,h;
  int npoints,nsegments,nvectors,nlines,npolygons,npolylines,nplanes,nfaces,nparticles,ncolliders;
  
  //Point[] points = new Point[100000000]; Segment[] segments = new Segment[10000000]; Vector[] vectors = new Vector[1000000]; Line[] lines = new Line[1000000]; Polygon[] polygons = new Polygon[100000]; Polyline[] polylines = new Polyline[100000]; Plane[] planes = new Plane[100000]; Face[] faces = new Face[100000]; Particle[] particles = new Particle[1000000]; Collider[] colliders = new Collider[100000];
  Polygon stage;
  Global(int $w,int $h){
    w = $w; h = $h;
    npoints = nsegments = nvectors = nlines = npolygons = npolylines = nplanes = nfaces = nparticles = ncolliders = 0;
  }
  void init(){
    Point[] ps = new Point[4]; ps[0] = new Point(-w/2,-h/2,0); ps[1] = new Point(w/2,-h/2,0); ps[2] = new Point(w/2,h/2,0); ps[3] = new Point(-w/2,h/2,0);
    stage = new Polygon(ps);
    zero_point = new Point(0,0,0);
  }
  float constrainX(float $x){
    return min(w/2,max(-w/2,$x));
  }
  float constrainY(float $y){
    return min(h/2,max(-h/2,$y));
  }
  Point random_point(){
    //xy coordinates only
    return new Point(random(-w/2,w/2),random(-h/2,h/2),0);
  }
  void echo(){
    println("---- GLOBAL ----");
    println("Points: "+npoints);
    println("Segments: "+nsegments);
    println("Vectors: "+nvectors);
    println("Lines: "+nlines);
    println("Polygons: "+npolygons);
    println("Polylines: "+npolylines);
    println("Planes: "+nplanes);
    println("Faces: "+nfaces);
    println("Particles: "+nparticles);
    println("Colliders: "+ncolliders);
  }
  void render(int $n){
    /*
    if($n>=1028){
      for(int i=0;i<ncolliders;i++){
        fill(255,255,240);
        stroke(255);
        strokeWeight(1);
        colliders[i].render();
      }
      $n -= 512;
    }
    if($n>=512){
      for(int i=0;i<nparticles;i++){
        fill(255,255,240);
        stroke(255,0,0);
        strokeWeight(1);
        particles[i].render();
      }
      $n -= 512;
    }
    if($n>=256){
      for(int i=0;i<nfaces;i++){
        fill(255,255,240);
        stroke(255);
        strokeWeight(1);
        faces[i].render();
      }
      $n -= 256;
    }
    if($n>=128){
      for(int i=0;i<nplanes;i++){
        fill(255,240,240);
        stroke(255);
        strokeWeight(1);
        planes[i].render();
      }
      $n -= 128;
    }
    if($n>=64){
      for(int i=0;i<npolygons;i++){
        fill(255,250,250);
        stroke(0);
        strokeWeight(1);
        polygons[i].render();
      }
      $n -= 64;
    }
    if($n>=32){
      for(int i=0;i<npolylines;i++){
        fill(255,250,250);
        stroke(0);
        strokeWeight(1);
        polylines[i].render();
      }
      $n -= 32;
    }
    if($n>=16){
      noFill();
      stroke(0,0,255);
      strokeWeight(1);
      for(int i=0;i<nlines;i++){
        lines[i].render();
      }
      $n -= 16;
    }
    if($n>=8){
      noFill();
      stroke(0,255,255);
      strokeWeight(1);
      for(int i=0;i<nsegments;i++){
        segments[i].render();
      }
      $n -= 8;
    }
    if($n>=4){
      noFill();
      stroke(255,0,255);
      strokeWeight(1);
      for(int i=0;i<nvectors;i++){
        vectors[i].render(zero_point);
      }
      $n -= 4;
    }
    if($n>=2){
      fill(0);
      stroke(0);
      strokeWeight(1);
      for(int i=0;i<npoints;i++){
        points[i].render();
      }
      $n -= 2;
    }
    if($n>=1){
      noFill();
      stroke(255,0,0);
      strokeWeight(1);
      stage.render();
      $n -= 1;
    }
    */
  }
}
