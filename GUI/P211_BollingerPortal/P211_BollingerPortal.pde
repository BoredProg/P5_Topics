// Portal

//Click to reset rings to new pattern.<br>


Ring [] rings;
int nrings;
float rotx, roty;
float ringhue;

void setup() 
{
  size(1280,720,OPENGL);
  smooth(32);
  
  

  nrings = 8;
  
  rings = new Ring[nrings];
  
  for (int i=0; i<nrings; i++)
  {
    rings[i] = new Ring((i+1)*50f, (i+1)*50f+45f);
  }
  
  
  noStroke();
  colorMode(HSB);
}



void draw() 
{
  background(0);
  lights();
  translate(width/2f, height/2f, -500);
  
  //rotateX(rotx+=0.013);
  //rotateY(roty+=0.017);

  //rotateX(mouseX/100f);

  fill(color(ringhue, 192, 240));  
  ringhue = (ringhue + 0.2f) % 256f;

  for (int i=0; i<nrings; i++)
  {    
    // Fait qu'ils n'apparaissent pas au même point de départ.  
    //rotateZ(i);
    //rotateZ((frameCount /200f) + noise(i/ frameCount) * 50f);
    
    //rings[i].setStartDegree(int(random(15)));
    rings[i].draw();
  
  }
}

void mousePressed() {
  //reset();
}





class Ring 
{
  static final int toopie = 360; // trig table resolution
  
  float radius1, radius2, thickness;
  
  float theta, dtheta;
  
  float rotx, roty, rotz;
  
  // Tables Trig
  float [] r1cos, r1sin;
  float [] r2cos, r2sin;
  
  int startDegree = 100;

  
  public void setStartDegree(int degree)
  {
    startDegree = degree;
  }

  public int getStartDegree()
  {
    return startDegree;
  }
  
  public Ring(float radius1, float radius2) 
  {
    this.radius1 = radius1;
    this.radius2 = radius2;
    
    r1cos = new float[toopie+1];
    r1sin = new float[toopie+1];
    
    r2cos = new float[toopie+1];
    r2sin = new float[toopie+1];
    
    // ?
    //int startDegree = 45;

    println(startDegree);
    //              45             360
    for (int i = getStartDegree(); i<=toopie; i++) // divide toopie by anything to get a incomplete circle
    {
       
      // Calcs the angle..
      float theta = (float)(i) / (float)(toopie) * TWO_PI;
      
      // Fills the trig arrays
      r1cos[i] = radius1 * cos(theta);
      r1sin[i] = radius1 * sin(theta);
      
      r2cos[i] = radius2 * cos(theta);
      r2sin[i] = radius2 * sin(theta);
    }

    thickness = 0f;
   
    
  }
  
  
 
  
  void draw() 
  {
    thickness = mouseY; //frameCount / 10f;
    
    //fill(255,150);
    
    
    /*
    
    theta += dtheta;
    
    rotateY(theta);
    rotateX(rotx);
    rotateY(roty);  
    rotateZ(rotz);
    
    */ 
    //setStartDegree(frameCount);
    
    // back edge    
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) 
    {
      vertex(r1cos[i], r1sin[i], thickness);
      vertex(r2cos[i], r2sin[i], thickness);
    }
    endShape();
    
    // front edge
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) 
    {
      vertex(r1cos[i], r1sin[i], -thickness);
      vertex(r2cos[i], r2sin[i], -thickness);
    }
    endShape();
    
    
    // outer rim
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) 
    {
      vertex(r2cos[i], r2sin[i], thickness);
      vertex(r2cos[i], r2sin[i], -thickness);
    }
    endShape();
    
    
    // inner rim
    
    beginShape(TRIANGLE_STRIP);
    for (int i=0; i<=toopie; i++) {
      vertex(r1cos[i], r1sin[i], thickness);
      vertex(r1cos[i], r1sin[i], -thickness);
    }
    
   endShape();
  }
  
}
