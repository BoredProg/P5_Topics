import processing.opengl.*;

// Daniel Shiffman
// Wavey
// December 2005

//import processing.opengl.*;
int n = 60;
int w;
int h;
float[][] z;
float a1,a2,a3;
float zoff = 0;
int count = 0;

float osc = 0.0f;

void setup()
{
  size(1280,920,OPENGL);
  //lights();
  hint(ENABLE_OPENGL_4X_SMOOTH);
  colorMode(RGB,255,255,255,100);
  z = new float[n+1][n+1];
  w = width/n;
  h = height/n;
  //framerate(30);
  
  int count = 0;
  smooth();
}

void draw()
{     
  lights(); 
  background(0);
  noStroke();
  zoff += 0.01f;
  float xoff = 0.0;
  for (int x = 0; x < z.length; x+=1)
  { 
    xoff += 0.05;
    float yoff = 0.0;
    for (int y = 0; y < z[x].length; y++)
    {
      z[x][y] = (noise(xoff,yoff,zoff)*400.0f);
      yoff += .08;
    }
  }
  translate(width/2,height/2,sin(zoff)*100.0f + 200.0f);
  rotateX(a1); 
  a1 += 0.01f;
  rotateY(a2); 
  a2 += 0.013f;
  rotateZ(a3); 
  a3 += 0.018f;
  int n = 60;
  
  
  float count = abs(sin(osc)*255);
  osc += 0.00567;
  
  //stroke(255);
  //noStroke();
  //noFill();
 
  for (int j=0;j<n/2;j++) {
    float theta1 = j * TWO_PI / n - PI/2;
    float theta2 = (j + 1) * TWO_PI / n - PI/2;

    beginShape(QUADS);
    for (int i=0;i<=n;i++) {
      float theta3 = i * TWO_PI / n;


      float x1 = cos(theta2) * cos(theta3);
      float y1 = sin(theta2);
      float z1 = cos(theta2) * sin(theta3);

      int lookx = abs(int(x1*n));
      int looky = abs(int(y1*n));
      float r = z[lookx][looky];
      float x2 = r * x1;
      float y2 = r * y1;
      float z2 = r * z1;

      //fill(r*2,r/2,(r+count)%255);
      fill(255%(i+1),i*10,j*i);
      vertex(x2,y2,z2);

      x1 = cos(theta1) * cos(theta3);
      y1 = sin(theta1);
      z1 = cos(theta1) * sin(theta3);
      lookx = abs(int(x1*n));
      looky = abs(int(y1*n));
      r = z[lookx][looky];      
      x2 = r * x1;
      y2 = r * y1;
      z2 = r * z1;
      
      //fill(r/2,(r+count)%255,r*2,r);
      colorMode(HSB);
      //fill(frameCount%255,255,255);
      fill(255);
      colorMode(RGB);
      vertex(x2,y2,z2);
    }
    endShape();
  }
  


}


