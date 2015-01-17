import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P211_NeronsParallerComposition extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/11152*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

Neuron n[];
Signal s[];

boolean render = false;

//////////////////////////////////////////////////////
public void setup(){

	size(800,480,P2D);

	n = new Neuron[500];

	for(int i = 0;i<n.length;i++)
		n[i] = new Neuron(i,random(width),random(height));


	for(int i = 0;i<n.length;i++)
		n[i].makeSynapse();

	rectMode(CENTER);

        for(int i = 0;i<n[0].s.length;i++)
	n[0].makeSignal(i);
	//n[1].makeSignal(0);
	//n[2].makeSignal(0);

	background(0);

}

////////////////////////////////////////////////////////
public void mousePressed(){
  
  for(int i = 0;i<n.length;i++){
		n[i].x = random(width);
        		n[i].y = random(height);
  }
  
	for(int i = 0;i<n.length;i++)
		n[i].makeSynapse();

        for(int i = 0;i<n[0].s.length;i++)
	n[0].makeSignal(i);
  
}

////////////////////////////////////////////////////////
public void draw(){
	//background(255);

	pushStyle();
	fill(11,50);
	stroke(0,190);
	strokeWeight(20);
	rect(width/2,height/2,width,height);
	popStyle();

	pushMatrix();

	scale(1);

	for(int i = 0;i<n.length;i++)
		n[i].draw();


	popMatrix();

	if (render){
		saveFrame("out/neuro####.png");
		println(frameCount);
	}

}


/////////////////////////////////////////////////////////
class  Neuron{
	int id;
	float x,y,val,xx,yy;
	float radius = 60.0f;

	Synapse s[];
	Signal sig[];

	Neuron(int _id,float _x,float _y){
		val = random(255);
		id=_id;
		xx = x=_x;
		yy = y=_y;
	}

	public void makeSynapse(){
		s = new Synapse[0];
		sig = new Signal[0];

		for(int i = 0;i<n.length;i++){
			if(i!=id && dist(x,y,n[i].x,n[i].y)<=radius&&noise(i/100.0f)<0.8f){
				s = (Synapse[])expand(s,s.length+1);
				s[s.length-1] = new Synapse(id,i);

				sig = (Signal[])expand(sig,sig.length+1);
				sig[sig.length-1] = new Signal(s[s.length-1]);

			}
		}
	}



	public void makeSignal(int which){
		int i = which;
		sig[i].x = xx;
		sig[i].y = yy;
		sig[i].running = true;
	}




	public void drawSynapse(){
		if(sig.length>0){
			for(int i = 0;i<sig.length;i+=1){
				if(sig[i].running){
					pushStyle();
					strokeWeight(3);
					stroke(255,90);
					noFill();
					line(sig[i].x,sig[i].y,sig[i].lx,sig[i].ly);
					popStyle();
					sig[i].step();
				}
			}
		}


		//stroke(#ffcc11,3);
		stroke(lerpColor(0xffffcc11,0xffffffff,norm(val,0,255)),4);
		for(int i = 0;i<s.length;i+=1){
			line(n[s[i].B].xx,n[s[i].B].yy,xx,yy);
		}
	}

	public void draw(){
		drawSynapse();
		xx += (x-xx) / 10.0f;
		yy += (y-yy) / 10.0f;
		//move();
	}

	public void move(){
		x+=(noise(id+frameCount/10.0f)-.5f);
		y+=(noise(id*5+frameCount/10.0f)-.5f);
	}

}


///////////////////////////////////////////////////////
class Synapse{

	float weight = 1.5f;
	int A,B;

	Synapse(int _A, int _B){

		A=_A;
		B=_B;

		weight = random(101,1100)/300.9f;
	}

}

//////////////////////////////////////////////////////////
class Signal{

	Synapse base;
	int cyc = 0;
	float x,y,lx,ly;
	float speed = 10.1f;

	boolean running = false;
	boolean visible = true;

	int deadnum = 200;
	int deadcount = 0;

	Signal(Synapse _base){
		deadnum = (int)random(2,400);
		base = _base;
		lx = x = n[base.A].x;
		ly = y = n[base.A].y;
		speed *= base.weight;
	}

	public void step(){
		running = true;

		lx = x;
		ly = y;

		x += (n[base.B].xx-x) / speed;//(speed+(dist(n[base.A].x,n[base.A].y,n[base.B].x,n[base.B].y)+1)/100.0);
		y += (n[base.B].yy-y) / speed;//(speed+(dist(n[base.A].x,n[base.A].y,n[base.B].x,n[base.B].y)+1)/100.0);



		if(dist(x,y,n[base.B].x,n[base.B].y)<1.0f){

			if(deadcount<0){
				deadcount = deadnum;

				for(int i = 0;i<10;i++){
					fill(255,10);
					ellipse(x,y,1.5f*i,1.5f*i);
				}

				//deadnum += (int)random(-1,1);
				//println("run "+base.A+" : "+base.B);

				running = false;
				for(int i = 0; i < n[base.B].s.length;i++){
					if(!n[base.B].sig[i].running && base.A!=n[base.B].sig[i].base.B){
						n[base.B].makeSignal(i);
						n[base.B].sig[i].base.weight += (base.weight-n[base.B].sig[i].base.weight)/((dist(x,y,n[base.A].xx,n[base.A].yy)+1.0f)/200.0f);
					}

				}


				//base.weight = random(1001,3000) / 1000.0;

				n[base.A].xx+=((n[base.B].x-n[base.A].x)/1.1f)*noise((frameCount+n[base.A].id)/11.0f);;
				n[base.A].yy+=((n[base.B].y-n[base.A].y)/1.1f)*noise((frameCount+n[base.A].id)/10.0f);



				n[base.A].xx-=((n[base.B].x-n[base.A].x)/1.1f)*noise((frameCount+n[base.B].id)/10.0f);;
				n[base.A].yy-=((n[base.B].y-n[base.A].y)/1.1f)*noise((frameCount+n[base.B].id)/11.0f);

				lx = n[base.A].xx;
				ly = n[base.A].yy;

				n[base.A].val+=(n[base.B].val-n[base.A].val)/5.0f;
			}else{

				deadcount--;
			}
		}
	}
}




  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P211_NeronsParallerComposition" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
