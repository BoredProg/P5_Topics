import processing.opengl.*;
import processing.core.*;

import toxi.geom.Vec3D;

import javax.media.opengl.GL;


import javax.media.opengl.*;
import javax.media.opengl.glu.GLU;
import com.jogamp.opengl.util.gl2.GLUT;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

 
PJOGL pgl;
GL2 gl;


Boolean lightingEnabled	= true;
float[] lightAmbient	= {   0.1f, 0.1f, 0.1f, 1.0f };
float[] lightDiffuse	= {   0.7f, 0.7f, 0.7f, 1.0f };
float[] lightSpecular	= {   0.5f, 0.5f, 0.5f, 1.0f };
float[] lightPosition	= {   -1.5f, 1.0f, -4.0f, 1.0f };

float sinLUT[];
float cosLUT[];

float SINCOS_PRECISION = 1.0f;
int SINCOS_LENGTH= (int)(360.0/SINCOS_PRECISION);

ArcBar[] arcBars;

void setup() 
{
  size( 1280, 720, P3D );
  smooth();
  colorMode( RGB, 1.0f );
  
  initLookUpTables();
  initOpenGL();
  initArcBars();
}


////////////////////////////////////////////
// INIT.
////////////////////////////////////////////

void initLookUpTables ()
{
  sinLUT = new float[SINCOS_LENGTH];
  cosLUT = new float[SINCOS_LENGTH];
  for (int i = 0; i < SINCOS_LENGTH; i++)
  {
    sinLUT[i]= (float)Math.sin( i * DEG_TO_RAD * SINCOS_PRECISION );
    cosLUT[i]= (float)Math.cos( i * DEG_TO_RAD * SINCOS_PRECISION );
  }
}








///////////////////////////////////////////////////////////////////////////////////////////////////
// DRAW.
///////////////////////////////////////////////////////////////////////////////////////////////////

void draw() 
{
  
  
  background( 0.4f ); // greyish.

  gl.glPushMatrix();
  gl.glTranslatef(width/2, height/2 , -( height / 2.0f ) / PApplet.tan( PApplet.PI * 60 /360.0f ));
  
  gl.glRotatef( -45 +  mouseY /2f , 1, 0, 0 ); 
  
  drawArcBars();

  gl.glPopMatrix();
  endPGL();
 
}



private void drawArcBars ()
{
  for( int i=0; i<arcBars.length; i++ )
  {
    arcBars[ i ].update();
    arcBars[ i ].render();
  }
}



/////////////////////////////////////////////////////////
// Init Arc Bars
/////////////////////////////////////////////////////////
void initArcBars ()
{
  int arcsTotal   = 8;
  float arcLocZ     = -150;//-600;  //--> position of the arc in the z axis 
  
  float arcLocZInc  = 15;
  
  float arcHeight   = 10;
  
  float arcAngleMin = 10;
  float arcAngleMax = 360;

  float arcRadiusMin  = 50;
  float arcRadiusMax  = 400;
  
  float arcWidthMin = 5;
  float arcWidthMax = 200;
  
  ArcBar arcBar;
  int i;
  
  // Creates the ArcBar Array..
  arcBars = new ArcBar[ arcsTotal ];

  // For each ArcBar, init values..
  for( i=0; i<arcsTotal; i++ )
  {
    arcBars[ i ]  = arcBar = new ArcBar( );
        
    arcBar.loc.z  = arcLocZ;
    arcBar.height = arcHeight;


    arcBar.radius = random( arcRadiusMin, arcRadiusMax );
    arcBar.width  = random( arcWidthMin, arcWidthMax );
    arcBar.angle  = random( arcAngleMin, arcAngleMax );
    arcBar.rz   = random( 360 );

    if( random( 1 ) < 0.5f )
    {
      arcBar.colour[ 0 ] = random(0.12f);
      arcBar.colour[ 1 ] = random(0.6f);
      arcBar.colour[ 2 ] = random(0.64f);

      arcBar.setRotateClockWise(true);
    }
    else
    {
      arcBar.colour[ 0 ] = random(0.6f);
      arcBar.colour[ 1 ] = random(0.05f);
      arcBar.colour[ 2 ] = random(1.0f);

      arcBar.setRotateClockWise(false);
    }

    arcLocZ += arcLocZInc;
  }
}



///////////////////////////////////////////////////////////////////////////////////////////
//
// ARC BAR CLASS.
//
///////////////////////////////////////////////////////////////////////////////////////////

/**
* ArcBar
*/
public class ArcBar
{
  Vec3D loc	= new Vec3D();
   
