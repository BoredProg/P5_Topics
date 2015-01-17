

/************************************************************************************
*
*  Vec3
*
************************************************************************************/
public class Vec3
{
  public float x;
  public float y;
  public float z;
  
  public Vec3()
  {
    x = 0;
    y = 0;
    z = 0;
  }
  
  public Vec3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public void set(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    
  }
  
  public float[] toArray()
  {
    return new float[] {x, y, z };
  }
  
}

/************************************************************************************
*
*  Vec4
*
************************************************************************************/
public class Vec4 extends Vec3
{
  public float w;
  
  public Vec4()
  {
    this(0,0,0,0);
  }
  
  public Vec4 (float x, float y, float z, float w)
  {
    super(x,y,z);
    
    w = 0;
  }
  
  public void set( float x, float y, float z, float w )
  {
    super.set(x, y, z);
    this.w = w;    
  }
  
  public float[] toArray()
  {
    return new float[] {x, y, z, w };
  }
  
  
}
