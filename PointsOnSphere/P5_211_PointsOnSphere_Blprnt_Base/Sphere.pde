class Sphere {
  
  float xPos = 0;                   //X Position of the Sphere
  float yPos = 0;                   //Y Position of the Sphere
  float zPos = 0;                   //Z Position of the Sphere
  
  float radius = 50;                  //Radius of the Sphere
      
  ArrayList items = new ArrayList();  //List of all of the items contained in the Sphere
  
  public void Sphere()
  {
  }
    
    
  public void init() {
    //Empty, for now!
  };
  
  public void addSphereItem() {
    //Make a new SphereItem
    SphereItem si = new SphereItem();
    //Set the parent sphere
    si.parentSphere = this;
    //Set random values for the spherical coordinates
    si.theta = random(PI * 2);
    si.phi = random(PI * 2);
    //Add the new sphere item to the end of our ArrayList
    items.add(items.size(), si);
    si.init();
  };
  
  public void update() {
    
    for (int i = 0; i < items.size(); i ++) {
      SphereItem si = (SphereItem) items.get(i); // Cast the returned object to the SphereItem Class
      si.update();
    };
    
  };
  
  public void render() {
    //Move to the center point of the sphere
    translate(xPos, yPos, zPos);
    //Mark our position in 3d space
    
    rotateX(frameCount / 100f);
    
    pushMatrix();
    //Render each SphereItem
    for (int i = 0; i < items.size(); i ++) {
      SphereItem si = (SphereItem) items.get(i);
      si.render();
    };
    //Go back to our original position in 3d space
    popMatrix();
  };
 
};
