import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P151_ReflectedImage extends PApplet {



ImageShape2D[] _imageShapes;

PImage _images[]; 
String _paths[];

float _floorLevel;
float _floorColor;

public void setup() 
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


public void draw() 
{ 
  background( _background );
  
  translate(-mouseX* 1.9f, -mouseY, 0);
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
public void loadShapes()
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
public void loadImages()
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
class GradientImage extends PImage
{
    PApplet parent;
    int color1, color2;
    
    public GradientImage (PApplet parent, int theWidth, int theHeight )
    {
        super(theWidth, theHeight);
        this.parent = parent;
        
        color1 = 0xFF000000;
        color2 = 0xFFFFFFFF;
    }
    
    public GradientImage (PApplet parent, int theWidth, int theHeight, int _c1, int _c2 )
    {
        super(theWidth, theHeight);
        this.parent = parent;
        color1 = _c1;
        color2 = _c2;
    }
    
    public void vertical ()
    {
        float as = (((color2 >> 24) & 0xFF) - ((color1 >> 24) & 0xFF)) / this.height;
        float rs = (((color2 >> 16) & 0xFF) - ((color1 >> 16) & 0xFF)) / this.height;
        float gs = (((color2 >>  8) & 0xFF) - ((color1 >>  8) & 0xFF)) / this.height;
        float bs = (((color2 >>  0) & 0xFF) - ((color1 >>  0) & 0xFF)) / this.height;
        
        for ( int ih=0; ih < this.height; ih++ )
        {
            
            int c = color( ((color1 >> 16) & 0xFF) + parent.round(rs * ih),
                           ((color1 >>  8) & 0xFF) + parent.round(gs * ih),
                           ((color1 >>  0) & 0xFF) + parent.round(bs * ih),
                           ((color1 >> 24) & 0xFF) + parent.round(as * ih)
                          );
            for ( int iw=0; iw < this.width; iw++ )
            {
                this.pixels[iw+(ih*this.width)] = c;
            }
        }   
    }
    
    
    public void horizontal ()
    {
        float as = (((color2 >> 24) & 0xFF) - ((color1 >> 24) & 0xFF)) / this.width;
        float rs = (((color2 >> 16) & 0xFF) - ((color1 >> 16) & 0xFF)) / this.width;
        float gs = (((color2 >>  8) & 0xFF) - ((color1 >>  8) & 0xFF)) / this.width;
        float bs = (((color2 >>  0) & 0xFF) - ((color1 >>  0) & 0xFF)) / this.width;
        
        for ( int iw=0; iw < this.width; iw++ )
        {
            int c = color( ((color1 >> 16) & 0xFF) + parent.round(rs * iw),
                           ((color1 >>  8) & 0xFF) + parent.round(gs * iw),
                           ((color1 >>  0) & 0xFF) + parent.round(bs * iw),
                           ((color1 >> 24) & 0xFF) + parent.round(as * iw)
                          );
            for ( int ih=0; ih < this.height; ih++ )
            {
                this.pixels[iw+(ih*this.width)] = c;
            }
        }   
    }
}
public class ImageShape2D
{
   PApplet   _parent;
   PImage    _image;
   PImage    _reflectionImage;
   int       _reflectionHeight = 50;
   float     _width;
   float     _height;
   int       _backColor;   
   Point2D   _location;

   /**
    * Constructor
    */
   public ImageShape2D(PApplet parent, PImage img, Point2D location, float imageWidth, float imageHeight, int backColor)
   {
      _parent    = parent;
      _location  = location;
      _image     = img;
      _width     = imageWidth;
      _height    = imageHeight;
      _backColor = backColor;
      
      generateReflectionImage();
   }

   public void render()
   {
      renderImage();
      renderReflectionImage();
   }


   private void renderImage()
   {
      // alpha blended white frame around picture.
      strokeWeight(1);
      stroke(255);
      //stroke(_background);      
      //noStroke();
      textureMode(NORMALIZED);
      
      pushMatrix();
         
         translate( _location.X(), _location.Y());      
         beginShape();
         
         texture(_image);
         
         
         // The first 3 coordinates are x,y,z and the last two u,v for 
         // the texture (0 to 100 in each dimension).
         vertex(0,0,0,0,0);
         vertex( _width-1, 0,0,1,0);
         vertex(_width-1, _height,0,1,1);
         vertex(0,_height,0,0,1);
         vertex(0,0,0);

         endShape();
      
      popMatrix();
 }

   /**
    *
    */
   public void renderReflectionImage()
   {
     
      pushMatrix();

         translate( _location.X()-1 , _location.Y() + _height , 0);         
                  
         beginShape();
      
         textureMode(NORMALIZED);
         texture( _reflectionImage );

         // no stroke for reflection..
         strokeWeight(0);
         stroke(_background);
         //noStroke();
      
         // The first 3 coordinates are x,y,z and the last two u,v for 
         // the texture (0 to 100 in each dimension).
         vertex(0,0,0,0,1);
         vertex( _width, 0,0,1,1);
         vertex(_width, _reflectionHeight,0,1,0);
         vertex(0,_reflectionHeight,0,0,0);
         vertex(0,0,0,0,1);
         endShape();
         
      popMatrix();
   }

   



   private void generateReflectionImage()
   {
      int imageWidth  = (int)  _image.width;
      int imageHeight = (int)  _image.height;     
      
      //_reflectionImage = _image.get(0, imageHeight - _reflectionHeight,  imageWidth, imageHeight);
      //_reflectionImage = _image.get(0, imageHeight - _reflectionHeight,  imageWidth, imageHeight);
      
      loadPixels();   
      imageMode(CORNERS);      
      _reflectionImage = _image.get(0, imageHeight-200,  imageWidth, 200);      
      //println("reflection image : " + _reflectionImage.width + ";" + _reflectionImage.height);        
      imageMode(CORNER);
      updatePixels();
      
      generateAlphaMask();
   }
   
   private void generateAlphaMask()
   {
      PImage alphaMask = createImage(_reflectionImage.width, _reflectionImage.height, ARGB);
      alphaMask.loadPixels();
      
      int alphaValue = 0;
      int y = 0;
      for (int i = 0; i < alphaMask.pixels.length -1; i++)
      {
         y = (int)(i%alphaMask.width);
         if (y==0)
         {
         alphaValue++;// = map(i%alphaMask.width,
         }
         alphaMask.pixels[i] = color(_backColor,255-alphaValue/1.65f);
      }
      
      alphaMask.updatePixels();
      
      _reflectionImage.blend(alphaMask,0,0, _reflectionImage.width, _reflectionImage.height,
                                       0,0, _reflectionImage.width, _reflectionImage.height, BLEND);      
      
      
   }

   
}

public class Point2D
{
   private float _x;
   private float _y;

   public Point2D(float x, float y)
   {
      _x = x;
      _y = y;
   }

   public float X()
   { 
      return _x; 
   }

   public void setX(float value)
   {  
      _x = value; 
   }

   public float Y()
   { 
      return _y; 
   }

   public void setY(float value)
   {  
      _y = value; 
   }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P151_ReflectedImage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
