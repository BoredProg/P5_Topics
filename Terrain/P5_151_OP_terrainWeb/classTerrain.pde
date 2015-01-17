class Terrain
{
  private int w, h, x, y, xres, yres;
  private PImage img;
  private PVector [] p;

  Terrain (int x, int y, int xres, int yres, int w, int h, PImage img)
  {
    this.x = x;
    this.y = y;
    this.xres = xres;
    this.yres = yres;
    this.w = w;
    this.h = h;
    this.img = createImage (img.width, img.height, RGB);
    arrayCopy (img.pixels, this.img.pixels);
    this.img.resize (xres, yres);
    this.img.updatePixels();
    p = new PVector [this.img.pixels.length];
    createPoints();
  }
  
  public void decreaseDepth ()
  {
    for (int i = 0; i < p.length; i++)
    {
      p[i].z *= 0.9;
    }
  }
  
  public void increaseDepth ()
  {
    for (int i = 0; i < p.length; i++)
    {
      p[i].z *= 1.1;
    }
  }
  
  public void update (PImage img)
  {
    this.img = createImage (img.width, img.height, RGB);
    arrayCopy (img.pixels, this.img.pixels);
    this.img.resize (xres, yres);
    this.img.updatePixels();
    p = new PVector [this.img.pixels.length];
    createPoints();
  }

  private void createPoints ()
  {
    img.loadPixels ();
    int index = 0; 
    float xp = 0, yp = 0, zp = 0;

    for (int i = 0; i < yres; i++)
    {
      for (int j = 0; j < xres; j++)
      {
        index = i*xres+j;
        xp = x + (float) j * (float) w / (float) xres;
        yp = y + (float) i * (float) h / (float) yres;
        zp = brightness (img.pixels[index]) / 1.5;
        p[index] = new PVector (xp, yp, zp);
      }
    }
  }

  public void display ()
  {
    noStroke ();
    fill (200);
    emissive (20);
    int index = 0, nextIndex = 0; 
    for (int i = 0; i < yres; i++)
    {
      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j < xres; j++)
      {

        index = i*xres+j;
        nextIndex = (i + 1) < xres ? (i+1)*xres+(j) : index; 

        vertex (p[index].x, p[index].y, p[index].z);
        vertex (p[nextIndex].x, p[nextIndex].y, p[nextIndex].z);
      }
      endShape();
    }
  }
}

