 /**
 * Space Junk  
 * By Ira Greenberg 
 * zoom suggestion 
 * By Danny Greenberg
 * 
 * Rotating cubes in space using
 * a custom Cube class. Color controlled 
 * by light sources.
 *
 *
 * modified to test opengl blending */

/*need to import opengl library to use OPENGL 
 rendering mode for hardware acceleration*/
import processing.opengl.*;
import javax.media.opengl.*;
import java.util.*;

//used for oveall rotation
float ang;

float _rotationSpeed=1;
//cube count-lower/raise to test P3D/OPENGL performance
int limit = 800;

//array for all cubes
Cube[]cubes = new Cube[limit];
PGraphicsOpenGL pgl;
GL gl;

nvArray GLblendL = new nvArray();
nvArray GLblendR = new nvArray();
boolean blnDisableZTest = true;

void setup(){
  //try substituting P3D for OPENGL 
  //argument to test performance
  size(1280, 1024, OPENGL); 
  hint(ENABLE_OPENGL_4X_SMOOTH) ;
  background(100+frameRate); 
  //frameRate(40);
  noStroke();
  //instantiate cubes, passing in random vals for size and postion
  for (int i = 0; i< cubes.length; i++){
    cubes[i] = new Cube(int(random(-10, 10)), int(random(-10, 10)), 
    int(random(-10, 10)), int(random(-140, 140)), int(random(-140, 140)), 
    int(random(-140, 140)));
  }

  /* setup the openGL blend enum into a name-value pair array 
   ** so that we can keep track of what we are doing         */
  GLblendL.add("GL_ZERO",GL.GL_ZERO); 	
  GLblendL.add("GL_ONE",GL.GL_ONE); 	
  GLblendL.add("GL_SRC_COLOR",GL.GL_SRC_COLOR	); 
  GLblendL.add("GL_ONE_MINUS_SRC_COLOR",GL.GL_ONE_MINUS_SRC_COLOR); 
  GLblendL.add("GL_DST_COLOR",GL.GL_DST_COLOR	); 
  GLblendL.add("GL_ONE_MINUS_DST_COLOR",GL.GL_ONE_MINUS_DST_COLOR); 	
  GLblendL.add("GL_SRC_ALPHA",GL.GL_SRC_ALPHA	); 
  GLblendL.add("GL_ONE_MINUS_SRC_ALPHA",GL.GL_ONE_MINUS_SRC_ALPHA); 	
  GLblendL.add("GL_DST_ALPHA",GL.GL_DST_ALPHA	); 
  GLblendL.add("GL_ONE_MINUS_DST_ALPHA",GL.GL_ONE_MINUS_DST_ALPHA); 	
  GLblendL.add("GL_SRC_ALPHA_SATURATE",GL.GL_SRC_ALPHA_SATURATE);  //invalid enum... wtf?	
  GLblendL.add("GL_CONSTANT_COLOR",GL.GL_CONSTANT_COLOR	); 
  GLblendL.add("GL_ONE_MINUS_CONSTANT_COLOR",GL.GL_ONE_MINUS_CONSTANT_COLOR ); 
  GLblendL.add("GL_CONSTANT_ALPHA",GL.GL_CONSTANT_ALPHA ); 
  GLblendL.add("GL_ONE_MINUS_CONSTANT_ALPHA",GL.GL_ONE_MINUS_CONSTANT_ALPHA );
  GLblendR.add("GL_ZERO",GL.GL_ZERO); 	
  GLblendR.add("GL_ONE",GL.GL_ONE); 	
  GLblendR.add("GL_SRC_COLOR",GL.GL_SRC_COLOR	); 
  GLblendR.add("GL_ONE_MINUS_SRC_COLOR",GL.GL_ONE_MINUS_SRC_COLOR); 
  GLblendR.add("GL_DST_COLOR",GL.GL_DST_COLOR	); 
  GLblendR.add("GL_ONE_MINUS_DST_COLOR",GL.GL_ONE_MINUS_DST_COLOR); 	
  GLblendR.add("GL_SRC_ALPHA",GL.GL_SRC_ALPHA	); 
  GLblendR.add("GL_ONE_MINUS_SRC_ALPHA",GL.GL_ONE_MINUS_SRC_ALPHA); 	
  GLblendR.add("GL_DST_ALPHA",GL.GL_DST_ALPHA	); 
  GLblendR.add("GL_ONE_MINUS_DST_ALPHA",GL.GL_ONE_MINUS_DST_ALPHA);
  GLblendR.add("GL_CONSTANT_COLOR",GL.GL_CONSTANT_COLOR	); 
  GLblendR.add("GL_ONE_MINUS_CONSTANT_COLOR",GL.GL_ONE_MINUS_CONSTANT_COLOR ); 
  GLblendR.add("GL_CONSTANT_ALPHA",GL.GL_CONSTANT_ALPHA ); 
  GLblendR.add("GL_ONE_MINUS_CONSTANT_ALPHA",GL.GL_ONE_MINUS_CONSTANT_ALPHA );
  println( "Blend mode : glBlendFunc( "+GLblendL.getCurrentName() +" , "+ GLblendR.getCurrentName() + " )");
  
  GLblendL.next();
    GLblendL.next();
}

