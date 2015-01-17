/**
*  All material presets are from : 
*      http://devernay.free.fr/cours/opengl/materials.html
*      http://www.it.hiof.no/~borres/gb/magicianprogs/Material.html ( with a simpler array-based method for presets).
*      http://www.kynd.info/log/?p=201
*/
import java.util.*;


/************************************************************************************
*
*  Material Class.
*
************************************************************************************/
public class Material
{
  
  public Vec4  ambient  ;
  public Vec4  diffuse  ;
  public Vec4  specular ;
  public Vec4  emissive ;
  public float shininess;
  
  public Material()
  {
    ambient  = new Vec4();
    diffuse  = new Vec4();
    specular = new Vec4();
    emissive = new Vec4();
    
    shininess = 0.0f; 
  }  
}


String[] materialNames = {"default", "emerald", "jade", "obsidian", "pearl", "ruby", "turquoise", "brass", "bronze", "chrome", "copper", "gold", "silver",
                          "black_plastic", "cyan_plastic", "green_plastic", "red_plastic", "white_plastic", "yellow_plastic",
                          "black_rubber", "cyan_rubber",  "green_rubber", "red_rubber", "white_rubber", "yellow_rubber",   
                          "reflex_red", "cool_white", "warm_white", "less_bright_white", "bright_white",};

int materialIndex = 0;



/************************************************************************************
*
*  MaterialPreset Class (just extend Material to have a name). 
*
************************************************************************************/
public class MaterialPreset extends Material
{
  public String name;

  public MaterialPreset(String name)
  {
    super();
    
    this.name = name;
  }    
}




/************************************************************************************
*
*  Materials Class   :  Named MaterialPresets Provider. 
*
************************************************************************************/
public class Materials
{
  public HashMap<String, MaterialPreset> materialPresets;
  
  public Materials()
  {
    materialPresets = new HashMap<String, MaterialPreset>();   
   
   createMaterials(); 
  }
  
  public Material getMaterial(String materialName)
  {
    return materialPresets.get(materialName);
  }
  
  private void createMaterials()
  {
      // default
      MaterialPreset mat = new MaterialPreset("default");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 0.8f,       0.8f,       0.8f,      1.0f  );
      mat.specular.set ( 0.0f,       0.0f,       0.0f,      1.0f  );
      mat.emissive.set ( 0.0f,       0.0f,       0.0f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);

    
    
      // EMERALD
      mat = new MaterialPreset("emerald");
      
      mat.ambient.set  ( 0.0215f,    0.1745f,    0.0215f,   1.0f  );
      mat.diffuse.set  ( 0.07568f,   0.61424f,   0.07568f,  1.0f  );
      mat.specular.set ( 0.633f,     0.727811f,  0.633f,    1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);
  
      
      // JADE
      mat = new MaterialPreset("jade");
      
