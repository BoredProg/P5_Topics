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
    float r2 = 20.0;
    float th  = 0.0;
    float dth = 360.0/(res) ;
    
    points = new Vec3D[res][res2];
    normals = new Vec3D[res][res2];

    for (int i=0 ; i<res ; i++)
    {
      A = getPointAt(th);
      b = getTangentBasis(th);
      
      transfo.identity();
      transfo.translateSelf(A.x,A.y,A.z);
      
      basisM.set(
                      b[0], b[3], b[6], 0.0,
                      b[1], b[4], b[7], 0.0,
                      b[2], b[5], b[8], 0.0,
                      0.0,  0.0, 0.0, 1.0
        );

      transfo.multiplySelf(basisM);


      points[i] = new Vec3D[res2];      
      normals[i] = new Vec3D[res2];

      Vec3D A2 = new Vec3D(A.x,A.y,A.z);

      float a = 0.0f;
      for (int j=0; j<res2; j++)
      {
        points[i][j] = transfo.applyTo( new Vec3D( r2*cos(a), r2*sin(a), 0.0 ) );
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
  PVector getPointAt(float th)
  {
    PVector p = new PVector();
    float   rA	= 0.5*(2.0+sin(radians(Q*th)));
    p.x	= R*rA*cos(radians(P*th));
    p.y	= R*rA*cos(radians(Q*th));
    p.z	= R*rA*sin(radians(P*th));

    return p;
  }

  PVector getTangentAt(float th)
  {
    float dth = 360.0 / 10000.0f;

    PVector A = this.getPointAt(th);
    PVector B = this.getPointAt(th+dth);
    PVector T = new PVector(B.x - A.x, B.y - A.y, B.z - A.z);
    
    T.normalize();

    return T;
  }

  float[] getTangentBasis(float th)
  {
    float[] b = new float[9];
    float dth = 360.0/10000.0;

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

