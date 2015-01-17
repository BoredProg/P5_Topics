int num = 150;
Vector[] vecs = new Vector[num];
float ribW = 60, ribH;
float ribY;
float margin = 25;
void setup(){
  size(400, 400, P3D);
  calcStrip();
  calcRibbon();
}

void draw(){
  background(200);
  lights();
  translate(width/2, height/2);
  rotateX(frameCount*PI/220);
  rotateY(frameCount*PI/240);
  rotateZ(frameCount*PI/270);
  drawRibbon();
}

void calcStrip(){
  ribH = (height-margin*2)/num;
  ribY = -ribH*num/2;
  for (int i=0; i<num; i++){
    vecs[i] = new Vector(0, -ribH*100/2, 0);
    if (i%2==0){
      vecs[i].vx += ribW/2;
      vecs[i].vy = ribY;
    } 
    else {
      vecs[i].vx -=ribW/2;
      vecs[i].vy = ribY;
      ribY+=ribH*2;
    }
  }
}


void calcRibbon(){
  float theta1 = 0;
  float theta2 = 0;
  Vector[] tempVecs = new Vector[num];
  for (int i=0; i<num; i++){
    float x = vecs[i].vz*sin(theta1) + vecs[i].vx*cos(theta1);
    float y = vecs[i].vy;
    float z = vecs[i].vz*cos(theta1) - vecs[i].vx*sin(theta1);
    tempVecs[i] = new Vector(x, y, z);
    theta1 = sin(theta2)*1.1;
    theta2 += random(PI/180, PI/30);
  }
  vecs = tempVecs;
}


void drawRibbon(){
  beginShape(QUAD_STRIP);
  for (int i=0; i<num; i++){
    vertex(vecs[i].vx, vecs[i].vy, vecs[i].vz);
  }
  endShape(CLOSE);
}

class Vector{
  float vx, vy, vz;

   // default constructor
   Vector() {
  }
  
  Vector(float vx, float vy, float vz) {
    this.vx = vx;
    this.vy = vy;
    this.vz = vz;
  }
}
 