      mat.ambient.set  ( 0.135f,     0.2225f,    0.1575f,    1.0f  );
      mat.diffuse.set  ( 0.54f,      0.89f,      0.63f,      1.0f  );  
      mat.specular.set ( 0.316228f,  0.316228f,  0.316228f,  1.0f );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,       1.0f  );
      mat.shininess = 0.1f;
        
      materialPresets.put(mat.name, mat);
      
      
      // OBSIDIAN
      mat = new MaterialPreset("obsidian");
      
      mat.ambient.set  ( 0.05375f,   0.05f,      0.06625f,  1.0f  );
      mat.diffuse.set  ( 0.18275f,   0.17f,      0.22525f,  1.0f  );
      mat.specular.set ( 0.332741f,  0.328634f,  0.346435f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.3f;
        
      materialPresets.put(mat.name, mat);      
      
      
      // PEARL
      mat = new MaterialPreset("pearl");
      
      mat.ambient.set  ( 0.25f,      0.20725f,   0.20725,  1.0f  );
      mat.diffuse.set  ( 1f,         0.829f,     0.829f,   1.0f  );
      mat.specular.set ( 0.296648f,  0.296648f,  0.296648, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.088f;
        
      materialPresets.put(mat.name, mat); 

      // Ruby
      mat = new MaterialPreset("ruby");
      
      mat.ambient.set  ( 0.1745f,    0.01175f,   0.01175f,  1.0f  );
      mat.diffuse.set  ( 0.61424f,   0.04136f,   0.04136,   1.0f  );
      mat.specular.set ( 0.727811f,  0.626959f,  0.626959,  1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);

      // Turquoise
      mat = new MaterialPreset("turquoise");
      
      mat.ambient.set  ( 0.1f ,      0.18725f,   0.1745f,   1.0f  );
      mat.diffuse.set  ( 0.396f,     0.74151f,   0.69102f,  1.0f  );
      mat.specular.set ( 0.297254f,  0.30829f,   0.306678f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.1f;
        
      materialPresets.put(mat.name, mat);

      // Brass
      mat = new MaterialPreset("brass");
      
      mat.ambient.set  ( 0.329412f,  0.223529f,  0.027451f, 1.0f  );
      mat.diffuse.set  ( 0.780392f,  0.568627f,  0.113725f, 1.0f  );
      mat.specular.set ( 0.992157f,  0.941176f,  0.807843f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.21794872f;
        
      materialPresets.put(mat.name, mat);

      // Bronze
      mat = new MaterialPreset("bronze");
      
      mat.ambient.set  ( 0.2125f,    0.1275f,    0.054f,    1.0f  );
      mat.diffuse.set  ( 0.714f,     0.4284f,    0.18144,   1.0f  );
      mat.specular.set ( 0.393548f,  0.271906f,  0.166721f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.2f;
        
      materialPresets.put(mat.name, mat);


      // Chrome
      mat = new MaterialPreset("chrome");
      
      mat.ambient.set  ( 0.25f,      0.25f,      0.25f,     1.0f  );
      mat.diffuse.set  ( 0.4f,       0.4f,       0.4f,      1.0f  );
      mat.specular.set ( 0.774597f,  0.774597f,  0.774597f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.6f;
        
      materialPresets.put(mat.name, mat);

     // Copper
      mat = new MaterialPreset("copper");
      
      mat.ambient.set  ( 0.19125f,   0.0735f,    0.0225f,   1.0f  );
      mat.diffuse.set  ( 0.7038f,    0.27048f,   0.0828f,   1.0f  );
      mat.specular.set ( 0.256777f,  0.137622f,  0.086014f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.1f;
        
      materialPresets.put(mat.name, mat);

    // Gold
      mat = new MaterialPreset("gold");
      
      mat.ambient.set  ( 0.24725f,   0.1995f,    0.0745f,   1.0f  );
      mat.diffuse.set  ( 0.75164f,   0.60648f,   0.22648f,  1.0f  );
      mat.specular.set ( 0.628281f,  0.555802f,  0.366065f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.4f;
        
      materialPresets.put(mat.name, mat);


    // Silver
      mat = new MaterialPreset("silver");
      
      mat.ambient.set  ( 0.19225f,   0.19225f,  0.19225f,   1.0f  );
      mat.diffuse.set  ( 0.50754f,   0.50754f,  0.50754f,   1.0f  );
      mat.specular.set ( 0.508273f,  0.508273f, 0.508273f,  1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.4f;
        
      materialPresets.put(mat.name, mat);


      // Black plastic
      mat = new MaterialPreset("black_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f,      1.0f  );
      mat.diffuse.set  ( 0.01f,      0.01f,      0.01f,     1.0f  );
      mat.specular.set ( 0.50f,      0.50f,      0.50f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // Cyan plastic
      mat = new MaterialPreset("cyan_plastic");
      
      mat.ambient.set  ( 0.0f,       0.1f,       0.06f,     1.0f  );
      mat.diffuse.set  ( 0.0f,       0.5098039f, 0.5098039f,1.0f  );
      mat.specular.set ( 0.5019608f, 0.5019608f, 0.5019608f,1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // green plastic
      mat = new MaterialPreset("green_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.1f,       0.35f,      0.1f,      1.0f  );
      mat.specular.set ( 0.45f,      0.55f,      0.45f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // Red plastic
      mat = new MaterialPreset("red_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.5f,       0.0f,       0.0f,      1.0f  );
      mat.specular.set ( 0.7f,       0.6f,       0.6f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // White plastic
      mat = new MaterialPreset("white_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.55f,      0.55f,      0.55f,     1.0f  );
      mat.specular.set ( 0.70f,      0.70f,      0.70f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);


      // Yellow plastic
      mat = new MaterialPreset("yellow_plastic");
      
      mat.ambient.set  ( 0.0f,       0.0f,       0.0f ,     1.0f  );
      mat.diffuse.set  ( 0.5f,       0.5f,       0.0f,      1.0f  );
      mat.specular.set ( 0.60f,      0.60f,      0.50f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.25f;
        
      materialPresets.put(mat.name, mat);

      // Black rubber
      mat = new MaterialPreset("black_rubber");
      
      mat.ambient.set  ( 0.02f,      0.02f,      0.02f,     1.0f  );
      mat.diffuse.set  ( 0.01f,      0.01f,      0.01f,     1.0f  );
      mat.specular.set ( 0.4f,       0.4f,       0.4f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Cyan rubber
      mat = new MaterialPreset("cyan_rubber");
      
      mat.ambient.set  ( 0.0f,       0.05f,      0.05f,     1.0f  );
      mat.diffuse.set  ( 0.4f ,      0.5f ,      0.5f,      1.0f  );
      mat.specular.set ( 0.04f,      0.7f,       0.7f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Green rubber
      mat = new MaterialPreset("green_rubber");
      
      mat.ambient.set  ( 0.0f,       0.05f,      0.0f,      1.0f  );
      mat.diffuse.set  ( 0.4f ,      0.5f ,      0.4f,      1.0f  );
      mat.specular.set ( 0.04f,      0.7f,       0.04f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Red rubber
      mat = new MaterialPreset("red_rubber");
      
      mat.ambient.set  ( 0.05f,      0.0f,       0.0f,      1.0f  );
      mat.diffuse.set  ( 0.5f ,      0.4f ,      0.4f,      1.0f  );
      mat.specular.set ( 0.7f,       0.04f,      0.04f,     1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);

      // White rubber
      mat = new MaterialPreset("white_rubber");
      
      mat.ambient.set  ( 0.05f,      0.05f,      0.05f,     1.0f  );
      mat.diffuse.set  ( 0.5f ,      0.5f ,      0.5f,      1.0f  );
      mat.specular.set ( 0.7f,       0.7f,       0.7f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


      // Yellow rubber
      mat = new MaterialPreset("yellow_rubber");
      
      mat.ambient.set  ( 0.05f,      0.05f,      0.0f,      1.0f  );
      mat.diffuse.set  ( 0.5f ,      0.5f ,      0.4f,      1.0f  );
      mat.specular.set ( 0.7f,       0.7f,       0.004f,    1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.078125f;
        
      materialPresets.put(mat.name, mat);


     // Reflex Red
      mat = new MaterialPreset("reflex_red");
      
      mat.ambient.set  ( 1.0f,       0.0f,       0.0f,      1.0f  );
      mat.diffuse.set  ( 1.0f,       0.04136f,   0.04136f,  1.0f  );
      mat.specular.set ( 1.0f,       0.626959f,  0.626959f, 1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.03f;
        
      materialPresets.put(mat.name, mat);


     // Cool white
      mat = new MaterialPreset("cool_white");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.3f,      1.0f  );
      mat.diffuse.set  ( 0.8f,       0.9f,       1.0f,      1.0f  );
      mat.specular.set ( 0.2f,       0.2f,       0.4f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);


     // Warm white
      mat = new MaterialPreset("warm_white");
      
      mat.ambient.set  ( 0.3f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 1.0f,       0.9f,       0.8f,      1.0f  );
      mat.specular.set ( 0.4f,       0.2f,       0.2f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);


     // Less Bright White
      mat = new MaterialPreset("less_bright_white");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 0.8f,       0.8f,       0.8f,      1.0f  );
      mat.specular.set ( 0.5f,       0.5f,       0.5f,      1.0f  );
      mat.emissive.set ( 0.1f,       0.1f,       0.1f,      1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);


     // Bright White
      mat = new MaterialPreset("bright_white");
      
      mat.ambient.set  ( 0.2f,       0.2f,       0.2f,      1.0f  );
      mat.diffuse.set  ( 1.0f,       1.0f,       1.0f,      1.0f  );
      mat.specular.set ( 0.5f,       0.5f,       0.5f,      1.0f  );
      mat.emissive.set ( 0.15f,      0.15f,      0.15f,     1.0f  );
      mat.shininess = 0.35f;
        
      materialPresets.put(mat.name, mat);
  }
  
  
  
};

































