import com.processinghacks.arcball.*;


import javax.media.opengl.*;
import javax.media.opengl.glu.GLU;
import processing.video.*;
import processing.opengl.*;
import noc.*;

MovieMaker mm;  

// =================================
// Textures and Ribbons ------------
PImage[] textures; 
Ribbon[] ribbons;

boolean group         = false;

int segmentHeight     = 50;    // 100
int segmentMaxWidth   = 150;    // 150

int _textureCount     = 9;    //1-12
int _ribbonCount      = 64;   // fps dictat ! 

// =================================
// CAM creation --------------------
Vector3D translations;
Vector3D rotations;
Vector3D tvelocity;
Vector3D rvelocity;
/*---------------------------------*/

PFont font;


Vector3D skyRGB =  new Vector3D(155, 134, 76) ;
int ambientDarken = 80;

boolean isMousePressed = false;

// =================================
// OpenGL creation -----------------
GL gl; 
PGraphicsOpenGL pgl;
/*--------------------------------*/


/*-------------------------------------------------------------------------*/
/* ==  SETUP  ==
/*-------------------------------------------------------------------------*/
void setup()
{  
  
  size(1280,720,OPENGL);  
  //size(3200,1100,OPENGL);  
  hint(ENABLE_OPENGL_4X_SMOOTH);

 
  // =================================
  // Camera initialization ------------  
  rotations    = new Vector3D(0,0);
  rvelocity    = new Vector3D(.1,.2);
  translations = new Vector3D(width/2.0,height/2.0,-230);
  tvelocity    = new Vector3D(0,0,0);
 
  //==================================
  // Screen Font.. 
  font = createFont("Consolas",12);
  textFont(font);
  
  
  sphereDetail(60);
  
  //frameRate(25);
  
  
  //mm= new MovieMaker(this, width, height, "MovieOutput_" + hour() + minute() + second() + ".mov",25, MovieMaker.VIDEO, MovieMaker.LOSSLESS);
  //mm = new MovieMaker(this,width,height,"p5test-###.mov", MovieMaker.VIDEO, MovieMaker.HIGH,20);
  //new ArcBall(this);

  // =================================
  // textures creation ---------------    
  textures   = new PImage[_textureCount];
  for(int i=0;i<textures.length;i++)
  {
    textures[i] = loadImage("0"+(i+1)+".jpg");
  }
  
  // =================================
  // ribbons initialization ----------
  ribbons    = new Ribbon[_ribbonCount];  
  for(int i=0;i < ribbons.length;i++)
  {
    ribbons[i] = new Ribbon();
  }

  // =================================
  // OpenGL initialization------------
   pgl = (PGraphicsOpenGL) g;
}





/*=========================================================================*/
/* ==  DRAW  :
/*=========================================================================*/
void draw()
{
  background(255);
  
  //starting OPENGL ====================
  gl = pgl.beginGL();
    
  pushMatrix();    
  
  gl.glTranslatef(translations.x, translations.y, translations.z);  
  gl.glRotatef(rotations.x, 1, 0, 0);
  gl.glRotatef(rotations.y, 0, 1, 0); 
  
  resetMatrix();
  
   
   // == Start Custom Code ==
  //substractiveBlendMode();
    
  translate(0,0,-650);
  
  gradientSkySphere(4200);
    
  setLighting();
  

  //======================================
  // Update the Ribbons...
  if(random(1f) > .995f ) 
  {
    group = !group;
  }
  
  for(int i=0; i < ribbons.length; i++ )
  {
    ribbons[i].update();
  }
 
  popMatrix();
    
  pgl.endGL();
 //ending OPENGL jedi tricks =====================*/
   
   // updates the camera.. 
   updateCam();
   
   // and shows the perf hud..
   showDebugText();
    
}


/*=========================================================================*/
/* ==  Lights 
/*=========================================================================*/
void setLighting()
{
      
  pointLight(skyRGB.x-ambientDarken, skyRGB.y -ambientDarken, skyRGB.z-ambientDarken,  -100, 0, -5000);
  pointLight(skyRGB.x-ambientDarken, skyRGB.y -ambientDarken, skyRGB.z-ambientDarken,  -100, -100, 5000);
    
  // ou..
   //ambientLight(skyRGB.x-ambientDarken, skyRGB.y -ambientDarken, skyRGB.z-ambientDarken);

}



