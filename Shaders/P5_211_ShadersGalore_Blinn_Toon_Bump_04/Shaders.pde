
/**************************************************************************************
*
*  Blinn-Phong Shader
*
*
**************************************************************************************/


String[] blinnShaderVertexCode = {

"#define MAX_LIGHTS 8",  

"varying vec3 normal, eyeVec;",
"varying vec3 lightDir[MAX_LIGHTS];",

"uniform int numLights;",

"void main()",
"{"  ,
  "gl_Position = ftransform();",    
  "normal = gl_NormalMatrix * gl_Normal;",
  "vec4 vVertex = gl_ModelViewMatrix * gl_Vertex;",
  "eyeVec = -vVertex.xyz;",
  "int i;",
  "for (i=0; i<numLights; ++i)",
  "{",
    "lightDir[i] = vec3(gl_LightSource[i].position.xyz - vVertex.xyz);",
  "}",
"}"};


String[] blinnShaderFragmentCode = { 


"#define MAX_LIGHTS 8",
"varying vec3 normal;",
"varying vec3 eyeVec;",
"varying vec3 lightDir[MAX_LIGHTS];",

"uniform int numLights;",

"void main (void)",
"{",
"  vec4 final_color = gl_FrontLightModelProduct.sceneColor;",
"  vec3 N = normalize(normal);",
"  int i;",
"  for (i=0; i<numLights; ++i)",
"  {  ",
"    vec3 L = normalize(lightDir[i]);",
"    float lambertTerm = dot(N,L);",
"    if (lambertTerm > 0.0)",
"    {",
"      final_color += gl_LightSource[i].diffuse * gl_FrontMaterial.diffuse * lambertTerm;  ",
      
"      vec3 E = normalize(eyeVec);",
"      vec3 R = reflect(-L, N);",
"      float specular = pow(max(dot(R, E), 0.0), gl_FrontMaterial.shininess);",
"      final_color += gl_LightSource[i].specular * gl_FrontMaterial.specular * specular;  ",
"    }",
"  }",
"",
"  gl_FragColor = final_color;",      
"}"};


/**************************************************************************************
*
*  Toon Shader
*
*
**************************************************************************************/



String[] toonShaderVertexCode =  {  
                                    "varying vec3 eyeSpaceNormal;",
                                    
                                    "void main()",
                                    "{",
                                    "  eyeSpaceNormal = gl_NormalMatrix * gl_Normal;",
                                    "  gl_Position    = ftransform();", 
                                    "}"
                                  };
                                  

String[] toonShaderFragmentCode = {
                                  
                                    "varying vec3 eyeSpaceNormal;",
                                    
                                    "vec4 toonify(in float intensity)",
                                    "{",
                                    "  if (intensity > 0.95)",
                                    "    return vec4(0.5, 1.0, 0.5, 1.0);",
                                    "" ,
                                    " else if (intensity > 0.5)",
                                    "    return vec4(0.3, 0.6, 0.3, 1.0);",
                                    "",
                                    " else if (intensity > 0.25)",
                                    "    return vec4(0.2, 0.4, 0.2, 1.0);",
                                    "",
                                    "  else", 
                                    "    return vec4(0.1, 0.2, 0.1, 1.0);",
                                    "}",
                                    
                                    "void main()",
                                    "{",
                                    "  vec3 normal = normalize(eyeSpaceNormal);",
                                    
                                    "  float intensity = dot(normalize(gl_LightSource[0].position.xyz), normal);",
                                    
                                       // or, to mix the color material with the final color..
                                       //"  gl_FragColor   = toonify(intensity) + gl_FrontMaterial.diffuse ;", 
                                       
                                      "  gl_FragColor   = toonify(intensity) + gl_FrontMaterial.diffuse / 2;",    
                                    "}",
                                    };
                                    


                                    
                                    
/**************************************************************************************
*
*  BumpMap Shader
*
*
**************************************************************************************/

                                    
                                    
