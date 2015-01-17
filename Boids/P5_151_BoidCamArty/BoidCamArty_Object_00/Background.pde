
public class Background implements IRenderable
{
   public IRenderer _renderer;
   
   public void setRenderer(IRenderer renderer)
   {
      _renderer = renderer;
   }
   
   public void render()
   {
      _renderer.render( this );
   }
}
