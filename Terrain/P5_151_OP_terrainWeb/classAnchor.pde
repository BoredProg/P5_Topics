class Anchor
{
  private float angle, minAngle, maxAngle, length;
  private int centerX, centerY;
  private ArrayList branches;

  Anchor (float angle, float minAngle, float maxAngle, float length, int centerX, int centerY, float minNext )
  {
    this.angle = angle;
    this.minAngle = minAngle;  
    this.maxAngle = maxAngle;
    this.length = length;
    this.centerX = centerX;
    this.centerY = centerY;
    branches = new ArrayList();
    createBrances(angle, centerX, centerY, 0, random (length /15.0, length /2.0), 0, minNext);
  }

  public int getCenterX ()
  {
    return centerX;
  }

  public int getCenterY ()
  {
    return centerY;
  }
  
  public Branch [] getBranches ()
  {
    Branch [] b = new Branch [branches.size()];
    Branch temp;
    for (int i = 0; i < branches.size(); i++)
    {
      b[i] = (Branch) branches.get (i);
    }
    return b;
  }

  private void createBrances (float fAngle, float startX, float startY, float totalLength, float flength, int count, float minNext)
  {
    float mangle = random (-minAngle/2, maxAngle/2);
    //mangle = random (-7,7);
    float weighing = random (0.25, 0.75);
    float [] [] points = new float [5] [2];
    if (flength>80) points = new float [6] [2];
    points [0] [0] = points [1] [0] = startX;                                                                                                                  // startpunkt x
    points [0] [1] = points [1] [1] = startY;                                                                                                                  // startpunkt y
    points [points.length-2] [0] = points [points.length-1] [0] = startX + cos (radians (fAngle)) * flength;                                                   // endpunkt x
    points [points.length-2] [1] = points [points.length-1] [1] = startY + sin (radians (fAngle)) * flength;                                                   // endpunkt y
    if (flength<=80)
    {
      points [2] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
      points [2] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
    }
    else{
      weighing = random (0.25, 0.5);
      points [2] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
      points [2] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
      mangle = random (-minAngle/2, maxAngle/2);
       //mangle = random (-7,7);
      weighing = random (0.5, 0.75);
      points [3] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
      points [3] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y

    }

    branches.add (new Branch (points));

    totalLength+= flength;
    if (count < 25 && flength > 1.5)
    {
      count++;
      int dir = (int) random (0, 3);

      if (dir <= 1)
      {
        float nextflength = flength * random (0.75, 1.20);
        if ( totalLength+nextflength < length) createBrances (fAngle + random (minAngle*2, maxAngle*2), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
      }
      else
      {
        float nextflength = flength * random (minNext, 1.05);
        if ( totalLength+nextflength < length) createBrances (fAngle/* + random (minAngle/2, 0)*/, points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
        nextflength = flength * random (minNext, 1.05);
        if ( totalLength+nextflength < length) createBrances (fAngle + random (0, maxAngle/2), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
      }
    }
  }

  public void display ()
  {
    Branch br;
    for (int i = 0; i < branches.size(); i++)
    {
      br = (Branch) branches.get (i);
      br.display();
    }
  }
}




