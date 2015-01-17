int x, y;
int numberOfArcs = 10;
int step = 20;
float rotation = - (HALF_PI / 3);
int arcSize;
float start, stop;

void setup()
{
  size(420, 420);
  background(240);
  noFill();
  stroke(127);
  ellipseMode(CENTER);
  strokeCap(PROJECT);
  smooth();
  noLoop();
}

void draw()
{
  for (int i = 0; i < numberOfArcs; i++) {
    strokeWeight(i);
    arc(width / 2, height / 2, 200 + (step * i), 200 + (step * i), rotation * i, rotation * i + (TWO_PI - HALF_PI));
  }
}