String[] bumpMapShaderVertexCode = 
                      {
                        "attribute vec3 tangent;" , 
                        "attribute vec3 binormal;" ,                         
                        "uniform float invRad;" ,
                        
                        "varying  vec3 g_lightVec;" ,
                        "varying  vec3 g_viewVec;" ,                          

                        "void main()" ,
                        "{" ,
                        "gl_Position      = ftransform();" ,
                        "gl_TexCoord[0]   = gl_MultiTexCoord0;" ,
                        "mat3 TBN_Matrix  = gl_NormalMatrix * mat3(tangent, binormal, gl_Normal);" ,
                        "vec4 mv_Vertex   = gl_ModelViewMatrix * gl_Vertex;" ,
                        "g_viewVec        = vec3(-mv_Vertex) * TBN_Matrix ;  " ,
                        
                        "vec4 lightEye    = gl_ModelViewMatrix *  gl_LightSource[0].position;" ,
                        "vec3 lightVec    = 0.02* (lightEye.xyz - mv_Vertex.xyz);  " ,
                        "g_lightVec       = lightVec * TBN_Matrix; " ,
                        "}"
                        };


// Shiny.frag
String[] bumpMapShaderFragmentCode = 
                          {
                            "uniform sampler2D NormalHeight; "  ,
                            "uniform sampler2D Base;" , 
                            
                            "varying vec3 g_lightVec;" ,
                            "varying vec3 g_viewVec;" ,
                            
                            "uniform vec2     BumpSize;//   = 0.02 * vec2 (2.0, -1.0);",
                            
                            "void main()" , 
                            "{" , 
                            "float LightAttenuation  = clamp(1.0 - dot(g_lightVec, g_lightVec), 0.0, 1.0);" , 
                            "vec3 lightVec           = normalize(g_lightVec);" , 
                            "vec3 viewVec            = normalize(g_viewVec);" , 
                            "float height            = texture2D(NormalHeight, gl_TexCoord[0].xy).a;" , 
                            "height                  = height * BumpSize.x + BumpSize.y;" , 
                            
                            "vec2 newUV       = gl_TexCoord[0].xy + viewVec.xy * height;" , 
                            "vec4 color_base  = texture2D(Base,newUV);" , 
                            "vec3 bump        = texture2D(NormalHeight, newUV.xy).rgb * 2.0 - 1.0;" , 
                            "bump             = normalize(bump);" ,                             
                            "float base       = 0.02 + (0.7 * texture2D(NormalHeight, newUV.xy).a);" ,
                            "float diffuse    = clamp(dot(lightVec, bump), 0.0, 1.0);" , 
                            "float specular   = pow(clamp(dot(reflect(-viewVec, bump), lightVec), 0.0, 1.0), 16.0);" ,
                            
                            // initial line that does not take material into account.
                           //"gl_FragColor     = vec4(color_base.rgb * gl_LightSource[0].diffuse.rgb * (diffuse * base + 0.7 * specular * color_base.a) * 1.0,1.0);", 
                            
                            // Line that takes coloring into account.
                            "gl_FragColor     = vec4(color_base.rgb * gl_LightSource[0].diffuse.rgb * (diffuse * base + 0.7 * specular * color_base.a) * 1.0,1.0) * gl_FrontMaterial.diffuse;" , 
                            "}" 
                          };          




/**************************************************************************************
*
*  Per-Pixel Lighting Shader
*
*
**************************************************************************************/


String[] perPixelShaderVertexCode = 
                {

                "#define PROCESSING_LIGHT_SHADER",
                
                "uniform mat4 modelview;",
                "uniform mat4 transform;",
                "uniform mat3 normalMatrix;",
                
                "uniform vec4 lightPosition;",
                "uniform vec3 lightNormal;",
                
                "attribute vec4 vertex;",
                "attribute vec4 color;",
                "attribute vec3 normal;",
                
                "varying vec4 vertColor;",
                "varying vec3 ecNormal;",
                "varying vec3 lightDir;",
                
                "void main() {",
                "  gl_Position = transform * vertex;",    
                "  vec3 ecVertex = vec3(modelview * vertex);",  
                  
                "  ecNormal = normalize(normalMatrix * normal);",
                "  lightDir = normalize(lightPosition.xyz - ecVertex);",  
                "  vertColor = color;",
                "}",
              };

