uniform mat4 projection;
uniform mat4 modelview;
uniform mat3 normalMatrix;
 
uniform vec3 lightPos;
 
attribute vec4 vertex;
attribute vec4 color;
attribute vec2 offset;
 
varying vec4 vertColor;
 
void main() {
  vec4 pos = modelview * vertex;
  vec4 clip = projection * pos;
  gl_Position = clip + projection * vec4(offset, 0, 0);
 
  vec3 normal = vec3(0, 0, 1);
  vec3 ecVertex = pos.xyz + vec3(offset, 0);  
  vec3 ecNormal = normalize(normalMatrix * normal);  
 
  vec3 direction = normalize(lightPos.xyz - ecVertex);     
  float intensity = max(0.0, dot(direction, ecNormal));
  vertColor = vec4(intensity, intensity, intensity, 1) * color;  
}