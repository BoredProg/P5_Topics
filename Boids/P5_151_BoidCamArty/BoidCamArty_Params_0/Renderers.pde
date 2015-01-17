
public class BoidRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      Boid boid = (Boid)entity;
      int _blue = ((int)(boid.xpos/1500))*255-100;
      //colorMode(HSB);
      /*
      if (frameCount % 5 == 0)
       {
       strokeWeight(random(2,.5));
       stroke(0);
       }
       else
       {
       noStroke();
       }
       */
      scale(noise(1,1,2002)*1-(random(2,.1)));
      for (int cubes = 1; cubes < 2; cubes ++)
      {  
         //scale(random(1,1.1));
         //rotate(radians(noise(10,70)*110)); 
         //fill(cubes*20,255, 200,255 - (cubes * 63.75));

         // light light grey renderer (best on white backgrounds).
         //fill(noise(frameRate)* noise(10,50000),(noise(frameCount)*2)+10);
         fill(10,10,212);
         scale(boid.cubeSize.x, boid.cubeSize.y, boid.cubeSize.z);
         box(boid.mySize * (cubes * 2.35));
         scale(0,0,1);
      }
      colorMode(RGB);
      //scale(1);
   }
}

public class BackgroundRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
   }
}

public class SaturatedBackgroundRenderer extends BackgroundRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      // 3 nices lines with the light grey boid renderer.
      // Very saturated background that makes the light objects like clouds.     
      colorMode(HSB);
      background((abs(flock[50].xpos)/1500)*255,255,100);
      colorMode(RGB);      
   }
}


public class NoiseGreyScaleBackgroundRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      //colorMode(RGB);

      background((noise(flock[0].xpos)*255)+180);
      //background(255,10,10);

      //colorMode(HSB); 

   }
}






public class BoidGreyRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      Boid boid = (Boid)entity;
      int _blue = ((int)(boid.xpos/1500))*255-100;
      colorMode(HSB);
      /*
      if (frameCount % 5 == 0)
       {
       strokeWeight(random(2,.5));
       stroke(0);
       }
       else
       {
       noStroke();
       }
       */
      scale(noise(1,1,2002)*1-(random(2,.1)));
      for (int cubes = 1; cubes < 3; cubes ++)
      {  
         //scale(random(1,1.1));
         //rotate(radians(noise(10,70)*110)); 
         //fill(cubes*20,255, 100,255 - (cubes * 63.75));

         // light light grey renderer (best on white backgrounds).
         fill(noise(frameRate)* noise(10,50),(noise(frameCount)*2)+5);
         box(boid.mySize * (cubes * 2.35));
      }
      colorMode(RGB);
      //scale(1);
   }

}