  float rx	= 0;
  float ry	= 0;
  float rz	= 0;
 
  float[] colour = { 1, 1, 1, 1   };

  float angle		= 200;
  float radius	= 300;
  float width		= 50;
  float height	= 50;


  float normLength = 200;

  Boolean drawQuads	  = true;
  Boolean drawNormals = false;


  private Vec3D     _location = new Vec3D();

  private float     _radiusMin;
  private float     _radiusMax;

  private float     _angleMin;
  private float     _angleMax;

  private float     _height;
  private float     _width;

  private float     _rotationSpeed = 1;
  private float     _scale = 1f;

  private Boolean   _rotateClockWise = false;





  public ArcBar ()
  {
    rx = random( 2 * PI );
    ry = random( 2 * PI );
    rz = random( 2 * PI );
  }

  public ArcBar (float rx, float ry, float rz)
  {
    this.rx = rx;
    this.ry = ry;
    this.rz = rz;
  }

  public ArcBar (float rx, float ry, float rz, float cr, float cg, float cb )
  {
    this.rx = rx;
    this.ry = ry;
    this.rz = rz;

    colour[ 0 ] = cr;
    colour[ 1 ] = cg;
    colour[ 2 ] = cb;
  }

    public void ArcBar(float radiusMin, float radiusMax, float height, float angle, float rotationSpeed)
    {
        
    }


  public void update ()
  {
    //rx += _rotationSpeed;
    //ry += _rotationSpeed;
    rz += _rotationSpeed;
  }

  


  /////////////////////////////////////////////////////////////////////////////////////////////////


