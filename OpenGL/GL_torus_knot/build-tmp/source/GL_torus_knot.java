import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import javax.media.opengl.*; 
import codeanticode.glgraphics.*; 
import toxi.geom.*; 
import toxi.geom.mesh.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GL_torus_knot extends PApplet {

/*

 Processing Paris Masterclass 2013
 http://www.processingparis.org/2013/03/processing-paris-workshops-2013-masterclass/
 \u2014
 Julien 'v3ga' Gachadoat
 twitter.com/v3ga
 \u2014
 TorusKnot with GLModel
 \u2014
 GLGraphics 1.0.0

*/


// ----------------------------------------------------------------






GLModel modelMesh;
boolean isFilled = true;

// ----------------------------------------------------------------
public void setup()
{
  size(800,600,GLConstants.GLGRAPHICS);
  modelMesh = convertGLModel(new TorusKnot(120,2,5).mesh);
}

// ----------------------------------------------------------------
public void draw()
{
  background(0);

  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();


  translate(width/2, height/2);
  rotateX( map(mouseY,0,height,-PI,PI) );
  rotateY( map(mouseX,0,width,-PI,PI) );


  pointLight(51, 102, 126, 0, 0, 200);  
  modelMesh.render();
  
  renderer.endGL();
}

// ----------------------------------------------------------------
public GLModel convertGLModel(TriangleMesh mesh)
{
  float[] vertices=mesh.getMeshAsVertexArray();
  float[] normals=mesh.getVertexNormalsAsArray();
  int nbVertices = vertices.length/4;
  
  GLModel m = new GLModel(this, nbVertices, TRIANGLES, GLModel.STATIC);
  
  m.beginUpdateVertices();
    for (int i = 0; i < nbVertices; i++) m.updateVertex(i, vertices[4*i], vertices[4*i+1], vertices[4*i+2]);
  m.endUpdateVertices(); 
  
  m.initNormals();
  m.beginUpdateNormals();
  for (int i = 0; i < nbVertices; i++) m.updateNormal(i, normals[4 * i], normals[4 * i + 1], normals[4 * i + 2]);
  m.endUpdateNormals();  

  return m;
}

// ----------------------------------------------------------------
public void keyPressed()
{
  if (key == ' ')
    isFilled =!isFilled;
}
// --------------------------------------------------------
// TorusKnot code is dirty ... sorry.
class TorusKnot
{
  public float R,P,Q;

  TriangleMesh mesh;
  
  Vec3D points[][];
  Vec3D normals[][];

  // Constructor
  TorusKnot(float R_, float P_, float Q_)
  {
    R = R_;
    P = P_;
    Q = Q_;
    
    mesh = new TriangleMesh();

    int res = 200;
    int res2 = 30;
    
    PVector A,B;
    float[] b;
    Matrix4x4 transfo = new Matrix4x4();
    Matrix4x4 basisM = new Matrix4x4();
    float r2 = 20.0f;
    float th  = 0.0f;
    float dth = 360.0f/(res) ;
    
    points = new Vec3D[res][res2];
    normals = new Vec3D[res][res2];

    for (int i=0 ; i<res ; i++)
    {
      A = getPointAt(th);
      b = getTangentBasis(th);
      
      transfo.identity();
      transfo.translateSelf(A.x,A.y,A.z);
      
      basisM.set(
                      b[0], b[3], b[6], 0.0f,
                      b[1], b[4], b[7], 0.0f,
                      b[2], b[5], b[8], 0.0f,
                      0.0f,  0.0f, 0.0f, 1.0f
        );

      transfo.multiplySelf(basisM);


      points[i] = new Vec3D[res2];      
      normals[i] = new Vec3D[res2];

      Vec3D A2 = new Vec3D(A.x,A.y,A.z);

      float a = 0.0f;
      for (int j=0; j<res2; j++)
      {
        points[i][j] = transfo.applyTo( new Vec3D( r2*cos(a), r2*sin(a), 0.0f ) );
        normals[i][j] = points[i][j].sub(A2).normalize();

        a+=TWO_PI/(res2);
      }
      th+=dth;
    }

        Vec3D n1 = new Vec3D(), n2 = new Vec3D();

        for (int i=0;i<points.length;i++){
          
          for (int j=0;j<points[i].length;j++){
  
              n1 = ( points[i][(j+1)%res2].sub(points[i][j]) ).cross( points[(i+1)%res][j].sub(points[i][j]) );
              n2 = ( points[(i+1)%res][(j+1)%res2].sub(points[i][(j+1)%res2]) ).cross( points[(i+1)%res][j].sub(points[(i+1)%res][(j+1)%res2]) );
            
            n1 = n1.normalize();
            n2 = n2.normalize();
            
            
            mesh.addFace( points[i][j], points[i][(j+1)%res2], points[(i+1)%res][j], n1);
            mesh.addFace( points[i][(j+1)%res2], points[(i+1)%res][(j+1)%res2], points[(i+1)%res][j], n2 );
            
          }
        }
        
        mesh.computeVertexNormals();


    


  }

  // Methods
  public PVector getPointAt(float th)
  {
    PVector p = new PVector();
    float   rA	= 0.5f*(2.0f+sin(radians(Q*th)));
    p.x	= R*rA*cos(radians(P*th));
    p.y	= R*rA*cos(radians(Q*th));
    p.z	= R*rA*sin(radians(P*th));

    return p;
  }

  public PVector getTangentAt(float th)
  {
    float dth = 360.0f / 10000.0f;

    PVector A = this.getPointAt(th);
    PVector B = this.getPointAt(th+dth);
    PVector T = new PVector(B.x - A.x, B.y - A.y, B.z - A.z);
    
    T.normalize();

    return T;
  }

  public float[] getTangentBasis(float th)
  {
    float[] b = new float[9];
    float dth = 360.0f/10000.0f;

    PVector T  = new PVector();
    PVector N  = new PVector();
    PVector B_ = new PVector();

    PVector A = getPointAt(th);
    PVector B = getPointAt(th+dth);

    T.set(B.x - A.x, B.y - A.y, B.z - A.z);
    N.set(B.x + A.x, B.y + A.y, B.z + A.z);

    B_ = T.cross(N);
    N  = B_.cross(T);

    N.normalize();
    B_.normalize();
    T.normalize();

    b[0] = N.x ; 
    b[1] = N.y ; 
    b[2] = N.z ; 

    b[3] = B_.x ; 
    b[4] = B_.y ; 
    b[5] = B_.z ; 

    b[6] = T.x ;
    b[7] = T.y ;
    b[8] = T.z ;

    return b;
  }

};

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GL_torus_knot" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