String[] perPixelShaderFragmentCode = 
{

                "#ifdef GL_ES",
                "precision mediump float;",
                "precision mediump int;",
                "#endif",
                
                "varying vec4 vertColor;",
                "varying vec3 ecNormal;",
                "varying vec3 lightDir;",
                
                "void main() {  ",
                "  vec3 direction = normalize(lightDir);",
                "  vec3 normal = normalize(ecNormal);",
                "  float intensity = max(0.0, dot(direction, normal));",
                "  gl_FragColor = vec4(intensity, intensity, intensity, 1) * vertColor;",
                "}",  

  
};



/**************************************************************************************
*
*    Gooch NPR Shader
*
*   Copyright (C) 2007 Dave Griffiths
*   Fluxus Shader Library
*   ---------------------
*   Gooch NPR Shading Model
*   Orginally for technical drawing style 
*   rendering, uses warm and cool colours
*   to depict shading to keep detail in the
*   shadowed areas
*
*  See : https://code.google.com/p/qshaderedit/source/browse/trunk/shaders/gooch.glsl?r=208
*
**************************************************************************************/

String[] goochShaderVertexCode = 
              {
                "uniform vec3  LightPosition;  // (0.0, 10.0, 4.0)", 
                
                "varying float NdotL;",
                "varying vec3  ReflectVec;",
                "varying vec3  ViewVec;",
                
                "void main()",
                "{",
                "    vec3 ecPos      = vec3(gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - ecPos);",
                "    ReflectVec      = normalize(reflect(-lightVec, tnorm));",
                "    ViewVec         = normalize(-ecPos);",
                "    NdotL           = (dot(lightVec, tnorm) + 1.0) * 0.5;",
                "    gl_Position     = ftransform();",
                "}",
              }; 
                
String[] goochShaderFragmentCode = 
              {
                "uniform vec3  SurfaceColor; // (0.75, 0.75, 0.75)",
                "uniform vec3  WarmColor;    // (0.6, 0.6, 0.0)",
                "uniform vec3  CoolColor;    // (0.0, 0.0, 0.6)",
                "uniform float DiffuseWarm;  // 0.45",
                "uniform float DiffuseCool;  // 0.45",
                
                "varying float NdotL;",
                "varying vec3  ReflectVec;",
                "varying vec3  ViewVec;",
                
                "void main()",
                "{",
                "    vec3 kcool    = min(CoolColor + DiffuseCool * SurfaceColor, 1.0);",
                "    vec3 kwarm    = min(WarmColor + DiffuseWarm * SurfaceColor, 1.0);", 
                "    vec3 kfinal   = mix(kcool, kwarm, NdotL);",
                
                "    vec3 nreflect = normalize(ReflectVec);",
                "    vec3 nview    = normalize(ViewVec);",
                
                "    float spec    = max(dot(nreflect, nview), 0.0);",
                "    spec          = pow(spec, 32.0);",
                
                "    gl_FragColor = vec4(min(kfinal + spec, 1.0), 1.0);",
                "}",
              };



/**************************************************************************************
*
*    Adaptive AA Shader
*
*   Copyright (C) 2007 Dave Griffiths
*   Fluxus Shader Library
*   ---------------------
*  
*  Shader for adaptively antialiasing a procedural stripe pattern
*
*  See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/adaptiveaa.glsl
*
**************************************************************************************/

String[] adaptiveAaShaderVertexCode = 
{

                "uniform vec3  LightPosition;",
                
                "varying float V;",
                "varying float LightIntensity;",
                 
                "void main()",
                "{",
                "    vec3 pos        = vec3(gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - pos);",
                
                "    LightIntensity = max(dot(lightVec, tnorm), 0.0);",
                
                "    V = gl_MultiTexCoord0.s;  // try .s for vertical stripes",
                
                "    gl_Position = ftransform();",
                "}",  
};



String[] adaptiveAaShaderFragmentCode = 
{
                "varying float V;                    // generic varying",
                "varying float LightIntensity;",
                
                "uniform float Frequency;            // Stripe frequency = 16",
                
                "void main()",
                "{",
                "    float sawtooth = fract(V * Frequency);",
                "    float triangle = abs(2.0 * sawtooth - 1.0);",
                "    float dp = length(vec2(dFdx(V), dFdy(V)));",
                "    float edge = dp * Frequency * 2.0;",
                "    float square = smoothstep(0.5 - edge, 0.5 + edge, triangle);",
                "    gl_FragColor = vec4(vec3(square), 1.0) * LightIntensity;",
                "}",
};





