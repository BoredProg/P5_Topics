import com.processinghacks.arcball.*;

import processing.opengl.*;
import javax.media.opengl.*;

PGraphicsOpenGL pgl;
GL gl;

Target target[];
Boid boid[];


void setup(){
  size(3200, 1100, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  background(250);
  smooth();  
  initArrays();  
  //new ArcBall(this);
}

void initArrays()
{
   target = new Target[numT];
  for(int i=0; i<numT; i++){
    target[i] = new Target();
  }
  boid = new Boid[numBoids];
  for(int i=0; i<numBoids; i++){
    boid[i] = new Boid(target[0]);
  }
}





void draw(){
 
   setBackground();
   
   setLights();
     
   setGlow( _useGlow ); 
  
  /*
  translate(width/2, height/2,0);
  rotateY(radians(_hue));
  */
  
  for(int i=0; i<numT; i++){
    target[i].mover();    
    target[i].render();
  }
  for(int i=0; i<numBoids; i++){
    boid[i].checkDistCurrentTarget();
    boid[i].checkNearestTarget(target);
    boid[i].mover();
    boid[i].render();
  }
  println(frameRate);
}



void setGlow(boolean glow)
{
   if (glow)
       glowStuff();   //--> ca rend bien aussi sans..
}


void setBackground()
{
   background(0);
  
  //colorMode(HSB);
  //background(_hue-40,100,130);
  //colorMode(RGB);   

}



float _hue;
float _hueIncrement=1;


void setLights()
{
     // Seb : evolving light with all color spectrum
     colorMode(HSB);     
     if (frameCount % 255 ==0)
        _hueIncrement = - _hueIncrement;
     _hue += _hueIncrement;     
     pointLight(_hue,200,240,width/2, height/2, 200);   
     colorMode(RGB);
     
    // Seb : x light.
    /*
    pointLight(200,20,10,width/2, height/2, 500);
    
    pointLight(-500,20,10,0, height/2, 500);
    pointLight(-500,20,10,width, height/2, 500);
   */
  }




void keyPressed()
{
   switch(key)
   {
      case '1':
         numP++;
         initArrays();
         break;
         
      case '2':
         numP--;
         initArrays();
         break;
         
      case '3':
         larg++;
         break;
         
      case '4':
         larg--;
         break;
      
      case '5':
         pDamp+=0.01;
         break;

      case '6':
         pDamp-=0.01;
         break;


    case 'g':
         _useGlow = ! _useGlow;
         break;
      
      
      
   }
   
}











void glowStuff(){
   pgl = (PGraphicsOpenGL) g; 
  gl = pgl.beginGL(); 
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  pgl.endGL(); 
}
  

