import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P211_ForceDirectedPoints extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/177*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */



float mouseMass=30;

boolean renderTrail=true;
boolean renderArcs=true;
boolean mouseAttract=false;
boolean mouseRepulse=true;
boolean renderBalls=true;

int vel=5;
int mode=RANDOM;
ArrayList ns;
ArrayList as;
float k,k2;
int t;
float tMass;
int curn,nn;
float curMass;
static final int RANDOM=0;
static final int POLYNET=1;
int im;
public void keyPressed(){
  if (key=='+'){
    nn++;
    return;
  }
  else if (key=='t'){
    renderTrail=!renderTrail;
    return;
  }
  else if (key=='b'){
    renderBalls=!renderBalls;
    return;
  }
  if (mode==RANDOM)
    mode=POLYNET;
  else
    mode=RANDOM;
  prepare();    
}

public void setup(){
  size(800,800,JAVA2D);  
  smooth();
//  frameRate(1);
  ns=new ArrayList();
  as=new ArrayList();
  prepare();
  curMass=mouseMass;
  tMass=1;
  curn=0;  
}

public void mousePressed(){
  curMass=0;
  tMass=0;
  redraw();
}
public void prepare(){
  ns.clear();
  as.clear();
  switch(mode){
  case RANDOM:
    nn=15;
    k=sqrt(min(width,height)/nn)*.05f;
    ns.add(new Node(random(width/2-width/8,width/2+width/8),random(height/2-height/8,height/2+height/8),4));
    break;
  case POLYNET:
    nn=4;
    k=sqrt(width*height/nn)*.5f;
    k2=k*.2f;
    ns.add(new Node(random(width/2-width/8,width/2+width/8),random(height/2-height/8,height/2+height/8),10));
    break;
  }  
  curn=0;
}
public float fa(float m1, float m2, float z){
  return .0001f*pow(k-m1-m2-z,2);    
  //return .1*pow(m1*m2,2)/pow(z,2);
}
public float fr(float m1, float m2, float z){
  return .5f*pow(m1+m2+k,2)/pow(z,2);    
  //return 20*(m1*m2)/pow(z,2);
}

