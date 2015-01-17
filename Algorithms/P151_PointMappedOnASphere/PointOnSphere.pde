


//---------------------------------------
class PointOnUnitSphere 
{
  
  int textureId;
  int id;
  float eulat;
  float lat,lon;

  float x,y,z;
  float vx,vy,vz,vh;
  float ax,ay,az;
  float mass;
  float damp;

  PointOnUnitSphere (int i)
  {
    id = i;
    mass = random(0.90,1.05);
    damp = random(0.93,0.98);

    setLat(0);
    setLon(0);
    vh=vx=vy=vz=0;
    ax=ay=az=0;
    eulat = 0;
    computeEuclidean();
  }

  //---------------------------------------------
  void setLatLon (float latitude, float longitude)
  {
    // assumes inputs are radians
    setLat(latitude); 
    setLon(longitude);
  }
  void setLon (float longitude)
  {
    // assumes inputs are radians
    lon = longitude % TWO_PI;
  }
  void setLat (float latitude)
  {
    // assumes inputs are radians
    lat = (latitude % PI);
    eulat = HALF_PI - lat;
  }

  void setPositionFromCorrectLatLon (float correctLatitude, float correctLongitude)
  {
    lon = correctLongitude;
    lat = correctLatitude;
    eulat = HALF_PI - correctLatitude;
    float slat = sin(eulat);
    x = cos(correctLongitude) * slat;
    y = sin(correctLongitude) * slat; 
    z = cos(eulat);

  }



  //---------------------------------------------
  void computeSpherical()
  {
    lat = HALF_PI - acos(z) ;     // phi 
    lon = atan2(y,x);  // theta
    eulat = HALF_PI - lat;
  }
  
  void computeEuclidean()
  {
    float slat = sin(eulat);
    x = cos(lon) * slat;
    y = sin(lon) * slat; 
    z = cos(eulat);
  }



  //------------------------------------------------------------
  void accumulateEuclideanForce (float fx, float fy, float fz)
  {
    ax += fx/mass;
    ay += fy/mass;
    az += fz/mass;
  }

  void updateEuclideanForces()
  {
    vx += ax;
    vy += ay;
    vz += az;
    
    vx *= damp;
    vy *= damp;
    vz *= damp;

    float px = x + vx;
    float py = y + vy;
    float pz = z + vz;
    float pr = sqrt(px*px + py*py + pz*pz);

    float lat2 = HALF_PI - acos(pz/pr);   // phi 
    float lon2 = atan2(py,px);  // theta
    lat  = lat2;
    lon  = lon2; 
    eulat = HALF_PI- lat;

    float slat = sin(eulat);
    x = (cos(lon) * slat);
    y = (sin(lon) * slat); 
    z = (cos(eulat));
  }


  void drawEllipse (float sphereR, float ellipseD)
  {
    pushMatrix();
    translate(x*sphereR,y*sphereR,z*sphereR); 
    rotateZ(lon);
    rotateY(eulat);

    ellipse(0,0,ellipseD,ellipseD);
    popMatrix();
  }


  void draw (float R, float D){
    pushMatrix();
    translate(x*R,y*R,z*R); 
    rotateZ(lon);
    rotateY(eulat);
    scale(mass/1.4f);
    image(spot,-D/2,-D/2,D,D);
    //sphereDetail(3);    
    //sphere(D/10);
    //gl.glScalef(2.0f,2.0f,2.0f);
    //gl.glScalef(20, 20, 20); 
    //gl.glCallList(sphereList);
    //gl.glScalef(1, 10, 1);    
    //scale(10,10,1);
    //box(10);
    popMatrix();
  } 
}

