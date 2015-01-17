public class Point2D
{
   private float _x;
   private float _y;

   public Point2D(float x, float y)
   {
      _x = x;
      _y = y;
   }

   public float X()
   { 
      return _x; 
   }

   public void setX(float value)
   {  
      _x = value; 
   }

   public float Y()
   { 
      return _y; 
   }

   public void setY(float value)
   {  
      _y = value; 
   }

}