  public void render ()
  {
    float x1, y1, x2, y2;
    float px1, py1, px2, py2;
    Vec3D vtemp, ntemp, n1, n2;
    Vec3D[] vtemps;
    int ang;
    int i, j;

    // init values..
    x1  = y1  = x2  = y2  = 0;
    px1 = py1 = px2 = py2 = 0;
    n1  = n2  = new Vec3D();
    
    ang = (int)min( angle / SINCOS_PRECISION, SINCOS_LENGTH - 1 );


    gl.glPushMatrix();
    gl.glTranslatef( loc.x, loc.y, loc.z );
    
    //--> Handles rotation around center.
    int rotationDirection = (getRotateClockWise() ? 1 : - 1);

    gl.glRotatef( rz * rotationDirection, 0, 0, 1 );  
    
    

    for( i = 0; i < ang; i++ ) 
    {
      x1 = cosLUT[i] * ( radius );
      y1 = sinLUT[i] * ( radius );

      x2 = cosLUT[i] * ( radius + width );
      y2 = sinLUT[i] * ( radius + width );

      // normal pointing inwards.
      n1 = new Vec3D( 1, 0, 0 );
      n1 = n1.rotateAroundAxis( Vec3D.Z_AXIS, i * DEG_TO_RAD );

      if( drawQuads )
      {
        gl.glBegin( GL2.GL_QUADS );

        gl.glMaterialfv( GL2.GL_FRONT, GL2.GL_AMBIENT_AND_DIFFUSE, colour, 0 );

        if( ( i == 0 ) || ( i == ( ang - 1 ) ) )
        {
          // draw end faces.
          ntemp = new Vec3D( 0, -1, 0 );
          ntemp = ntemp.rotateAroundAxis( Vec3D.Z_AXIS.copy(), i * DEG_TO_RAD );
          if( i == ( ang - 1 ) )
          {
            ntemp.invert();
          }

          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( x1, y1, 0 );
          gl.glVertex3f( x2, y2, 0 );
          gl.glVertex3f( x2, y2, height );
          gl.glVertex3f( x1, y1, height );
        }

        if( i != 0 )
        {
          // draw inner faces.
          ntemp = n1.copy().invert();
          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( x1, y1, 0 );

          ntemp = n2.copy().invert();
          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( px1, py1, 0 );
          gl.glVertex3f( px1, py1, height );

          ntemp = n1.copy().invert();
          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( x1, y1, height );

          // draw outer faces.
          ntemp = n1.copy();
          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( x2, y2, 0 );

          ntemp = n2.copy();
          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( px2, py2, 0 );
          gl.glVertex3f( px2, py2, height );

          ntemp = n1.copy();
          gl.glNormal3f( ntemp.x, ntemp.y, ntemp.z );
          gl.glVertex3f( x2, y2, height );

          // draw bottom faces.
          gl.glNormal3f( 0, 0, -1 );
          gl.glVertex3f( x1, y1, 0 );
          gl.glVertex3f( px1, py1, 0 );
          gl.glVertex3f( px2, py2, 0 );
          gl.glVertex3f( x2, y2, 0 );

          // draw top faces.
          gl.glNormal3f( 0, 0, 1 );
          gl.glVertex3f( x1, y1, height );
          gl.glVertex3f( px1, py1, height );
          gl.glVertex3f( px2, py2, height );
          gl.glVertex3f( x2, y2, height );
        }

        gl.glEnd();
      }


      // Normals drawing... not used for the moment..
      if( drawNormals )
      {
        gl.glBegin( GL2.GL_LINES );

        if( ( i == 0 ) || ( i == ( ang - 1 ) ) )
        {
          ntemp = new Vec3D( 0, -1, 0 );
          ntemp = ntemp.rotateAroundAxis( Vec3D.Z_AXIS.copy(), i * DEG_TO_RAD );
          if( i == ( ang - 1 ) )
          {
            ntemp.invert();
          }
          vtemps		= new Vec3D[ 4 ];
          vtemps[ 0 ]	= new Vec3D( x1, y1, 0 );
          vtemps[ 1 ]	= new Vec3D( x2, y2, 0 );
          vtemps[ 2 ]	= new Vec3D( x2, y2, height );
          vtemps[ 3 ]	= new Vec3D( x1, y1, height );

          for( j=0; j<vtemps.length; j++ )
          {
            vtemp = vtemps[ j ];

            gl.glVertex3f( vtemp.x, vtemp.y, vtemp.z );
            gl.glVertex3f
              (
            vtemp.x + ntemp.x * normLength,
            vtemp.y + ntemp.y * normLength, 
            vtemp.z + ntemp.z * normLength
              );
          }
        }

        if( ( i != 0 ) && ( i % 20 == 0 ) )
        {
          // draw inner face normals.
          ntemp		= n1.copy().invert();
          vtemps		= new Vec3D[ 4 ];
          vtemps[ 0 ]	= new Vec3D( x1, y1, 0 );
          vtemps[ 1 ]	= new Vec3D( px1, py1, 0 );
          vtemps[ 2 ]	= new Vec3D( px1, py1, height );
          vtemps[ 3 ]	= new Vec3D( x1, y1, height );

          for( j=0; j<vtemps.length; j++ )
          {
            vtemp = vtemps[ j ];

            gl.glVertex3f( vtemp.x, vtemp.y, vtemp.z );
            gl.glVertex3f
              (
            vtemp.x + ntemp.x * normLength,
            vtemp.y + ntemp.y * normLength, 
            vtemp.z + ntemp.z * normLength
              );
          }

          // draw outer face normals.
          ntemp		= n1.copy();
          vtemps		= new Vec3D[ 4 ];
          vtemps[ 0 ]	= new Vec3D( x2, y2, 0 );
          vtemps[ 1 ]	= new Vec3D( px2, py2, 0 );
          vtemps[ 2 ]	= new Vec3D( px2, py2, height );
          vtemps[ 3 ]	= new Vec3D( x2, y2, height );

          for( j=0; j<vtemps.length; j++ )
          {
            vtemp = vtemps[ j ];

            gl.glVertex3f( vtemp.x, vtemp.y, vtemp.z );
            gl.glVertex3f
              (
            vtemp.x + ntemp.x * normLength,
            vtemp.y + ntemp.y * normLength, 
            vtemp.z + ntemp.z * normLength
              );
          }

          // draw bottom face normals.
          ntemp		= new Vec3D( 0, 0, -1 );
          vtemps		= new Vec3D[ 4 ];
          vtemps[ 0 ]	= new Vec3D( x1, y1, 0 );
          vtemps[ 1 ]	= new Vec3D( px1, py1, 0 );
          vtemps[ 2 ]	= new Vec3D( px2, py2, 0 );
          vtemps[ 3 ]	= new Vec3D( x2, y2, 0 );

          for( j=0; j<vtemps.length; j++ )
          {
            vtemp = vtemps[ j ];

            gl.glVertex3f( vtemp.x, vtemp.y, vtemp.z );
            gl.glVertex3f
              (
            vtemp.x + ntemp.x * normLength,
            vtemp.y + ntemp.y * normLength, 
            vtemp.z + ntemp.z * normLength
              );
          }

          // draw top face normals.
          ntemp		= new Vec3D( 0, 0, 1 );
          vtemps		= new Vec3D[ 4 ];
          vtemps[ 0 ]	= new Vec3D( x1, y1, height );
          vtemps[ 1 ]	= new Vec3D( px1, py1, height );
          vtemps[ 2 ]	= new Vec3D( px2, py2, height );
          vtemps[ 3 ]	= new Vec3D( x2, y2, height );

          for( j=0; j<vtemps.length; j++ )
          {
            vtemp = vtemps[ j ];

            gl.glVertex3f( vtemp.x, vtemp.y, vtemp.z );
            gl.glVertex3f
              (
            vtemp.x + ntemp.x * normLength,
            vtemp.y + ntemp.y * normLength, 
            vtemp.z + ntemp.z * normLength
              );
          }
        }

        gl.glEnd();
      }

      px1 = x1;
      py1 = y1;
      px2 = x2;
      py2 = y2;
      n2  = n1;
    }

    gl.glPopMatrix();
  }




