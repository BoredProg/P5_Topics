class RandomWalk
{
  private PGraphics img;
  private int xres, yres, t, x = 0, y = 0, d;
  RandomWalk (int xres, int yres, int t)
  {
    img = createGraphics (xres, yres, JAVA2D);
    this.xres = xres;
    this.yres = yres;
    this.t = t;
    x = (int) random (xres);
    y = (int) random (yres);
    d = (int) random (120, xres/4);
    walk();
  }

  private void grow ()
  {
    int dir = (int) random (2);
    int speed = (int) random (5, 20);
    if (dir == 0 && d < xres/4) d+=speed;
    if (dir == 1 && d> 20) d-=speed;
  }

  private void move ()
  {
    boolean moved = false;
    int dir = (int) random (8);
    int speed = (int) random (5, 20);
    switch (dir)
    {
    case 0:
      if (x > 0) {
        moved = true;
        x-=speed;
      }
      if (y > 0) {
        moved = true;
        y-=speed;
      }
      break;
    case 1:
      if (y > 0) {
        moved = true;
        y-=speed;
      }
      break;
    case 2:
      if (x < xres) {
        moved = true;
        x+=speed;
      }
      if (y > 0) {
        moved = true;
        y-=speed;
      }
      break;
    case 3:
      if (x > 0) {
        moved = true;
        x-=speed;
      }
      break;
    case 4:
      if (x < xres) {
        moved = true;
        x+=speed;
      }
      break;
    case 5:
      if (x > 0) {
        moved = true;
        x-=speed;
      }
      if (y < yres) {
        moved = true;
        y+=speed;
      }
      break;
    case 6:
      if (y < yres) {
        moved = true;
        y+=speed;
      }
      break;
    case 7:
      if (x < xres) {
        moved = true;
        x+=speed;
      }
      if (y < yres) {
        moved = true;
        y+=speed;
      }
      break;
    default:
      if (x > 0) {
        moved = true;
        x-=speed;
      }
      if (y < yres) {
        moved = true;
        y-=speed;
      }
      break;
    }

    if (!moved) move();
  }

  public void walk ()
  {
    int stepper = (int) random (200, 500);
    img.beginDraw();
    img.smooth();
    img.background (2);
    img.endDraw();
    for (int i = 0; i < t; i++)
    {
      move();
      grow();

      img.fill (255, 2);
      img.noStroke();
      img.ellipse (x, y, d, d);

      if (i != 0 && i % 40 == 0) {
        img.endDraw();
       fastblur(img, 4);
       img.beginDraw();
      }
      if (i != 0 && i % stepper == 0) {
        int dir = (int) random (2);
        if (dir == 0) {
          x = (int) random (xres);
          y = (int) random (yres);
        }
      } 
    }
    fastblur(img, 30);
  }
  
  public PImage getImage ()
  {
    return (PImage) img;
  }
  
  public void display ()
  {
    image (img, 0, 0);
  }
}