/*=========================================================================*/
/* ==  Gradient SkySphere 
/*=========================================================================*/
void gradientSkySphere(int radius)
{
   
  spotLight(skyRGB.x, skyRGB.y,skyRGB.z, width/2, height/2, 0, 1, 1, -1, PI*.5, 2);
  spotLight(skyRGB.x, skyRGB.y,skyRGB.z,  width/2, height/2, 0, 1, -1, 1, PI*.5, 2);
  spotLight(skyRGB.x, skyRGB.y,skyRGB.z,  width/2, height/2, 0, 0, 0, 0, PI*.5, 2);
  spotLight(skyRGB.x, skyRGB.y,skyRGB.z,  width/2, height/2, 0, -1, -1, -1, PI*.5, 2);

  // sky sphere color. Comment it or set it to white
  // to get the sphere shaded by the four lights above,
  // or give it a color that will be blended..
  //fill(255,40,125);
  noStroke();
  sphere(radius);
 
}


/*=========================================================================*/
/* ==  OpenGL Blend Modes.
/*=========================================================================*/

void substractiveBlendMode()
{
  gl.glDisable(gl.GL_DEPTH_TEST);
  gl.glEnable(gl.GL_BLEND);
  //gl.glAlphaFunc(gl.GL_GEQUAL,80);
  gl.glBlendEquation(gl.GL_FUNC_REVERSE_SUBTRACT);
  gl.glBlendFunc(gl.GL_SRC_ALPHA,gl.GL_ONE);
}


 
void showDebugText()
{
  // ===== Show Debug Text
  fill(0);
  text(_ribbonCount + " processing ribbons with " + _textureCount + " segments each :  " + 2*(int) frameRate+" fps",20,20);
  text (getAntialiasSampleRate(GLU.getCurrentGL()),20,40);
  
  fill(255);  //--> Try without for a cool negative AO effect..
}



/*=========================================================================*/
/* ==  Camera Controls
/*=========================================================================*/

void rotateCam(Vector3D add)
{
  rotations.add(add);
}

void translateCam(Vector3D add)
{
  translations.add(add);
}

void updateCam()
{
  rotations.add(rvelocity);
  translations.add(tvelocity);
  tvelocity.mult(.89);
  rvelocity.mult(.998);
}



/*=========================================================================*/
/* ==  Key Controls
/*=========================================================================*/

void keyPressed()
{
  float speed = random(.05);
  
  switch(keyCode)
  {

   /*
   CAM rotations  ----------------------------------------------------------*/
  case  DOWN :
    rvelocity = new Vector3D(rvelocity.x-speed,rvelocity.y);
    break;
  case  UP :
    rvelocity = new Vector3D(rvelocity.x+speed,rvelocity.y);
    break;
  case RIGHT :
    rvelocity = new Vector3D(rvelocity.x,rvelocity.y+speed);
    break;
  case LEFT :
    rvelocity = new Vector3D(rvelocity.x,rvelocity.y-speed);
    break;
    /*-----------------------------------------------------------------------*/


   /*:
   CAM zoom  ----------------------------------------------------------------*/
  case 'q' :
    tvelocity = new Vector3D(0,0,500);
    translateCam(tvelocity);
    break;
  case 's' :
    tvelocity = new Vector3D(0,-500,-500);        
    break;
    /*
   CAM random and init pos  -------------------------------------------------*/
  case 'a' :
    translations = new Vector3D(width/2.0,height/2.0,-230);
    rotations = new Vector3D(0,0);
    break;
  case 'z' :
    translations = new Vector3D(width/2.0,height/2.0,-230);
    rotations = new Vector3D(random(360),random(360));
    break;
    /*-----------------------------------------------------------------------*/
  
  case DELETE:
    rvelocity = new Vector3D(0,0,0);
    break;
   
   case 'g':
     group = !group;
     break; 

    
   case 'D':
     //skyRGB.setXYZ((int)random(255),(int)random(255), (int)random(255)) ;
     ambientDarken++;
     break; 

   case 'd':
     //skyRGB.setXYZ((int)random(255),(int)random(255), (int)random(255)) ;
     ambientDarken--;
     break; 
    

  }
}

void mousePressed()
{
  isMousePressed = true;
}

void mouseDragged()
{
   rotations.x += ((pmouseX-mouseX)*2.5f);
}

void mouseReleased()
{
  isMousePressed = false;
}
