PGraphics q1, q2, q3, q4;
float xmag, ymag = 0;
float newXmag, newYmag = 0; 

void setup()
{
  size(640, 480, P3D);
  // |-------|-------|
  // |   Q1  |  Q2   |
  // |-------|-------|
  // |   Q3  |  Q4   |
  // |_______|_______|

  q1 = createGraphics(width/2, height/2, P3D);
  q2 = createGraphics(width/2, height/2, P3D);
  q3 = createGraphics(width/2, height/2, P3D);
  q4 = createGraphics(width/2, height/2, P3D);
}

void draw()
{
  // move scene drawing to drawQuadrant(...)
  // allows us to draw several views of the same scene
  drawQuadrant(q1,new float[]{100,0,0,0,0,0,0,0,1});
  drawQuadrant(q2,new float[]{0,100,0,0,0,0,0,0,1});
  drawQuadrant(q3,new float[]{0,0,100,0,0,0,0,1,0});
  drawQuadrant(q4,new float[]{57,57,57,0,0,0,0,0,1});
  
  image(q1, 0, 0);
  image(q2, width/2, 0);
  image(q3, 0, height/2);
  image(q4, width/2, height/2);  
  stroke(255);
  line(0,height/2, width, height/2);
  line(width/2,0, width/2, height);
}

void drawQuadrant(PGraphics pg, float[] camParams)
{
  pg.beginDraw();
  pg.colorMode(RGB, 1);
  pg.background(0,0,0);
  pg.noStroke();
  pg.camera(camParams[0],camParams[1],camParams[2],
            camParams[3],camParams[4],camParams[5],
            camParams[6],camParams[7],camParams[8]);
  // draw common scene
  drawRGBCube(pg);
  
  pg.endDraw(); 
}

void drawRGBCube(PGraphics pg)
{
  pg.pushMatrix();
  
  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;
  
  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0; 
  }
  
  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0; 
  }
  
  pg.rotateX(-ymag); 
  pg.rotateY(-xmag); 
  
  pg.scale(30);
  pg.beginShape(QUADS);

  pg.fill(0, 1, 1); pg.vertex(-1,  1,  1);
  pg.fill(1, 1, 1); pg.vertex( 1,  1,  1);
  pg.fill(1, 0, 1); pg.vertex( 1, -1,  1);
  pg.fill(0, 0, 1); pg.vertex(-1, -1,  1);

  pg.fill(1, 1, 1); pg.vertex( 1,  1,  1);
  pg.fill(1, 1, 0); pg.vertex( 1,  1, -1);
  pg.fill(1, 0, 0); pg.vertex( 1, -1, -1);
  pg.fill(1, 0, 1); pg.vertex( 1, -1,  1);

  pg.fill(1, 1, 0); pg.vertex( 1,  1, -1);
  pg.fill(0, 1, 0); pg.vertex(-1,  1, -1);
  pg.fill(0, 0, 0); pg.vertex(-1, -1, -1);
  pg.fill(1, 0, 0); pg.vertex( 1, -1, -1);

  pg.fill(0, 1, 0); pg.vertex(-1,  1, -1);
  pg.fill(0, 1, 1); pg.vertex(-1,  1,  1);
  pg.fill(0, 0, 1); pg.vertex(-1, -1,  1);
  pg.fill(0, 0, 0); pg.vertex(-1, -1, -1);

  pg.fill(0, 1, 0); pg.vertex(-1,  1, -1);
  pg.fill(1, 1, 0); pg.vertex( 1,  1, -1);
  pg.fill(1, 1, 1); pg.vertex( 1,  1,  1);
  pg.fill(0, 1, 1); pg.vertex(-1,  1,  1);

  pg.fill(0, 0, 0); pg.vertex(-1, -1, -1);
  pg.fill(1, 0, 0); pg.vertex( 1, -1, -1);
  pg.fill(1, 0, 1); pg.vertex( 1, -1,  1);
  pg.fill(0, 0, 1); pg.vertex(-1, -1,  1);

  pg.endShape();
  
  pg.popMatrix(); 
}
