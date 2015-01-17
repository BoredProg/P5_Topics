color[] c = {
  color(244,225,211), color(66,66,104), color(204,178,29), color(222,47,44),
  color(146,40,86), color(84,166,66), color(240,117,49), color(110,32,46)
};
 
int rings = 7;
int ringDensity = 4;
int number = 24;
 
void setup() {
  size(width,height);
  strokeWeight(13);
  strokeCap(SQUARE);
  noFill();
  smooth();
}
 
void draw() {
  background(c[0]);
  translate(width/2, height/2);
  for (int h=1; h<(ringDensity*2); h=h+2) {
    for (int i=h; i<(rings*10); i=i+10) {
      for (int j=1; j<number+1; j++) {
        stroke(randomColor(i,j));
        arc(0, 0, i*26, i*26, radians(j*(360/number)), radians((j+1)*(360/number)));
      }
    }
    rotate(radians(7.5));
    for (int i=h+1; i<(rings*10); i=i+10) {
      for (int j=1; j<number+1; j++) {
        stroke(randomColor(i,j));
        arc(0, 0, i*26, i*26, radians(j*(360/number)), radians((j+1)*(360/number)));
      }
    }
  }
}
 
color randomColor(float i, float j) {
  int colorSelect = int(7.5*abs(sin(i*j*j*j)));
  return c[colorSelect];
}
