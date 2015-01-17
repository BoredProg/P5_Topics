class SphericalDistanceCalculator 
{
  // http://en.wikipedia.org/wiki/Great_circle_distance
  // http://williams.best.vwh.net/avform.htm#Crs

  LatLonPair pair; 
  SphericalDistanceCalculator (){
    pair = new LatLonPair();
  }

  float getSphericalAngleArccos (PointOnUnitSphere S, PointOnUnitSphere F){
    // Inaccurate for small distances.
    float Flat = F.lat;
    float Slat = S.lat;
    float A = cos(Slat) * cos(Flat) * cos(S.lon - F.lon);
    float B = sin(Slat) * sin(Flat);
    return (acos (A + B));
  }

  float getSphericalAngleArcsin (PointOnUnitSphere S, PointOnUnitSphere F){
    // Inaccurate for antipodal points.
    float dLat = S.lat - F.lat;
    float dLon = S.lon - F.lon;
    float A = sq(sin(dLat/2.0));
    float B = cos(S.lat) * cos(F.lat) * sq(sin(dLon/2.0));
    float dang = 2 * asin (sqrt(A + B));
    return (dang);
  }

  float getSphericalAngleArctan (PointOnUnitSphere S, PointOnUnitSphere F){
    // accurate for all cases, but CPU-heavy.
    float cLatF = cos(F.lat); 
    float sLatF = sin(F.lat); 
    float cLatS = cos(S.lat); 
    float sLatS = sin(S.lat);
    float dLon  = S.lon - F.lon;
    float sdLon = sin(dLon);
    float cdLon = cos(dLon); 

    float A = cLatF * sdLon;
    float B = cLatS * sLatF - sLatS * cLatF * cdLon;
    float C = sLatS * sLatF;
    float D = cLatS * cLatF * cdLon;

    float top = sqrt(A*A + B*B);
    float bot = C + D;
    float dang = atan2(top,bot);
    return (dang);
  } 


  LatLonPair getPointOnGreatCircle (PointOnUnitSphere S, PointOnUnitSphere F, float distance, float frac){
    float A = sin((1.0-frac)*distance)/sin(distance);
    float B = sin(frac*distance)/sin(distance);
    float acsl = A*cos(S.lat);
    float bcfl = B*cos(F.lat);

    float x = acsl*cos(S.lon) +  bcfl*cos(F.lon);
    float y = acsl*sin(S.lon) +  bcfl*sin(F.lon);
    float z = A*sin(S.lat)    +  B*sin(F.lat);
    pair.lat = atan2(z,sqrt(x*x+y*y));
    pair.lon = atan2(y,x);
    return pair;
  }


  LatLonPair getPointOnGreatCircle (float Slat, float Slon, float Flat, float Flon, float distance, float frac){
    float sind = sin(distance);
    float A = sin((1.0-frac)*distance)/sind;
    float B = sin(frac*distance)      /sind;
    float acsl = A*cos(Slat);
    float bcfl = B*cos(Flat);

    float x = acsl*cos(Slon) +  bcfl*cos(Flon);
    float y = acsl*sin(Slon) +  bcfl*sin(Flon);
    float z = A*sin(Slat)    +  B*sin(Flat);
    pair.lat = atan2(z,sqrt(x*x+y*y));
    pair.lon = atan2(y,x);
    return pair;
  }

  // This doesn't just draw any old arc; it draws a pair of wiggly arcs....
  void drawArcBetweenTwoPointsOnUnitSphere (PointOnUnitSphere P0, PointOnUnitSphere P1, float R, float distance){
    noFill();
    int np = (int)(degrees(distance)/1.0) +1;

    float Slat = P0.lat;
    float Slon = P0.lon;
    float Flat = P1.lat;
    float Flon = P1.lon;
    float p0id = P0.id ;
    float mils = millis();
    
    pushMatrix();
    scale(R,R,R);
    for (int k=0; k<2; k++){
      float mlat = k + p0id + mils/(p0id+500.0);
      float mlon = k + p0id + mils/(p0id+437.0); 
      float npm1 = (float)(np-1);

      beginShape();
      for (int i=0; i<np; i++){
        float frac = (float)i/npm1;
        LatLonPair P = getPointOnGreatCircle (Slat, Slon, Flat, Flon, distance, frac);
        
        float f = sin(frac*PI);
        P.lat +=  f * 0.10*(noise(frac + mlat)-0.5);
        P.lon +=  f * 0.10*(noise(frac + mlon)-0.5);
        
        float eulat = HALF_PI - P.lat;
        float slat = sin(eulat);
        float x = cos(P.lon) * slat;
        float y = sin(P.lon) * slat; 
        float z = cos(eulat);
        vertex(x,y,z);  
      }
      endShape();
    }
    popMatrix();
  }



}

