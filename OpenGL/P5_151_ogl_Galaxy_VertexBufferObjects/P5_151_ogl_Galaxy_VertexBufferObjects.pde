import com.processinghacks.arcball.*;

import processing.opengl.*;
import java.nio.*;
import javax.media.opengl.*;

GL gl;
float[] xyz;
float[] rgb;
FloatBuffer f;
FloatBuffer c;

void setup()
{
   new ArcBall(this);
  size(1024,768,OPENGL);
  xyz=new float[3*200000];
  rgb=new float[xyz.length/3*4];
  Random r=new Random();
  for(int i=0;i<20000;i++)
  {
    xyz[i*3]=(float)r.nextGaussian()*60.0;
    xyz[i*3+1]=(float)r.nextGaussian()*4;
    xyz[i*3+2]=(float)r.nextGaussian()*60.0;
    int j=i*3;
    float v=sqrt(xyz[j]*xyz[j]+xyz[j+1]*xyz[j+1]+xyz[j+2]*xyz[j+2]);
    rgb[i*4]=random(0.2,1);
    rgb[i*4+1]=random(0.2,0.6);
    rgb[i*4+2]=random(0.2,1);
    rgb[i*4+3]=0.075;
  }
  
  for(int i=20000;i<xyz.length/3;i++)
  {
    float t=(float)r.nextGaussian();
    float neg=1.0;
    if(t<0) neg=-1.0;
    t/=3.0;
    if(t<0) t=-t;
    t=constrain(t,0,1);
    float x=bezierPoint(0,50,120,0,t);
    float z=bezierPoint(0,-60,100,100,t);
    float y=0.0;
    x+=(float)r.nextGaussian()*10;
    z+=(float)r.nextGaussian()*10;
    y=(float)r.nextGaussian()*3;
    xyz[i*3]=x*neg;
    xyz[i*3+1]=y;
    xyz[i*3+2]=z*neg;
    int j=i*3;
    float v=sqrt(xyz[j]*xyz[j]+xyz[j+1]*xyz[j+1]+xyz[j+2]*xyz[j+2]);
    rgb[i*4]=1-v/240.0;
    rgb[i*4+1]=0.6;
    rgb[i*4+2]=0.2+v/120.0;
    rgb[i*4+3]=0.075;
  }
  f = ByteBuffer.allocateDirect(4 * xyz.length).order(ByteOrder.nativeOrder()).asFloatBuffer();
  f.put(xyz);
  f.rewind();
  c = ByteBuffer.allocateDirect(4 * rgb.length).order(ByteOrder.nativeOrder()).asFloatBuffer();
  c.put(rgb);
  c.rewind();
  
}
float distance = 400;
void draw()
{
   lights();
  background(0);
  translate(width/2,height/2,distance);
  distance +=0.3f;
//  rotateX((mouseY-height/2)/((float)height/2.0));
  rotateX(-PI/6.0);
  rotateY(frameCount/360.0);
  gl=((PGraphicsOpenGL)g).beginGL();
  gl.glColor4f(1,.5,.25,0.05);

  gl.glEnable(GL.GL_FOG);
  gl.glFogi(GL.GL_FOG_MODE, GL.GL_LINEAR);
  gl.glFogfv(GL.GL_FOG_COLOR, new float[]{0,0,0,1},0);
//  gl.glFogf(GL.GL_FOG_DENSITY, 1);
  gl.glFogf(GL.GL_FOG_START,300.0);
  gl.glFogf(GL.GL_FOG_END,350.0);
  
  
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
  
  gl.glPointSize(2.0);
  gl.glEnable(GL.GL_POINT_SMOOTH);


//  gl.glDepthMask(false);
  gl.glDisable(GL.GL_DEPTH_TEST);
  
  
  gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
  gl.glEnableClientState(GL.GL_COLOR_ARRAY);
  gl.glVertexPointer(3,GL.GL_FLOAT,0,f);
  gl.glColorPointer(4,GL.GL_FLOAT,0,c);
  gl.glDrawArrays(GL.GL_POINTS,0,f.capacity()/3);  
  gl.glDisableClientState(GL.GL_VERTEX_ARRAY);
  ((PGraphicsOpenGL)g).endGL();
}
