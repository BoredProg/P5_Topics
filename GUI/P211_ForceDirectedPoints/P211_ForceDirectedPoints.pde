/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/177*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

import java.util.*;

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
void keyPressed(){
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

void setup(){
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

void mousePressed(){
  curMass=0;
  tMass=0;
  redraw();
}
void prepare(){
  ns.clear();
  as.clear();
  switch(mode){
  case RANDOM:
    nn=15;
    k=sqrt(min(width,height)/nn)*.05;
    ns.add(new Node(random(width/2-width/8,width/2+width/8),random(height/2-height/8,height/2+height/8),4));
    break;
  case POLYNET:
    nn=4;
    k=sqrt(width*height/nn)*.5;
    k2=k*.2;
    ns.add(new Node(random(width/2-width/8,width/2+width/8),random(height/2-height/8,height/2+height/8),10));
    break;
  }  
  curn=0;
}
float fa(float m1, float m2, float z){
  return .0001*pow(k-m1-m2-z,2);    
  //return .1*pow(m1*m2,2)/pow(z,2);
}
float fr(float m1, float m2, float z){
  return .5*pow(m1+m2+k,2)/pow(z,2);    
  //return 20*(m1*m2)/pow(z,2);
}

void draw(){
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
    tMass+=.1;
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