void draw(){
  // *** blending setup *** //
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.beginGL();
  if( blnDisableZTest )
    gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc( GLblendL.getCurrent(), GLblendR.getCurrent() );
  pgl.endGL(); 
  // ***  end blending setup *** //

  background(0); 

  fill(200);
  //set up some different colored lights
  pointLight(51, 102, 255, 65, 60, 100); 
  pointLight(200, 40, 60, -65, -60, -150);

   pushMatrix();
   fill(255);
   translate(-65, -60, -150);
   box(10);   
   popMatrix();

  //raise overall light in scene 
  ambientLight(70, 70, 10); 

  /*center geometry in display windwow.
   you can change 3rd argument ('0')
   to move block group closer(+)/further(-)*/
  translate(width/2, height/2, -200+mouseX);

  //rotate around y and x axes
  rotateY(radians(ang));
  rotateX(radians(ang));
   
   
  //set up some different colored lights that rotate within cubes
  //pointLight(51, 102, 255, 65, 60, 100); 
  //pointLight(200, 40, 60, -65, -60, -150);
  //draw cubes
  for (int i = 0; i< cubes.length; i++){
    cubes[i].drawCube();
  }
  //used in rotate function calls above
  ang+=_rotationSpeed;
}

void keyPressed(){
  switch( key ){
  case 'e': 
    GLblendL.next(); 
    println( "Blend mode : glBlendFunc( "+GLblendL.getCurrentName() +" , "+ GLblendR.getCurrentName() + " )");
    break;
  case 'd': 
    GLblendL.prev(); 
    println( "Blend mode : glBlendFunc( "+GLblendL.getCurrentName() +" , "+ GLblendR.getCurrentName() + " )");
    break;
  case 'r': 
    GLblendR.next(); 
    println( "Blend mode : glBlendFunc( "+GLblendL.getCurrentName() +" , "+ GLblendR.getCurrentName() + " )");
    break;
  case 'f': 
    GLblendR.prev(); 
    println( "Blend mode : glBlendFunc( "+GLblendL.getCurrentName() +" , "+ GLblendR.getCurrentName() + " )");
    break;
  case 'z': 
    blnDisableZTest = (blnDisableZTest)? false : true; 
    if(blnDisableZTest)
      println( "Depth Testing Disable");
    else
      println( "Depth Testing Enabled");
    break;  
  } 

}


//simple Cube class, based on Quads
class Cube {

  //properties
  int w, h, d;
  int shiftX, shiftY, shiftZ;

  //constructor
  Cube(int w, int h, int d, int shiftX, int shiftY, int shiftZ){
    this.w = w;
    this.h = h;
    this.d = d;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
    this.shiftZ = shiftZ;
  }

  /*main cube drawing method, which looks 
   more confusing than it really is. It's 
   just a bunch of rectangles drawn for 
   each cube face*/
  void drawCube(){
    beginShape(QUADS);
    //front face
    vertex(-w/2 + shiftX, -h/2 + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, -h/2 + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, h + shiftY, -d/2 + shiftZ); 
    vertex(-w/2 + shiftX, h + shiftY, -d/2 + shiftZ); 

    //back face
    vertex(-w/2 + shiftX, -h/2 + shiftY, d + shiftZ); 
    vertex(w + shiftX, -h/2 + shiftY, d + shiftZ); 
    vertex(w + shiftX, h + shiftY, d + shiftZ); 
    vertex(-w/2 + shiftX, h + shiftY, d + shiftZ);

    //left face
    vertex(-w/2 + shiftX, -h/2 + shiftY, -d/2 + shiftZ); 
    vertex(-w/2 + shiftX, -h/2 + shiftY, d + shiftZ); 
    vertex(-w/2 + shiftX, h + shiftY, d + shiftZ); 
    vertex(-w/2 + shiftX, h + shiftY, -d/2 + shiftZ); 

    //right face
    vertex(w + shiftX, -h/2 + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, -h/2 + shiftY, d + shiftZ); 
    vertex(w + shiftX, h + shiftY, d + shiftZ); 
    vertex(w + shiftX, h + shiftY, -d/2 + shiftZ); 

    //top face
    vertex(-w/2 + shiftX, -h/2 + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, -h/2 + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, -h/2 + shiftY, d + shiftZ); 
    vertex(-w/2 + shiftX, -h/2 + shiftY, d + shiftZ); 

    //bottom face
    vertex(-w/2 + shiftX, h + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, h + shiftY, -d/2 + shiftZ); 
    vertex(w + shiftX, h + shiftY, d + shiftZ); 
    vertex(-w/2 + shiftX, h + shiftY, d + shiftZ); 

    endShape(); 

    //add some rotation to each box for pizazz.
    //rotateY(radians(1));
    //rotateX(radians(1));
    //rotateZ(radians(1));
  }
}

//this is just an int name-value pair array I wrote a while back..
//i've gutted it down to the few functions i am using in this sketch
//for the sake of minimal code. however the full version is awesome.
class nvArray {
  ArrayList name = new ArrayList();
  ArrayList val = new ArrayList();
  int length;
  int pos;

  nvArray(){
    length = 0;
    pos = 0; 
  }

  void add(String l_name, int l_val){
    length++;
    name.add( l_name );
    val.add( new Integer(l_val) ); 
  }

  void next(){
    pos = (pos+1 == length)? 0 : pos+1;
  }

  void prev(){
    pos = (pos-1 <0)? length-1 : pos-1;
  }

  int getCurrent(){
    return ( (Integer)val.get( pos ) ).intValue();
  }

  String getCurrentName(){
    return( (String)name.get( pos ) );
  }
}


 
