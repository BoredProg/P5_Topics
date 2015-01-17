public void drawGlCube()
{
  gl.glBegin(GL2.GL_QUADS);

  gl.glNormal3f(0,0,-1);

  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-1,1,-1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-1,-1,-1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(1,-1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(1,1,-1);


  gl.glNormal3f(1,0,0);  
  gl.glVertexAttrib3f(tangentLoc,0,0,1);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);

  gl.glTexCoord2f(1,1);
  gl.glVertex3f(1,-1,1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(1,1,1);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(1,1,-1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(1,-1,-1);

  gl.glNormal3f(0,0,1);
  gl.glVertexAttrib3f(tangentLoc,-1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);

  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-1,-1,1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-1,1,1);
  gl.glTexCoord2f(0,0);
  gl.glVertex3f(1,1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(1,-1,1);


  gl.glNormal3f(-1,0,0);
  gl.glVertexAttrib3f(tangentLoc,0,0,-1);
  gl.glVertexAttrib3f(binormalLoc,0,-1,0);

  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-1,1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-1,-1,1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-1,-1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-1,1,-1);


  gl.glNormal3f(0,1,0);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,0,-1);

  gl.glTexCoord2f(0,0);
  gl.glVertex3f(1,1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(-1,1,1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(-1,1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(1,1,-1);


  gl.glNormal3f(0,-1,0);
  gl.glVertexAttrib3f(tangentLoc,1,0,0);
  gl.glVertexAttrib3f(binormalLoc,0,0,-1);

  gl.glTexCoord2f(0,0);
  gl.glVertex3f(-1,-1,1);
  gl.glTexCoord2f(0,1);
  gl.glVertex3f(1,-1,1);
  gl.glTexCoord2f(1,1);
  gl.glVertex3f(1,-1,-1);
  gl.glTexCoord2f(1,0);
  gl.glVertex3f(-1,-1,-1);

  gl.glEnd();
}


void drawLine3D(PVector pv1, PVector pv2, float weight, color _color)
{
 PVector v1 = new PVector(pv2.x - pv1.x, pv2.y - pv1.y, pv2.z - pv1.z);
 
 float rho = sqrt(pow(v1.x, 2) + pow(v1.y, 2) + pow(v1.z, 2));
 float phi = acos(v1.z / rho);
 float the = atan2(v1.y, v1.x);
 
 v1.mult(0.5);      
 
 float zval = pv1.dist(pv2) * 0.5;  
 float rad = radians(120) * weight * 0.5;
   
 gl.glPushMatrix();
   gl.glTranslatef(pv1.x, pv1.y, pv1.z);
   gl.glTranslatef(v1.x, v1.y, v1.z);
   gl.glRotatef(degrees(the), 0, 0, 1);
   gl.glRotatef(degrees(phi), 0, 1, 0);
   gl.glColor4f(red(_color)/255, green(_color)/255, blue(_color)/255, 0.67);
   
   //DRAW THE 3D 'LINE' (with 3 planes)  
   gl.glBegin(GL2.GL_QUADS);
     //1
     gl.glVertex3f( rad, -rad,  zval);
     gl.glVertex3f( rad, -rad, -zval);
     gl.glVertex3f(-rad, -rad, -zval);
     gl.glVertex3f(-rad, -rad,  zval);      
     //2
     gl.glVertex3f(-rad, -rad,  zval);
     gl.glVertex3f(-rad, -rad, -zval);
     gl.glVertex3f(   0,  rad, -zval);
     gl.glVertex3f(   0,  rad,  zval);
     //3
     gl.glVertex3f(   0,  rad,  zval);
     gl.glVertex3f(   0,  rad, -zval);
     gl.glVertex3f( rad, -rad, -zval);
     gl.glVertex3f( rad, -rad,  zval);
   gl.glEnd();
   
 gl.glPopMatrix();
   
}



public PShape createCan(/* float r, float h, int detail */) 
{
  
  float r = 80;
  float h = 80;
  int detail = 128; 
  
  
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  
  
  
  for (int i = 0; i <= detail; i++) 
  {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
  
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
};

  public void drawCanGL()
{
  float r = 200;    // radius
  float h = 300;    // height
  int detail = 128; 
  
  gl.glBegin(GL2.GL_QUAD_STRIP);
  
  for (int i = 0; i <= detail; i++) 
  {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    
    //sh.normal(x, 0, z);
    gl.glNormal3f(x, 0, z);
       
    //sh.vertex(x * r, -h/2, z * r, u, 0);
    gl.glVertex3f(x * r,  -h/2,  z * r);
    gl.glTexCoord2f(u, 0);
     
    //sh.vertex(x * r, +h/2, z * r, u, 1);    
    gl.glVertex3f(x * r, + h/2, z * r);
    gl.glTexCoord2f(u, 1);
  }
  
  gl.glEnd();  
};













void glutShape()
{
  // Enable Texture Coord Generation For S and T ( NEW )
  gl.glEnable(GL2.GL_TEXTURE_GEN_S);
  gl.glEnable(GL2.GL_TEXTURE_GEN_T);

  /*   Set The Texture Generation Mode For S and T To Quadric Sphere Mapping (NEW)
   *  Specifies a single-valued texture generation parameter,
   *  one of   GL_OBJECT_LINEAR,      
   *           GL_EYE_LINEAR,         
   *           GL_SPHERE_MAP,
   *           GL_NORMAL_MAP, 
   *       or GL_REFLECTION_MAP.
   
   gl.glTexGeni(GL2.GL_S, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_SPHERE_MAP);
   gl.glTexGeni(GL2.GL_T, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_SPHERE_MAP);
   */
 
  gl.glTexGeni(GL2.GL_S, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_OBJECT_LINEAR);
  gl.glTexGeni(GL2.GL_T, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_OBJECT_LINEAR);

 //gl.glTexGeni(GL2.GL_S, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_EYE_LINEAR);
  //gl.glTexGeni(GL2.GL_T, GL2.GL_TEXTURE_GEN_MODE, GL2.GL_EYE_LINEAR);


  glut.glutSolidTeapot(1.0f, true);
//glut.glutSolidSphere(1,64,64);
//glut.glutSolidIcosahedron();
 

  // disable Texture Coord Generation For S and T
  gl.glDisable(GL2.GL_TEXTURE_GEN_S);
  gl.glDisable(GL2.GL_TEXTURE_GEN_T);

  //glut.glutSolidTorus(50, 100, 64, 64);

  //gl.glScalef(20,20,20);
  

}