/**************************************************************************************
*
*    Lattice Shader
*
*   Copyright (C) 2007 Dave Griffiths
*   Fluxus Shader Library
*   ---------------------
*  See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/lattice.glsl
* 
*  Parameters :
*  ------------
*    vec3 Ambient = vec3(0.1, 0.1, 0.1);
*    vec3 EyePosition = vec3(0, 0, 0);
*    float Kd = 1;
*    vec3 LightColor = vec3(1, 1, 1);
*    vec3 LightPosition = vec3(0, 10, 4);
*    vec2 Scale = vec2(5, 5);
*    vec3 Specular = vec3(0, 1, 0);
*    vec3 SurfaceColor = vec3(1, 1, 0);
*    vec2 Threshold = vec2(0.2, 0.2);
**************************************************************************************/

String[] latticeShaderVertexCode = 
{
                "uniform vec3  LightPosition;",
                "uniform vec3  LightColor;",
                "uniform vec3  EyePosition;",
                "uniform vec3  Specular;",
                "uniform vec3  Ambient;",
                "uniform float Kd;",
                
                "varying vec3  DiffuseColor;",
                "varying vec3  SpecularColor;",
                
                "void main()",
                "{",
                "    vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - ecPosition);",
                "    vec3 viewVec    = normalize(EyePosition - ecPosition);",
                "    vec3 Hvec       = normalize(viewVec + lightVec);",
                
                "    float spec = abs(dot(Hvec, tnorm));",
                "    spec = pow(spec, 16.0);",
                
                "    DiffuseColor    = LightColor * vec3 (Kd * abs(dot(lightVec, tnorm)));",
                "    DiffuseColor    = clamp(Ambient + DiffuseColor, 0.0, 1.0);",
                "    SpecularColor   = clamp((LightColor * Specular * spec), 0.0, 1.0);",
                
                "    gl_TexCoord[0]  = gl_MultiTexCoord0;",
                "    gl_Position     = ftransform();",
                "}",
};


String[] latticeShaderFragmentCode = 
{
                "varying vec3  DiffuseColor;",
                "varying vec3  SpecularColor;",
                
                "uniform vec2  Scale;",
                "uniform vec2  Threshold;",
                "uniform vec3  SurfaceColor;",
                
                "void main()",
                "{",
                "    float ss = fract(gl_TexCoord[0].s * Scale.s);",
                "    float tt = fract(gl_TexCoord[0].t * Scale.t);",
                
                "    if ((ss > Threshold.s) && (tt > Threshold.t)) discard;",
                
                "    vec3 finalColor = SurfaceColor * DiffuseColor + SpecularColor;",
                "    gl_FragColor = vec4(finalColor, 1.0);",
                "}",
  
};



/**************************************************************************************
*
*    Ward Isotropic Shader
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/sancho/wardisotropic.glsl
***************************************************************************************/

String[] wardIsotropicShaderVertexCode = 
{
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "void main() {",
                "  gl_Position = ftransform();",
                "  v_V = (gl_ModelViewMatrix * gl_Vertex).xyz;",
                "  v_N = gl_NormalMatrix * gl_Normal;",
                "}",  
};


String[] wardIsotropicShaderFragmentCode = 
{
                "#version 110",
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "const float roughness = 0.05;",
                
                "void main()", 
                "{",
                "  vec3 N = normalize(v_N);",
                "  vec3 V = normalize(v_V);",
                "  vec3 R = reflect(V, N);",
                "  vec3 L = normalize(vec3(gl_LightSource[0].position));",
                "  vec3 Nf = faceforward(N, V, N);",
                "  vec3 Vf = -V;",
                "  vec3 H = normalize(L+Vf);",
                "  float ndoth = dot(Nf, H);",
                "  float ndotl = dot(Nf, L);",
                "  float ndotv = dot(Nf, Vf);",
                "  float delta = acos(ndoth);",
                "  float tandelta = tan(delta);",
                "  float secta = exp( -( pow( tandelta, 2.0) / pow( roughness, 2.0)));",
                "  float sectb = 1.0 / sqrt( ndotl * ndotv );",
                "  float sectc = 1.0 / ( 4.0 * pow( roughness, 2.0) );",
                
                "  vec4 ambient = gl_FrontMaterial.ambient;",
                "  vec4 diffuse = gl_FrontMaterial.diffuse * max(dot(L, N), 0.0);",
                "  vec4 specular = gl_FrontMaterial.specular * (sectc * secta * sectb);",
                
                "  gl_FragColor = ambient + diffuse + specular;",
                "}",  
  
};


