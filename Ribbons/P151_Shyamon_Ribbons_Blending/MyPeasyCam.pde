import peasy.*;

class MyPeasyCam
{
  private PeasyCam cam;

  MyPeasyCam( PApplet p, float minDist, float maxDist, float initDist )
  {
    cam = new PeasyCam(p, (double)initDist);
    cam.setMinimumDistance(minDist);
    cam.setMaximumDistance(maxDist);
  }
}

