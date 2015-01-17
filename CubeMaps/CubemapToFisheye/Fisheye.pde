/*
* --=[Cubemap to fisheye]=--
* by Jonsku, March 2011
* --
* This code is a combination of code found in http://strlen.com/gfxengine/fisheyequake/
* and explanation and description of the angular fisheye projection by Paul Bourke
* http://paulbourke.net/miscellaneous/domefisheye/fisheye/
* ----------
* What it does is caclulate a projection vector for each pixels and use it to pick the color information
* from the cube map (6 images).
* The rotation of the virtual camera can be controlled by the parameters pitch, yaw and roll.
* The zoom parameter is quite groovy and can be used to create wee planets (http://www.flickr.com/photos/gadl/sets/72157594279945875/)
* or tear the fabric of the universe :D
*/

//fov in radians!
int[] fisheyeLookup(int w, int h, float fov, float pitch, float yaw, float roll, float zoom) {
  int[] lookupTable = new int[w*h];
  int c = 0;
  float camX= 0;
  float camY= 0;
  for(float y=0;y<h;y++) {
    for(float x=0;x<w;x++) {
      float dx = x-float(w)/2.0;
      float dy = -y+float(h)/2.0;
      float d = dist(camX,camY,dx,dy);//sqrt(dx*dx+dy*dy);
      
      //constrain to produce a circular fisheye
      if(d>w/2){
        c++;
        continue;
      }

      float theta =  ((d*fov)/float(w)); //theta
      float phi = atan2(camY-dy,camX-dx)+roll; //phi; add angle to change roll
      float sx_p = sin(theta) * cos(phi);
      float sy_p = sin(theta) * sin(phi);
      float sz_p = cos(theta+zoom);
      
      /*
      The projection vector is rotated by a rotation matrix
      which is the result of the multiplication of 3D roation on X (pitch) and Y (yaw) axes
      */
      float cosPitch = cos(pitch);
      float sinPitch = sin(pitch);
      float cosYaw = cos(yaw);
      float sinYaw = sin(yaw);
      
      float sx = sx_p*cosYaw+sy_p*sinPitch*sinYaw-sz_p*cosPitch*sinYaw;
      float sy = sy_p*cosPitch+sz_p*sinPitch;
      float sz = sx_p*sinYaw-sy_p*sinPitch*cosYaw+sz_p*cosPitch*cosYaw;

      //determine which side of the box to use
      float abs_x = abs(sx);
      float abs_y = abs(sy);
      float abs_z = abs(sz);
      int side = 0;
      float xs = 0.0;
      float ys = 0.0;

      if(abs_x > abs_y) {
        if(abs_x > abs_z) {
          side = sx > 0.0 ? BOX_RIGHT : BOX_LEFT;
        }
        else {
          side = sz > 0.0 ? BOX_FRONT : BOX_BEHIND;
        }
      }
      else {
        if(abs_y > abs_z) {
          side = sy > 0.0 ? BOX_TOP : BOX_BOTTOM;
        }
        else {
          side = sz > 0.0 ? BOX_FRONT : BOX_BEHIND;
        }
      }



      //Convert to range [0;1]
      switch(side) {
      case BOX_FRONT: 
        xs = rc(sx/sz); 
        ys = rc(sy/sz); 
        break;
      case BOX_BEHIND: 
        xs = rc(-sx/-sz); 
        ys = rc(sy/-sz); 
        break;
      case BOX_LEFT: 
        xs = rc(sz/-sx); 
        ys = rc(sy/-sx); 
        break;
      case BOX_RIGHT: 
        xs = rc(-sz/sx); 
        ys = rc(sy/sx); 
        break;
      case BOX_TOP: 
        xs = rc(sx/sy); 
        ys = rc(sz/-sy); 
        break;
      case BOX_BOTTOM: 
        xs = rc(-sx/sy); 
        ys = rc(sz/-sy); 
        break;
      }
      xs = constrain(xs,0.0,0.999);
      ys = constrain(ys,0.0,0.999);
      
      //get the pixel
      int lX = int(xs*float(w));
      int lY = int(ys*float(h));
      lX = constrain(lX,0,w);
      lY = constrain(lY,0,h);
 
      lookupTable[c++] = cubeMap[side].pixels[lX+lY*w];
    }
  }
  return lookupTable;
}

float rc(float x) {
  return (x/2)+0.5;
}


