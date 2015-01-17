/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/17416*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
PImage prova;
PImage aux01;

void setup() {
  size(410, 308); 
  prova = loadImage("rosa.jpg");
 
 

 
 
// loadPixels();
 }



void draw( ) {
    
 image(prova,0,0);
 translate(350,10);
rotate(PI/2);
 aux01=prova.get(mouseX,mouseY,70,70);
 image(aux01,mouseX,mouseY,100,100);




}

void mousePressed( ) {
    
}
void mouseReleased( ) {
    
}


