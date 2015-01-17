import processing.opengl.*;

ImageShape2D[] _imageShapes;

PImage _images[]; 
String _paths[];

float _floorLevel;
float _floorColor;

void setup() 
{ 
  size(800,800,OPENGL); 
  background(0);
  loadImages();
  loadShapes();
  //noLoop();
  smooth();
  

} 

float rot = 0.1f;
int _background = 255;


void draw() 
{ 
  background( _background );
  
  translate(-mouseX* 1.9, -mouseY, 0);
  //rotateY(radians(mouseY/5));
  //rot+=0.3f;
  
  
  for (int i=0; i< _images.length-1; i++)
  {
     //rotateY(radians(1));
    _imageShapes[i].render();
  }
  

}  

/**
* Creates the ImageShape from the loaded images.
*/
void loadShapes()
{
  _imageShapes = new ImageShape2D[_images.length - 1];
  
  for (int i=0; i< _images.length-1; i++)
  {
    _imageShapes[i] = new ImageShape2D( this, 
                                        _images[i],
                                        new Point2D(10 + (i*260),400), 
                                        200, 200, 
                                        _background);
  }
}


/**
* Loads the images specified in the "imagesXX.txt" 
* in the data folder. 
* These images points to MyDocs\Processing art\Dundas.
* All pics are 400x320.
*/
void loadImages()
{
   // all pics are 400x320..
   _paths = loadStrings("images10.txt");
   //_paths = loadStrings("heavy5.txt");

   _images = new PImage[ _paths.length ];
   for (int i=0; i < _paths.length; i++) 
   {
      _images[i] = loadImage( _paths[i] );        
   }   
}