  /////////////////////////////////////////////////////////////////////////////////////////////////
  // SEB TEMP 

 

  /*****************************************
  * RadiusMin  
  ******************************************/

  public void setRadiusMin(float val)
  {
    _radiusMin = val;
  }

  public float getRadiusMin()
  {
    return _radiusMin;
  }


  /*****************************************
  * RadiusMax  
  ******************************************/

  public void setRadiusMax(float val)
  {
    _radiusMax = val;    
  }

  public float getRadiusMax()
  {
    return _radiusMax;
  }


  /*****************************************
  * AngleMin  
  ******************************************/

  public void setAngleMin(float val)
  {
    _angleMin = val;
  }

  public float getAngleMin()
  {
    return _angleMin;
  }


  /*****************************************
  * AngleMax  
  ******************************************/

  public void setAngleMax(float val)
  {
    _angleMax = val;    
  }

  public float getAngleMax()
  {
    return _angleMax;
  }


  /*****************************************
  * Height  
  ******************************************/
  private void setHeight(float val)
  {
    _height = val;
  }

  private float getHeight()
  {
    return _height;
  }


 /*****************************************
  * Width  
  ******************************************/
  private void setWidth(float val)
  {
    _width = val;
  }

  private float getWidth()
  {
    return _width;
  }


/*****************************************
  * Rotation Speed  
  ******************************************/
  private void setRotationSpeed(float val)
  {
    _rotationSpeed = val;
  }

  private float getRotationSpeed()
  {
    return _rotationSpeed;
  }

  
  
  /***************************************************
  * Rotation direction  (clockwise or anti-clockwise)
  ****************************************************/
  private void setRotateClockWise(Boolean val)
  {
    _rotateClockWise = val;
  }

  private Boolean getRotateClockWise()
  {
    return _rotateClockWise;
  }
  






}     // End ArcBar class	




void initOpenGL ()
{
  pgl = (PJOGL)beginPGL();
  gl = GLU.getCurrentGL().getGL2();
  
  gl.setSwapInterval( 1 );

  gl.glShadeModel( GL2.GL_SMOOTH );                       // Enable Smooth Shading
  gl.glClearColor( 0.0f, 0.0f, 0.0f, 0.5f );            // Black Background
  gl.glClearDepth( 1.0f );                    // Depth Buffer Setup
  gl.glEnable( GL2.GL_DEPTH_TEST );               // Enables Depth Testing
  gl.glDepthFunc( GL2.GL_LEQUAL );                  // The Type Of Depth Testing To Do
  gl.glHint( GL2.GL_PERSPECTIVE_CORRECTION_HINT, GL2.GL_NICEST ); // Really Nice Perspective Calculations
  gl.glDisable( GL2.GL_TEXTURE_2D );

  // Set up lighting
  gl.glLightfv( GL2.GL_LIGHT1, GL2.GL_AMBIENT, lightAmbient, 0 );
  gl.glLightfv( GL2.GL_LIGHT1, GL2.GL_DIFFUSE, lightDiffuse, 0 );
  //     gl.glLightfv( GL2.GL_LIGHT1, GL2.GL_SPECULAR, lightSpecular, 0 );
  gl.glLightfv( GL2.GL_LIGHT1, GL2.GL_POSITION, lightPosition, 0 );
  gl.glEnable( GL2.GL_LIGHTING );
  gl.glEnable( GL2.GL_LIGHT1 );
}



////////////////////////////////////////////
// HANDLERS.
////////////////////////////////////////////

void keyPressed()
{
  if( key == 'l' )
  {
    lightingEnabled = !lightingEnabled;
  }

 
}

void mousePressed()
{
  initArcBars();
}