class Branch 
{
  private float [] [] points;

  Branch (float [] [] points)
  {
    this.points = new float [points.length] [points[0].length];
    arrayCopy (points, this.points);
  }

  public float [] [] getPoints ()
  {
    return points;
  }

  public void display ()
  {
    noFill();
    stroke (0, 50);
    beginShape();
    for (int i = 0; i < points.length; i++)
    {
      curveVertex (points [i] [0], points [i] [1]);
    }
    endShape();
  }
  
}