/**************************************************************************************
*
*    Minnaert Ward Shader
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/sancho/minnaertward.glsl
*
*    Parameters :
*    ------------
*    float ior = 1.9;
*    float k = 1.5;
*    float roughness = 0.15;
*
***************************************************************************************/

String[] minnaertWardShaderVertexCode = 
{
                "#version 110",
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "void main()", 
                "{",
                "  gl_Position = ftransform();",
                "  v_V = (gl_ModelViewMatrix * gl_Vertex).xyz;",
                "  v_N = gl_NormalMatrix * gl_Normal;",
                "}",  
};



String[] minnaertWardShaderFragmentCode = 
{


                "#version 110",
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "uniform float k; // minnaert roughness  1.5",
                "uniform float roughness; // Ward isotropic specular roughness 0.2",
                "uniform float ior; // Schlick's fresnel approximation index of refraction 1.5",
                
                "// Minnaert limb darkening diffuse term",
                "vec3 minnaert( vec3 L, vec3 Nf, float k)", 
                "{",
                "  float ndotl = max( 0.0, dot(L, Nf));",
                "  return gl_LightSource[0].diffuse.rgb * pow( ndotl, k);",
                "}",
                
                "// Ward isotropic specular term",
                "vec3 wardiso( vec3 Nf, vec3 Ln, vec3 Hn, float roughness, float ndotv )", 
                "{",
                "  float ndoth = dot( Nf, Hn);",
                "  float ndotl = dot( Nf, Ln);",
                "  float tandelta = tan( acos(ndoth));",
                "  return gl_LightSource[0].specular.rgb",
                "    * exp( -( pow( tandelta, 2.0) / pow( roughness, 2.0)))",
                "    * (1.0 / sqrt( ndotl * ndotv ))",
                "    * (1.0 / (4.0 * pow( roughness, 2.0)));",
                "}",
                  
                "float schlick( vec3 Nf, vec3 Vf, float ior, float ndotv )", 
                "{",
                "  float kr = (ior-1.0)/(ior+1.0);",
                "  kr *= kr;",
                "  return kr + (1.0-kr)*pow( 1.0 - ndotv, 5.0);",
                "}",
                  
                "void main()", 
                "{",
                "  vec3 N = normalize(v_N);",
                "  vec3 V = normalize(v_V);",
                "  vec3 L = normalize(vec3(gl_LightSource[0].position));",
                "  vec3 Vf = -V;",
                "  float ndotv = dot(N, Vf);",
                "  vec3 H = normalize(L+Vf);",
                
                "  vec3 ambient = gl_FrontMaterial.ambient.rgb;",
                "  vec3 diffuse = gl_FrontMaterial.diffuse.rgb * minnaert( L, N, k);",
                "  float fresnel = schlick( N, V, ior, ndotv);",
                "  vec3 specular = gl_FrontMaterial.specular.rgb * wardiso( N, L, H, roughness, ndotv) * fresnel;",
                
                "  gl_FragColor = vec4( ambient + diffuse + specular, 1.0);",
                "}",

};



/**************************************************************************************
*
*    Wiggle Shader
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/wiggle.glsl
*
*    Parameters  :
*    -------------
*        vec2 freq = vec2(2, 2.5);
*        vec2 scale = vec2(0.5, 0.2);
*
**************************************************************************************/

