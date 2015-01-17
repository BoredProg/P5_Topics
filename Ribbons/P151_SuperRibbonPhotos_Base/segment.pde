class Segment
{
  float x,y,z;
  float x2,y2,z2;
  PImage img;
  Segment prev;
  int num;

  Segment(float _x, float _y, float _z, float _x2, float _y2, float _z2, int _num)
  {
    x = _x;
    y = _y;
    z = _z;
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    img = textures[_num];
    num = _num;
  }

  void render()
  {
    stroke(0);
    fill(120);
    textureMode(NORMALIZED);
    beginShape(QUADS);
    texture(img);
    vertex(x,y-100,z,0,0);
    vertex(x,y,z,0,1);
    vertex(x2,y2,z2,1,1); 
    vertex(x2,y2-100,z2,1,0);   
    endShape();
  }
}
