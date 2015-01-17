/****************************************************************************
* Class   :  PShaderCustom
*
*            just changed two protected methods to public in order to 
*            get shader's attribute variable's location (id).
****************************************************************************/
public class PShaderCustom extends PShader
{
  
  public PShaderCustom(PApplet parent, String[] vertSource, String[] fragSource) 
  {
    super(parent, vertSource, fragSource);
  }
  
  
  /**
   * Returns the ID location of the attribute parameter given its name.
   *
   * @param name String
   * @return int
   */
  public int getAttributeLocation(String name) 
  {
    return super.getAttributeLoc(name);
  }


  /**
   * Returns the ID location of the uniform parameter given its name.
   *
   * @param name String
   * @return int
   */
  public int getUniformLocation(String name) 
  {
    return super.getUniformLoc(name);
    
  }  
}