public void draw(){
  if ((t++%vel)==0 && curn<nn){ 
    curn++;
    int r=(int)(random(1,ns.size()-1))-1;
    int s=0;
    boolean gen=false;
//    if (random(1)<.1)
  //    gen=true;
    if (ns.size()>5 && gen){
      s=(int)(random(1,ns.size()-1))-1;
      while(r==s)
        s=(int)(random(1,ns.size()-1))-1;
    }
    Node nr=(Node)ns.get(r);
    Node ss=(Node)ns.get(s);
    Node newn=null;
    switch(mode){
    case RANDOM:
      newn=new Node(nr.pos.x+random(nr.mass,nr.mass+10),nr.pos.y+random(nr.mass,nr.mass+10),4);
      ns.add(newn);
      as.add(new Arc(newn,nr));
      newn.incrMass(2);
      nr.incrMass(2);
      if (ns.size()>5 && gen){
        as.add(new Arc(newn,ss));
        newn.incrMass(2);
        ss.incrMass(2);
      }  
      break;
    case POLYNET:
      float prob=random(1);
      newn=new Node(random(width),random(height),10);          
      ns.add(newn);
      for(Iterator it2=ns.iterator();it2.hasNext();){
        Node m=(Node)it2.next();          
        if (newn==m) continue;
        as.add(new Arc(newn,m));
      }
      break;
    }    
  }
  background(240);
  if (tMass<1){
    tMass+=.1f;
    curMass=sin(PI*tMass)*600*(1-tMass);
    //    
  }

  curMass=max(curMass,mouseMass);


  noStroke();
  for(Iterator it=ns.iterator();it.hasNext();){
    Node u=(Node)it.next();
    for(Iterator it2=ns.iterator();it2.hasNext();){
      Node v=(Node)it2.next();      
      if (u!=v){
        Vector2D delta=v.pos.sub(u.pos);
        if (delta.norm()!=0){
          v.disp.addSelf( delta.versor().mult( fr(v.mass,u.mass,delta.norm()) ) );
          //        System.out.println(v.pos);
        }
      }
    }
  }

  for(Iterator it=as.iterator();it.hasNext();){
    Arc e=(Arc)it.next();
    Vector2D delta=e.v.pos.sub(e.u.pos);
    if (delta.norm()!=0){
      e.v.disp.subSelf( delta.versor().mult( fa(e.v.mass,e.u.mass,delta.norm()) ) );
      e.u.disp.addSelf( delta.versor().mult( fa(e.v.mass,e.u.mass,delta.norm()) ) );    
    }
  }  
  for(Iterator it=ns.iterator();it.hasNext();){
    Node u=(Node)it.next();
    if (mouseAttract){
      Vector2D mousepos=new Vector2D(mouseX,mouseY);  
      Vector2D delta=u.pos.sub(mousepos);
      if (delta.norm()!=0){
        u.disp.subSelf( delta.versor().mult( fa(u.mass,curMass,delta.norm()) ) );
        stroke(0,0,0,20);
        line(u.pos.x,u.pos.y,mouseX,mouseY);
        noStroke();
      }  
    }
    if (mouseRepulse){
      Vector2D mousepos=new Vector2D(mouseX,mouseY);  
      Vector2D delta=u.pos.sub(mousepos);
      if (delta.norm()<curMass+u.mass+100){
        u.disp.addSelf( delta.versor().mult( fr(u.mass,curMass,delta.norm()) ) );
      }  
    }
    u.update();   
    u.costrain(0,width,0,height);
  }
  if (renderArcs)
    for(Iterator it=as.iterator();it.hasNext();){
      Arc a=(Arc)it.next();
      a.draw();
    }  
  for(Iterator it=ns.iterator();it.hasNext();){
    Node u=(Node)it.next();
    if (renderTrail)
      u.setTrail(true);
    else
      u.setTrail(false);  
    if (renderBalls)
      u.setBall(true);
    else
      u.setBall(false);  
    u.draw();

    /*
    fill(128);
     PFont fontA = loadFont("CourierNew36.vlw");
     textFont(fontA, 10);
     textAlign(CENTER);
     text("Node "+u, u.pos.x, u.pos.y+u.mass*2);
     noFill();
     */
  }
  noFill();
  stroke(200,100,0,20);
  ellipse(mouseX,mouseY,curMass,curMass);

}
class Arc{
  Node v;
  Node u;
  Arc(Node _s, Node _e){
    v=_s;
    u=_e;
  }
  public void draw(){
    int r=(int)((red(v.mycolor)+red(u.mycolor))/2);
    int g=(int)((green(v.mycolor)+green(u.mycolor))/2);
    int b=(int)((blue(v.mycolor)+blue(u.mycolor))/2);    
    stroke(r,g,b);
    //line(v.pos.x,v.pos.y,u.pos.x,u.pos.y);
    bezier(v.pos.x,v.pos.y,v.oldpos[2].x,v.oldpos[2].y,u.oldpos[2].x,u.oldpos[2].y,u.pos.x,u.pos.y);    
    noStroke();
  }
}
class Node{
  Vector2D pos;
  Vector2D disp;
  Vector2D[] oldpos;
  float mass;
  float newmass;
  int mycolor;
  boolean trail;
  boolean ball;
  Node(float _x, float _y,float _mass){
    pos=new Vector2D(_x,_y);
    disp=new Vector2D();
    mass=_mass;
    oldpos=new Vector2D[8];
    for(int i=0;i<oldpos.length;i++)
      oldpos[i]=pos.clone();
    mycolor=color(20+random(215),20+random(215),20+random(215));
    ball=true;
    trail=true;
  }
  public void incrMass(float nm){
    newmass=mass+nm;
  }
  public void setBall(boolean ball){
    this.ball=ball;
  }
  public void setTrail(boolean trail){
    this.trail=trail;
  }
  public void update(){
    for(int i=oldpos.length-1;i>0;i--)
      oldpos[i]=oldpos[i-1];
    oldpos[0]=pos.clone();  
    pos.addSelf(disp);
    disp.clear();
  }  
  public void draw(){
    if (mass<newmass)
      mass+=.2f;
    if (trail) 
      for(int i=0;i<oldpos.length;i++){
        float perc=(((float)oldpos.length-i)/oldpos.length);
        fill(red(mycolor),green(mycolor),blue(mycolor),perc*240);
        ellipse(oldpos[i].x,oldpos[i].y,2*mass*perc,2*mass*perc);
      }
    if (ball)  {
      fill(mycolor);
      ellipse(pos.x,pos.y,mass*2,mass*2);
      fill(240,240,240);
      ellipse(pos.x,pos.y,mass*1.5f,mass*1.5f);
      fill(mycolor);
      ellipse(pos.x,pos.y,mass,mass);   
    }
  }
  public void costrain(float x0, float x1,float y0, float y1){
    pos.x=min(x1,max(x0,pos.x));
    pos.y=min(y1,max(y0,pos.y));
  }
  public String toString(){
    return pos+"";
  }
}
class Vector2D{
  float x;
  float y;
  Vector2D(){
    this(0,0);
  }
  public void set(float _x,float _y){x=_x;y=_y;}
  Vector2D(float _x, float _y){
    x=_x;
    y=_y;
  }
  public void clear(){x=0;y=0;}
  public Vector2D add(Vector2D v){
    return new Vector2D(x+=v.x,y+=v.y);
  }
  public Vector2D add(float x, float y){
    return new Vector2D(x+=x,y+=y);
  }
  public Vector2D addSelf(Vector2D v){
    x+=v.x;
    y+=v.y;
    return this;
  }  
  public Vector2D addSelf(float _x, float _y){
    x+=_x;
    y+=_y;
    return this;
  }  
  public Vector2D sub(float x, float y){
    return new Vector2D(x-=x,y-=y);
  }
  public Vector2D sub(Vector2D v){
    return new Vector2D(x-v.x,y-v.y);
  }
  public Vector2D subSelf(Vector2D v){
    x-=v.x;
    y-=v.y;
    return this;
  }
  public Vector2D subSelf(float _x, float _y){
    x-=_x;
    y-=_y;
    return this;
  }
  public Vector2D mult(float alpha){
    return new Vector2D(x*alpha,y*alpha);
  }
  public Vector2D multSelf(float alpha){
    x*=alpha;
    y*=alpha;
    return this;
  }
  public Vector2D div(float alpha){
    return new Vector2D(x/alpha,y/alpha);
  }
  public Vector2D divSelf(float alpha){
    x/=alpha;
    y/=alpha;
    return this;
  }
  public float norm(){
    return sqrt(pow(x,2)+pow(y,2));
  }
  public Vector2D versor(){
    return new Vector2D(x/norm(),y/norm());
  }
  public Vector2D versorSelf(){
    x/=norm();
    y/=norm();
    return this;
  }
  public Vector2D clone(){
    return new Vector2D(x,y);
  }
  public String toString(){
    return "["+x+","+y+"]";
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P211_ForceDirectedPoints" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
