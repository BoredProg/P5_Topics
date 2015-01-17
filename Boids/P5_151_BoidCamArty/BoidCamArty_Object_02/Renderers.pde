

/********************************************************************************************
 * BOIDS
 *******************************************************************************************/



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
      scale(noise(1,1,2002)*1-(random(2.5,.1)));
      for (int cubes = 1; cubes < 10; cubes ++)
      {  
         //scale(random(1,1.1));
         //rotate(radians(noise(10,70)*110)); 

         colorMode(RGB);
         //fill(cubes*20,255, 200,255 - (cubes * 63.75));

         // light light grey renderer (best on white backgrounds).
         colorMode(HSB);
         //fill(noise(frameRate* 200),(noise(frameCount)*2)+10);
         fill(cubes*noise(boid.xpos),80 + (cubes * 0.75));
         box(boid.mySize/2 * (cubes * 2.35));
         //box(int((boid.xpos+boid.ypos+boid.zpos)/3500 + cubes*1.1));
         //sphere(boid.mySize * (cubes * 2.35));
      }
      colorMode(RGB);
      //scale(1);
   }
}


public class NetworkBoidRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      Boid boid = (Boid)entity;

      scale(noise(1,1,2002)*1-(random(2.5,.1)));
      for (int cubes = 1; cubes < 4; cubes ++)
      {  
         //scale(random(1,1.1));
         //rotate(radians(noise(10,70)*110)); 

         colorMode(RGB);
         fill(cubes*random(40,50),255 - (cubes * 63.75));

         /* light light grey renderer (best on white backgrounds).
          colorMode(HSB);
          fill(noise(frameRate* 200),(noise(frameCount)*2)+10);
          */
         box(boid.mySize * (cubes * 2.35));
      }
      colorMode(RGB);
      //scale(1);
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
      for (int cubes = 1; cubes < 5; cubes ++)
      {  
         //scale(random(1,1.1));
         //rotate(radians(noise(10,70)*110)); 
         //fill(cubes*20,255, 100,255 - (cubes * 63.75));

         // light light grey renderer (best on white backgrounds).
         fill(noise(frameRate)* noise(10,50),(noise(frameCount)*2)+5);
         box(boid.mySize * (cubes * 2.35));
        // boid.mySize = boid.mySize * (int)(cubes * 2.35);
      }
      colorMode(RGB);
      //scale(1);
   }

}

public class BoidImageRenderer implements IRenderer
{

   
   public void render(IRenderable entity)
   {
      Boid boid = (Boid)entity;
   }
}








/********************************************************************************************
 * BACKGROUND
 *******************************************************************************************/




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
      background((abs(flock[0].xpos)/1500)*255,255,100);
      colorMode(RGB);      
   }
}


public class NoiseGreyScaleBackgroundRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      //colorMode(RGB);

      background((noise(flock[0].xpos)*255)+180);
      //noiseDetail(1, .90);
      //background(255- (noise(frameCount,10)*50));
      
      //background(255,10,10);

      //colorMode(HSB); 
      

   }
}


/********************************************************************************************
 * WORLD
 *******************************************************************************************/



public class WorldRenderer implements IRenderer
{
   public void render(IRenderable entity)
   {
      World world = (World)entity;
      renderCube();

   }

   private void renderCube()
   {
      //translate(-_world.x/2,-_world.y/2,-_world.z/2); //DONE
      
      // to be outside of the cube..
      //translate( -_world.x/2, -_world.y/2, -_world.z/2 );
      
      translate(0,0,0);
      
      stroke(200,10);
      strokeWeight(10);

      line(0,0,0,0,0,_world.z);
      line(_world.x, 0, 0, _world.x, 0, _world.z);
      line(_world.x, _world.y, 0, _world.x, _world.y, _world.z);
      line(0, _world.y, 0, 0, _world.y, _world.z);

      line(0,0,0, _world.x, 0,0);
      line(0, _world.y, 0, _world.x, _world.y, 0);
      line(0,0,_world.z, _world.x, 0,_world.z);
      line(0, _world.y, _world.z, _world.x, _world.y, _world.z);

      line(0,0,0, 0, _world.y, 0);
      line(_world.x,0,0, _world.x, _world.y,0); 
      line(0,0, _world.z,  0, _world.y,  _world.z);
      line(_world.x,0, _world.z, _world.x, _world.y, _world.z); 
   }
   
}