String[] wiggleShaderVertexCode = 
{
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "uniform float time;",
                "uniform vec2 freq;",
                "uniform vec2 scale;",
                
                "void main ()", 
                "{",
                "  float wiggleX = sin(gl_Vertex.x * freq.x + time) * scale.x;",
                "  float wiggleY = cos(gl_Vertex.y * freq.y + time) * scale.y;",
                
                "  gl_Position = gl_ModelViewProjectionMatrix * vec4(gl_Vertex.x + wiggleY, gl_Vertex.y + wiggleX, gl_Vertex.z, gl_Vertex.w);",
                "  v_V = (gl_ModelViewMatrix * gl_Vertex).xyz;",
                "  v_N = gl_NormalMatrix * gl_Normal;",
                "}",  
};


String[] wiggleShaderFragmentCode = 
{
                "varying vec3 v_V;",
                "varying vec3 v_N;",
                
                "void main ()", 
                "{",
                "  vec3 N = normalize(v_N);",
                "  vec3 V = normalize(v_V);",
                "  vec3 R = reflect(V, N);",
                "  vec3 L = normalize(vec3(gl_LightSource[0].position));",
                
                "  vec3 ambient = vec3(0.1, 0.0, 0.0);",
                "  vec3 diffuse = vec3(1.0, 0.0, 0.0) * max(dot(L, N), 0.0);",
                "  vec3 specular = vec3(1.0, 1.0, 1.0) * pow(max(dot(R, L), 0.0), 8.0);",
                
                "  gl_FragColor = vec4(ambient + diffuse + specular, 1.0);",
                "}",  
};



/**************************************************************************************
*
*    Brick Shader, shader for procedural bricks
*
*    See : https://code.google.com/p/qshaderedit/source/browse/trunk/data/shaders/brick.glsl
*
*    Parameters  :
*    -------------
*        vec3 BrickColor = vec3(1, 0.3, 0.2);
*        vec2 BrickPct = vec2(0.9, 0.85);
*        vec2 BrickSize = vec2(0.3, 0.15);
*        vec3 LightPosition = vec3(0, 0, 4);
*        vec3 MortarColor = vec3(0.85, 0.86, 0.84);
*
**************************************************************************************/

String[] brickShaderVertexCode = 
{
  
                "uniform vec3 LightPosition;",
                
                "const float SpecularContribution = 0.3;",
                "const float DiffuseContribution  = 1.0 - SpecularContribution;",
                
                "varying float LightIntensity;",
                "varying vec2  MCposition;",
                
                "void main(void)", //////////////////////
                "{",
                "    vec3 ecPosition = vec3 (gl_ModelViewMatrix * gl_Vertex);",
                "    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);",
                "    vec3 lightVec   = normalize(LightPosition - ecPosition);",
                "    vec3 reflectVec = reflect(-lightVec, tnorm);",
                "    vec3 viewVec    = normalize(-ecPosition);",
                "    float diffuse   = max(dot(lightVec, tnorm), 0.0);",
                "    float spec      = 0.0;",
                
                "    if (diffuse > 0.0)",
                "    {",
                "        spec = max(dot(reflectVec, viewVec), 0.0);",
                "        spec = pow(spec, 16.0);",
                "    }",
                
                "    LightIntensity  = DiffuseContribution * diffuse + SpecularContribution * spec;",
                
                "    MCposition      = gl_Vertex.xz;",
                "    gl_Position     = ftransform();",
                "}",  
  
};


String[] brickShaderFragmentCode = 
{
                "uniform vec3  BrickColor;",
                "uniform vec3  MortarColor;",
                "uniform vec2  BrickSize;",
                "uniform vec2  BrickPct;",
                
                "varying vec2  MCposition;",
                "varying float LightIntensity;",
                
                "void main(void)",
                "{",
                "    vec3  color;",
                "    vec2  position, useBrick;",
                    
                "    position = MCposition / BrickSize;",
                
                "    if (fract(position.y * 0.5) > 0.5)",
                "    {",
                "        position.x += 0.5;",
                "    }",
                "    position = fract(position);",
                
                "    useBrick = step(position, BrickPct);",
                
                "    color  = mix(MortarColor, BrickColor, useBrick.x * useBrick.y);",
                "    color *= LightIntensity;",
                
                "    gl_FragColor = vec4 (color, 1.0);",
                
                "}",
};





















                          
