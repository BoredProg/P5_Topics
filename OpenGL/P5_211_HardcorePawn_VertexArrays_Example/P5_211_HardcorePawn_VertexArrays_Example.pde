import processing.opengl.*;
import java.nio.*;
import javax.media.opengl.*;

import javax.media.opengl.*;
import com.jogamp.opengl.util.gl2.GLUT;
import java.util.*;
PJOGL pgl;
GL2 gl;
GLUT glut;


float[] xyz;
float[] rgb;
FloatBuffer f;
FloatBuffer c;
Random r;
float[] bp;
PFont font;
boolean centered=true;

void setup()
{
  size(1024,768,OPENGL);
  font=createFont("Verdana",14);
  textFont(font,14);
//  hint(ENABLE_OPENGL_4X_SMOOTH);
  xyz=new float[3*2000000];
  rgb=new float[xyz.length/3*4];
  r=new Random();
  generate();
  fill(0);
  noStroke();
}

void draw()
{
  background(255);
  pushMatrix();
  translate(width/2,height/2,400);
  rotateX((mouseY-height/2)/((float)height/2.0));
  rotateX(-PI/6.0);
  rotateY(frameCount/300.0);
 
  //gl=((PGraphicsOpenGL)g).beginGL();
 pgl = (PJOGL)beginPGL();
  gl = pgl.gl.getGL2();
 
  gl.glColor4f(1,.5,.25,0.05);


//  gl.glEnable(GL2.GL_FOG);
//  gl.glFogi(GL2.GL_FOG_MODE, GL2.GL_LINEAR);
//  gl.glFogfv(GL2.GL_FOG_COLOR, new float[]{0,0,0,1},0);
////  gl.glFogf(GL.GL_FOG_DENSITY, 1);
//  gl.glFogf(GL2.GL_FOG_START,300.0);
//  gl.glFogf(GL2.GL_FOG_END,350.0);
  
  
/*  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);*/
  
  gl.glPointSize(2.0);
  gl.glEnable(GL2.GL_POINT_SMOOTH);


//  gl.glDepthMask(false);
  //gl.glDisable(GL.GL_DEPTH_TEST);
  
  
  gl.glEnableClientState(GL2.GL_VERTEX_ARRAY);
  gl.glEnableClientState(GL2.GL_COLOR_ARRAY);
  gl.glVertexPointer(3,GL2.GL_FLOAT,0,f);
  gl.glColorPointer(4,GL2.GL_FLOAT,0,c);
  gl.glDrawArrays(GL2.GL_POINTS,0,f.capacity()/3);  
  gl.glDisableClientState(GL2.GL_VERTEX_ARRAY);
  
  endPGL();
  popMatrix();
  text("Press 'm' to change mode",10,height-30);
  text("Click to generate new shape",10,height-15);
}

void mouseReleased()
{
  generate();
}

void generate()
{
  bp=new float[12];
  for(int i=0;i<12;i++)
  {
    bp[i]=random(-150,150);
  }
  float s=(float)r.nextGaussian()*5;
  float spread=(float)r.nextGaussian();
  for(int i=0;i<xyz.length/3;i++)
  {
    float t=(float)r.nextGaussian();
    float neg=1.0;
    if(t<0) neg=-1.0;
    t/=3.0;
    if(t<0) t=-t;
    t=constrain(t,0,1);
    float tmp=(float)r.nextGaussian()*spread;
/*    float x=bezierPoint(0,50,120,0,t);
    float z=bezierPoint(0,-60,100,100,t); */
    float x,y,z;
    if(centered)
    {
      x=bezierPoint(0,0,bp[2],bp[3],t);
      z=bezierPoint(0,0,bp[6],bp[7],t);
      y=bezierPoint(0,0,bp[10],bp[11],t);
    }
    else
    {
      x=bezierPoint(bp[0],bp[1],bp[2],bp[3],t);
      z=bezierPoint(bp[4],bp[5],bp[6],bp[7],t);
      y=bezierPoint(bp[8],bp[9],bp[10],bp[11],t);
    }
    x+=(float)r.nextGaussian()*((s*tmp)-(t*(s*tmp)));
    z+=(float)r.nextGaussian()*((s*tmp)-(t*(s*tmp)));
    y+=(float)r.nextGaussian()*((s*tmp)-(t*(s*tmp)));
    if(r.nextBoolean())
      x=-x;
    if(r.nextBoolean())
      y=-y;
    if(r.nextBoolean())
      z=-z;
    xyz[i*3]=x*neg;
    xyz[i*3+1]=y*neg;
    xyz[i*3+2]=z*neg;
    int j=i*3;
    float v=sqrt(xyz[j]*xyz[j]+xyz[j+1]*xyz[j+1]+xyz[j+2]*xyz[j+2]);
    rgb[i*4]=1-v/240.0;
    rgb[i*4+1]=0.6;
    rgb[i*4+2]=0.2+v/120.0;
    /*
    rgb[i*4]=0;
    rgb[i*4+1]=0;
    rgb[i*4+2]=0;*/
    
    rgb[i*4+3]=0.075;
  }
  f = ByteBuffer.allocateDirect(4 * xyz.length).order(ByteOrder.nativeOrder()).asFloatBuffer();
  f.put(xyz);
  f.rewind();
  c = ByteBuffer.allocateDirect(4 * rgb.length).order(ByteOrder.nativeOrder()).asFloatBuffer();
  c.put(rgb);
  c.rewind();
}

void keyReleased()
{
  if(key=='m')
  {
    centered=!centered;
    generate();
  }
}
