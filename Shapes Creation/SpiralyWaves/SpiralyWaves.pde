import processing.opengl.*; 
  
//----------------------------------------------------------------------  ------- 
//variables 
//----------------------------------------------------------------------  ------- 
float abstand; 
int zmax, zmin; 
 
float WAVE_SEGMENTS = 32; 
float WAVE_SPEED = 1.0; 
 
ArrayList waves; 
  
void setup(){ 
  size(600, 600, OPENGL); 
  noFill(); 
  
  abstand = 5; 
 
  zmax = int(WAVE_SEGMENTS / 2); 
  zmin = -zmax; 
   
  waves = new ArrayList(); 
  for (int i = 0; i < WAVE_SEGMENTS; i++) { 
     
    float r = map(i, 0, WAVE_SEGMENTS, 0, 255); 
    float g = map(i, 0, WAVE_SEGMENTS, 255, 0); 
    float b = 255; 
     
    waves.add(new Wave(i, (i - zmax) * abstand, i * 10,  r, g, b)); 
  } 
   
} 
 
void draw(){ 
  background(0); 
  
  stroke(50); 
  line(width * 0.5, 0, width * 0.5, height); 
  line(0, height * 0.5, width, height * 0.5); 
  
  translate(width * 0.5, height * 0.5); 
  
  rotateY(radians(map(mouseX, 0, width, 0, 360))); 
 
  for (Iterator itWaves = waves.iterator(); itWaves.hasNext();) 
  { 
    Wave w = (Wave)itWaves.next(); 
     
    pushMatrix(); 
 rotate(radians(90)); 
 translate(0, 0, w.axis); 
 stroke(w.style); 
 ellipse(0, 0, w.diameter, w.diameter); 
    popMatrix(); 
     
    float dist = abs(w.axis); 
    float peak = abstand * (zmax - 1); 
    float speed = WAVE_SPEED * (1 - (dist / (peak * 2)) * 1.1); 
 
    if (w.direction) { 
 w.axis += speed; 
  
 if (w.axis > peak) { 
   w.axis = peak; 
   w.direction = !w.direction; 
 } 
    
    } else { 
 w.axis -= speed; 
  
 if (w.axis < -peak) { 
   w.axis = -peak; 
   w.direction = !w.direction; 
 } 
    } 
 
  } 
 
}  
 
public class Wave 
{ 
  public int index = 0; 
  public float axis = 0.0; 
   
  public boolean direction = true; 
   
  public float diameter = 10.0; 
  public color style = #ffffff; 
   
  public Wave(int index, float axis, float diameter, float r, float g, float b) 
  { 
    this.index = index; 
    this.axis = axis; 
    this.diameter = diameter; 
    this.style = color(r, g, b); 
  } 
}
