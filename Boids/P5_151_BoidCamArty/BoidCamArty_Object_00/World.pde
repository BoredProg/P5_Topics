


public class World extends Vector3 implements IRenderable
{
   IRenderer _renderer;
   
   public World(float _x, float _y, float _z) 
   {
      super(_x, _y, _z);
  } 

  public World() 
  {
     super();
  }
  
  public void setRenderer(IRenderer renderer)
  {
     _renderer = renderer;
  }
  
  public void render()
  {
     _renderer.render( this );
  }
  
  
}
