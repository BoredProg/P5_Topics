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
         alphaMask.pixels[i] = color(_backColor,255-alphaValue/1.65);
      }
      
      alphaMask.updatePixels();
      
      _reflectionImage.blend(alphaMask,0,0, _reflectionImage.width, _reflectionImage.height,
                                       0,0, _reflectionImage.width, _reflectionImage.height, BLEND);      
      
      
   }

   
}
