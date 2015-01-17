
public interface IRenderer
{
   void render(IRenderable entity);
}


public interface IRenderable
{
   void setRenderer(IRenderer renderer);
}

