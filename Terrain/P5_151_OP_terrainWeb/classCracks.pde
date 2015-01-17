class Cracks
{
  private Anchor [] anchor;
  private int d;
  private boolean saveImage;
  private int mode;
  private float minNext;
  private PGraphics img;

  Cracks (int num, int centerX, int centerY, int d, float minNext)
  {
    mode = 0;
    saveImage = false;
    this.minNext = minNext;
    this.d = d;
    this.mode = mode;
    createAnchors (num, centerX, centerY, d);
  }
 

  private void createAnchors(int num, int centerX, int centerY, int d)
  {
    float time = random (1000);
    float timeVal = random (0.001, 0.5);
    anchor = new Anchor [num];
    float [] angles = new float [num];

    for (int i = 0; i < num; i++)
    {
      angles [i] = random (360);
    }

    arrayCopy (sort (angles), angles);

    float val = random (7, 30);
    float minLength = d*10, maxLength = 0;
    float [] length = new float [num];

    for (int i = 0; i < length.length; i++)
    {
      length [i] = getLength (noise (time), d);
      if (length [i] < minLength) minLength = length [i];
      if (length [i] > maxLength) maxLength = length [i];

      time += timeVal;
    }

    if (minLength != maxLength)
    {
      for (int i = 0; i < length.length; i++)
      {
        length [i] = map (length [i], minLength, maxLength, minLength, d) ;
      }
    }

    for (int i = 0; i < num; i++)
    {

      anchor [i] = new Anchor (angles [i], -val, val, length [i], centerX, centerY, minNext);
    }
  }

  private float getLength (float noiseVal, int d)
  {
    switch (mode)
    {
    case 0: 
      return (noiseVal * (float) d);
    case 1: 
      return (50+noiseVal * (float) d);
    case 2: 
      return (d*0.3333+noiseVal * (float) d * 0.6667);
    case 3:
      return ( (float) d);
    default:
      return (noiseVal * (float) d);
    }
  }

  public PImage getImage()
  {
    return img;
  } 

  public void display ()
  {
    image (img, 0, 0);
  }

  public void writeToImage (int xres, int yres)
  {

    img = createGraphics (xres, yres, JAVA2D);
    img.smooth();
    img.beginDraw();
    img.strokeWeight(random (2, 8));
    img.noFill();
    img.stroke (255, 150);
    for (int i = 0; i < anchor.length; i++)
    {
      Branch [] br= anchor[i].getBranches();
      for (int j = 0; j < br.length; j++)
      {
        float [] [] points = br[j].getPoints();

        img.beginShape();

        for (int k = 0; k < points.length; k++)
        {
          img.curveVertex (points [k] [0], points [k] [1]);
        }
        img.endShape();
      }
    }
    img.endDraw();
    img.updatePixels();

    fastblur(img, 10);

    img.beginDraw();
    img.strokeWeight(1.2);
    img.noFill();
    img.stroke (255, 100);

    for (int i = 0; i < anchor.length; i++)
    {
      Branch [] br= anchor[i].getBranches();
      for (int j = 0; j < br.length; j++)
      {
        float [] [] points = br[j].getPoints();

        img.beginShape();

        for (int k = 0; k < points.length; k++)
        {
          img.curveVertex (points [k] [0], points [k] [1]);
        }
        img.endShape();
      }
    }

    img.endDraw();
    
    fastblur(img, 1);
    
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++)
    {
      float b = brightness (img.pixels[i]);
      if (b < 0.5) img.pixels[i] = color (brightness (img.pixels[i]), 0);
    }
    
    img.updatePixels();
  }
}

