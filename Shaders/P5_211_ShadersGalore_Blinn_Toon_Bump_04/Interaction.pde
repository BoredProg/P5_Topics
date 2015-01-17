void keyPressed()
{

  switch (key)
  {
    
    ////////////////////////////////////////////////////////////////////
    //  Set active Shader
    ////////////////////////////////////////////////////////////////////
    case '0':
      activeShader = perPixelLightShader;
      break;

    case '1':
      activeShader = blinnShader;
      break;
      
    case '2':
      activeShader = toonShader;
      break;

    case '3':
      activeShader = bumpMapShader;
      break;      

    case '4':
      activeShader = goochShader;
      break;      

    case '5':
      activeShader = adaptiveAaShader;
      break;      

    case '6':
      activeShader = latticeShader;
      break;      

    case '7':
      activeShader = wardIsotropicShader;
      break;      

    case '8':
      activeShader = minnaertWardShader;
      break;      

    case '9':
      activeShader = wiggleShader;
      break;      

    case '.':
      activeShader = brickShader;
      break;      

    ////////////////////////////////////////////////////////////////////
    //  Set active Material
    ////////////////////////////////////////////////////////////////////


    case '/':
      materialIndex--;    
      materialIndex = materialIndex <0 ? materialNames.length -1 : materialIndex;   
      break;      


    case '*':
      materialIndex ++;    
      materialIndex = materialIndex <= materialNames.length -1 ? materialIndex : 0;       
      break;      

    
    default:
      break;
  }
  
  // Sets the frame title to display active shader name
  // and active Material
  setFrameTitle();
 
};




/**
* Sets the frame title to display active shader name
* and active Material
*/
private void setFrameTitle()
{
    // Set shader name (for display)
  String shaderName = "";  
  String frameTitle;
  
  if (activeShader == perPixelLightShader)
  {
    shaderName = "Per Pixel Lighting (P5)";
  }
  else if (activeShader == blinnShader)
  {
    shaderName = "Blinn-Phong Lighting (GL)";  
  }
  else if (activeShader == toonShader)
  {
     shaderName = "Toon Shader (GL)";    
  }
  else if (activeShader == bumpMapShader)
  {
    shaderName = "Bump Map Shader (GL)";
  }
  else if (activeShader == goochShader)
  {
    shaderName = "Gooch Shader (GL)";
  }
  else if (activeShader == adaptiveAaShader)
  {
    shaderName = "Adaptive AA (GL)";
  }
  else if (activeShader == latticeShader)
  {
    shaderName = "Lattice Shader (GL)";
  }
  else if (activeShader == wardIsotropicShader)
  {
    shaderName = "Ward Isotropic Shader (GL)";
  }
  else if (activeShader == minnaertWardShader)
  {
    shaderName = "Minnaert Ward Shader (GL)";
  }
  else if (activeShader == wiggleShader)
  {
    shaderName = "Wiggle Shader (GL)";
  }
  else if (activeShader == brickShader)
  {
    shaderName = "Bricks Shader (GL)";
  }
 
  else
  {
    shaderName = "NO_SHADER";
  }
  
  // Sets the frame's Title.
  frameTitle = "FPS : " + (int)frameRate + ", Material : " + materialNames[materialIndex] + ", Shader : " + shaderName;
  frame.setTitle(frameTitle);
  
  text(frameTitle, 15, 15);
}










