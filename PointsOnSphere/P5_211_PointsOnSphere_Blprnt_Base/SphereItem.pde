/*

SphereItem Class
blprnt@blprnt.com

*/


class SphereItem {
  
  Sphere parentSphere;
  
  //Spherical Coordinates
  float radius;
  float theta;
  float phi;
  
  //Speed properties
  float thetaSpeed = 0;
  float phiSpeed = 0;
  
  //Size
  float itemSize = 5;
  
  //Stray
  float stray;
  
  public void SphereItem() {
   
  };
  
  public void init() {
    itemSize = random(5);
    thetaSpeed = random(-0.01, 0.01);
    phiSpeed = random(-0.01, 0.01);
    stray = random(10,-10);
  };
  
  public void update() {
    theta += thetaSpeed;
    phi += phiSpeed;
  };
  
  public void render() {
    //Get the radius from the parent Sphere
    float r = parentSphere.radius + stray;
    //Convert spherical coordinates into Cartesian coordinates
    float x = cos(theta) * sin(phi) * r;
    float y = sin(theta) * sin(phi) * r;
    float z = cos(phi) * r;
    
    //Mark our 3d space
    pushMatrix();
    //Move to the position of this item
    translate(x,y,z);
    //Set the fill colour
    fill(0,0,0,150);
    noStroke();
    //Draw a circle
    //ellipse(0,0,itemSize,itemSize);
    sphere(itemSize);
    //Go back to our position in 3d space
    popMatrix();
   
  };
  
};
