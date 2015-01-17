//------ POLYLINE ------//
class Polyline{
  Segment[] segments = new Segment[1000];
  int nsegments = 0;
  int n;
  Polyline(Segment[] $segments){
    segments = $segments;
    nsegments = segments.length;
    //n = global.npolylines;
    //global.polylines[global.npolylines++] = this;
  }
  Polyline(){
    //n = global.npolylines;
    //global.polylines[global.npolylines++] = this;
  }
  float get_length(){
    float l = 0;
    for(int i=0;i<nsegments;i++){
      l += segments[i].get_length();
    }
    return l;
  }
  void add_point(Point $p){
    if(nsegments==0){
      add_segment($p,new Point($p.x,$p.y+.01,$p.z));
    }else{
      add_segment(segments[(nsegments-1)%segments.length].p2,$p);
    }
  }
  void add_segment(Point $p1,Point $p2){
    segments[nsegments%segments.length] = new Segment($p1,$p2);
    nsegments++;
  }
  void echo(int $indent){
    String indent = "";
    while(indent.length()<$indent){
      indent += "  ";
    }
    println(indent+"---- POLYLINE #"+n+" ----");
    int l = max(nsegments-segments.length,0);
    for(int i=l;i<nsegments;i++){
      segments[i%segments.length].echo($indent+1);
    }
  }
  void render(){
    int l = max(nsegments-segments.length,0);
    for(int i=l;i<nsegments;i++){
      segments[i%segments.length].render();
    }
  }
}
