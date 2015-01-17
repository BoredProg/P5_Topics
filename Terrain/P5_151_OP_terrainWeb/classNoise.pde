class NoiseGenerator
{
  private PImage img, measure, cracksImg, valleyImg;
  private ArrayList cracks, valleys;
  private boolean editCracks = true;
  private RandomWalk walker;

  NoiseGenerator (int xres, int yres)
  {   
    img = createImage (xres, yres, RGB);
    measure = createImage (xres, yres, RGB);

    cracks = new ArrayList();
    valleys = new ArrayList();
    createImg();
  }

  public void setCrack (int x, int y)
  {
    editCracks = true;
    cracks.add (new Cracks ((int) random (1, 5), x, y, (int) random (width/4, width/2), 0.25));
    Cracks c = (Cracks) cracks.get(cracks.size()-1);
    c.writeToImage(img.width, img.height);

  }

  public void setCrack (int n)
  {
    cracks.clear();
    editCracks = true;

    for (int i = 0; i < n; i++)
    {
      cracks.add (new Cracks ((int) random (1, 20), (int) random(width), (int) random (height), (int) random (width/4, width/2), 0.25));
      Cracks c = (Cracks) cracks.get(cracks.size()-1);
      c.writeToImage(img.width, img.height);
    }
    endCracks();
  }


  public void endCracks ()
  {
    if (cracks != null)
    {
      boolean clearIt = false;
      Cracks c;

      if (cracksImg == null) {
        clearIt = true;
        cracksImg = createImage (img.width, img.height, RGB);
      }
      if (clearIt)
      {
        cracksImg.loadPixels();     
        for (int i = 0; i < cracksImg.pixels.length; i++) cracksImg.pixels [i] = color (0);
        cracksImg.updatePixels();
      }
      cracksImg.loadPixels(); 
      for (int j = 0; j < cracksImg.pixels.length; j++)
      {
        float b = 0;
        for (int i = 0; i< cracks.size(); i++)
        {
          c = (Cracks) cracks.get (i);
          PImage temp = c.getImage();
          b += brightness(temp.pixels[j]);
        }
        cracksImg.pixels[j] = color (brightness(cracksImg.pixels[j]) + (b));
      }
      cracksImg.updatePixels(); 
      editCracks = false;
      marks(cracksImg, 1.0, 1.15, 1);
    }
  }
  
  public void setValleys (int n)
  {
    valleys.clear();

    for (int i = 0; i < n; i++)
    {
      valleys.add (new Cracks ((int) random (1, 20), (int) random(width), (int) random (height), (int) random (width/4, width/2), 0.25));
      Cracks c = (Cracks) valleys.get(valleys.size()-1);
      c.writeToImage(img.width, img.height);
    }
    endValleys();
  }


  public void endValleys ()
  {
    if (valleys != null)
    {
      boolean clearIt = false;
      Cracks c;

      if (valleyImg == null) {
        clearIt = true;
        valleyImg = createImage (img.width, img.height, RGB);
      }
      if (clearIt)
      {
        valleyImg.loadPixels();     
        for (int i = 0; i < valleyImg.pixels.length; i++) valleyImg.pixels [i] = color (0);
        valleyImg.updatePixels();
      }
      valleyImg.loadPixels(); 
      for (int j = 0; j < valleyImg.pixels.length; j++)
      {
        float b = 0;
        for (int i = 0; i< valleys.size(); i++)
        {
          c = (Cracks) valleys.get (i);
          PImage temp = c.getImage();
          b += brightness(temp.pixels[j]);
        }
        valleyImg.pixels[j] = color (brightness(valleyImg.pixels[j]) + (b));
      }
      valleyImg.updatePixels(); 
      marks(valleyImg, 0.85, 1.0, -1);
    }
  }

  public void marks (PImage mark)
  {
    mark.resize (img.width, img.height);
    mark.loadPixels();
    for (int i = 0; i < img.pixels.length; i++)
    {
      float c = brightness (img.pixels [i]);

      if (c <= 0.5) c = map (0.5*brightness (mark.pixels[i]) + brightness (img.pixels [i]), 0, 120, 0, 50);
      else c = map (0.5*brightness (mark.pixels[i]) + brightness (img.pixels [i]), 0, 1.5*255, 0, 255);
      img.pixels [i] = color (c);
    }
    img.updatePixels();
  }

  public void marks (PImage target, float start, float end, int dir)
  {
    target.loadPixels();
    for (int i = 0; i < img.pixels.length; i++)
    {
      float c = brightness (img.pixels [i]);
      float c2 = brightness (target.pixels [i]);
      if (dir < 0) c2 = constrain (255 -c2, 0, 255);
  
        // if (c == 0) c = map (brightness (cracksImg.pixels[i]) + brightness (img.pixels [i]), 0, 2*255, 0, 120);
        // else 

        float val = map (c2, 0, 255, start, end);

        //c = map (brightness (cracksImg.pixels[i]) + brightness (img.pixels [i]), 0, 2*255, 0, 255);
        if (c*val < 250) c*= val;
       else c =c;

        img.pixels [i] = color (c);

    }
    img.updatePixels();
  }

  public void doFastBlur ()
  {
    fastblur (this.img, 6);

  }

  public void createImg ()
  {
    int index = 0;
    img.loadPixels();
    float timeX = random (1000), timeY = random (1000), timeZ = random (1000);
    float speedX = random (0.004, 0.02), speedY = random (speedX/2.0, speedX), speedZ =  random (0.003, 0.02);
    noiseDetail((int) random (3, 10), random (0.25, 0.75));
    for (int i = 0; i < img.height; i++)
    {
      timeX = 0.0;
      for (int j = 0; j < img.width; j++)
      {
        index  = i*img.width+j;
        img.pixels[index] = color (noise (timeX, timeY, timeZ) * 255.0);
        timeX += speedX;
      }

      timeY += speedY;
      timeZ += speedZ;
    }
    img.updatePixels();


  }

  public void doubleImage ()
  {
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++)
    {
      img.pixels [i] = color (1.2* (brightness (img.pixels [i])));
    }
    img.updatePixels();

  }

  public void invertImage ()
  {
    for (int i = 0; i < img.pixels.length; i++)
    {
      img.pixels [i] = color (255- (brightness (img.pixels [i])));
    }
    img.updatePixels();
  }

  public void measureImage ()
  {
    walker = new RandomWalk (measure.width, measure.height, (int) random (3000, 6000));
    arrayCopy (walker.getImage().pixels, measure.pixels);
    measure.updatePixels();
    float m = 0.0;
    measure.loadPixels();
    for (int i = 0; i < img.pixels.length; i++)
    {
      //if (i % 10 == 0) println (brightness (measure.pixels[i]));
      m = map (brightness (measure.pixels[i]), 0, 254, 0.00, 0.99);
      img.pixels[i] = color (brightness (img.pixels[i]) > 0 ? sqrt (brightness (img.pixels[i]) * brightness (measure.pixels[i]) ) : 0);
    }
    img.updatePixels();
  }

  public PImage getImage ()
  {
    return img;
  }

  public void display (int x, int y, int w, int h)
  {
    image (img, x, y, w, h);
  }
}

