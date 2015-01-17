/**
* Boid class.
*
*
*/
public class Boid implements IRenderable
{
   final int TRAIL_SCALE = 8;

   Vector3 v1 = new Vector3();
   Vector3 v2 = new Vector3();
   Vector3 v3 = new Vector3();
   Vector3 v4 = new Vector3();
   Vector3 v5 = new Vector3();
   Vector3 v6 = new Vector3();

   color myColor = color(255, 255, 255,80);
   int mySize = 4;

   public float xpos, ypos, zpos;
   float tailXpos, tailYpos, tailZpos;
   float tailXwant, tailYwant, tailZwant;
   float tailXpos2, tailYpos2, tailZpos2;
   
   float vx, vy, vz; // direction..


   public Boid() 
   {
      xpos = width/2+random(-200, 200);
      ypos = height/2+random(-200, 200);
      zpos = height/2+random(-200, 200);

      tailXpos = xpos;
      tailYpos = ypos;
      tailZpos = zpos;

      vx = random(-.5, .5);
      vy = random(-.5, .5);
      vz = random(-.5, .5);

      updateTail();
   }

   void drawMe()
   {
      updateBoid();
      
      //drawTail();

      
      pushMatrix();
      
         translate(xpos,ypos,zpos);
         noStroke();
         //render();
         //render_transparency();
         
         setRenderer(new BoidRenderer());

      popMatrix();
   }

   /**
   * Renders the Boid..
   *
   */
   public void render()
   {
      //int _blue = (int)(xpos/1500)*255-100;
      //strokeWeight(mySize*10);
      //stroke(0,5);
      int _blue = ((int)(xpos/1500))*255-100;
      colorMode(HSB);
      for (int cubes = 1; cubes < 4; cubes ++)
      {  
         //rotate(radians(noise(10,70)*110)); 
         //fill(cubes*20,255, 100,255 - (cubes * 63.75));
         fill(noise(frameRate)* noise(10,50),10);
         box(mySize * (cubes * 2.35));
      }
      colorMode(RGB);
      
      /*
      int i=0;      
      sphereDetail(10);      
      texture( _boidImage );
      sphere(mySize*3.5);
      i++;
      */      
   }

   IRenderer _boidRenderer;
   
   public void setRenderer(IRenderer renderer)
   {
      _boidRenderer = renderer;
      _boidRenderer.render( this );
   }
   
   
   

   /**
   * Renders the Boid..
   *
   */
   public void render_01()
   {
      pushMatrix();
      //println(noise(xpos));
      //scale((xpos+ypos+zpos/3500)*noise(0.0025)*0.0038);
      rotateX(1.001);
      fill(10,(ypos/1000)*255,(xpos/1000)*255,255);
      noStroke();
      box(mySize);
      //box(mySize*sqrt(vx*vx+vy*vy));
      //image( _boidImage, 0, 0, mySize * 5, mySize * 5);
      popMatrix();
   }


   public void render_transparency()
   {
      noStroke();
      //colorMode(HSB);
      //println((int)xpos + ";"+ (int)ypos+";"+ (int)zpos + ";");

      fill((ypos/1000)*255,(ypos/1000)*255,255,255);
      box(mySize);

      // Transparency..
      for (int s = mySize, iter=0; s < 15; s+=3, iter++)
      {
         fill((ypos/1000)*255,(ypos/1000)*255,(zpos/1000)*200,255 - (55*iter));
         box(s);
      }
   }

 /**
   * Draws the standard line tail.
   */
   public void drawTail()
   {
      updateTail();

      stroke(255,190);
      strokeWeight(.9);
      /*
       stroke(255,frameRate/10+100);
       strokeWeight(noise(xpos)*10);    
       */
      line(tailXpos, tailYpos, tailZpos, tailXpos2, tailYpos2, tailZpos2);  
      //line(xpos, ypos, zpos, xpos-TRAIL_SCALE*vx, ypos-TRAIL_SCALE*vy, zpos-TRAIL_SCALE*vz);  
      //line(xpos, ypos, zpos, tailXpos2, tailYpos2, tailZpos2); 

      noStroke();
   }









   public void updateTail() 
   {
      tailXwant = xpos-TRAIL_SCALE*vx;
      tailYwant = ypos-TRAIL_SCALE*vy;
      tailZwant = zpos-TRAIL_SCALE*vz;

      tailXpos2 = xpos;
      tailYpos2 = ypos;
      tailZpos2 = zpos;
      tailXpos = tailXpos + (tailXwant - tailXpos)*0.1;
      tailYpos = tailYpos + (tailYwant - tailYpos)*0.1;
      tailZpos = tailZpos + (tailZwant - tailZpos)*0.1;

   }

   public void updateBoid()
   {
      
      rule1();
      rule2();
      rule3();
      
      rule4();
      rule5();
      rule6();
      

      // add Vector3s to velocities
      vx += r1Damping*v1.x + r2Damping*v2.x + r3Damping*v3.x + r4Damping*v4.x + r5Damping*v5.x + r6Damping*v6.x;
      vy += r1Damping*v1.y + r2Damping*v2.y + r3Damping*v3.y + r4Damping*v4.y+ r5Damping*v5.y+ r6Damping*v6.y;
      vz += r1Damping*v1.z + r2Damping*v2.z + r3Damping*v3.z + r4Damping*v4.z+ r5Damping*v5.z+ r6Damping*v6.z;


      if (bounceFromWalls) {
         if (xpos + vx < 0 || xpos + vx > CAVE_WIDTH)
            vx = -vx*BOUNCE_ABSORPTION;

         if (ypos + vy < 0 || ypos + vy > CAVE_HEIGHT)
            vy = -vy*BOUNCE_ABSORPTION;
         if (zpos + vz < 0 || zpos + vz > CAVE_DEPTH)
            vz = -vz*BOUNCE_ABSORPTION;
      } 
      else {

         if (xpos + vx < 0 ) {
            xpos = width; 
         } 
         else if ( xpos + vx > CAVE_WIDTH) {
            xpos = 0; 
         }
      }

      limitVelocity();

      if (ypos + vy < 0) {
         ypos = height;     
      } 
      else if (ypos + vy > CAVE_HEIGHT) {
         ypos = 0;
      }


      // update new position with previously calculated velocities
      xpos += vx;
      ypos += vy;
      zpos += vz;

   }

   void limitVelocity()
   {
      float vlim = VELOCITY_LIMITER;

      //float velocity = sqrt(sq(vx) + sq(vy));
      float velocity = dist(0,0,0, vx, vy, vz);

      if (velocity > vlim)
      {
         vx = (vx/velocity)*vlim;
         vy = (vy/velocity)*vlim;
         vz = (vz/velocity)*vlim;
      }  

   } // end limitVelocity()


   // pull to the center
   void rule1()
   {

      v1.setXYZ(0,0, 0);

      for (int i=0; i < NUM_BOIDS; ++i)
      {
         if (this != flock[i])
         {
            v1.x += flock[i].xpos;
            v1.y += flock[i].ypos;
            v1.z += flock[i].zpos;
         } // end if
      } // end for

      v1.x /= (NUM_BOIDS-1);
      v1.y /= (NUM_BOIDS-1);
      v1.z /= (NUM_BOIDS-1);

      v1.x = (v1.x - xpos) / CENTER_PULL_FACTOR;
      v1.y = (v1.y - ypos) / CENTER_PULL_FACTOR;
      v1.z = (v1.z - zpos) / CENTER_PULL_FACTOR;

   } // end rule1()


   // avoid collision
   void rule2()
   {

      v2.setXYZ(0,0, 0);
      for (int i=0; i < NUM_BOIDS; ++i)
      {
         if (this != flock[i])
         {
            //if (distance2d(b, flock[i]) < 20)
            if (dist(xpos, ypos, zpos, flock[i].xpos, flock[i].ypos, flock[i].zpos) < MIN_DISTANCE)
            {
               v2.x -= flock[i].xpos - xpos;
               v2.y -= flock[i].ypos - ypos;
               v2.z -= flock[i].zpos - zpos;
            } // end if
         } // end if
      } // end for

   } // end rule2()


   // head to flock average
   void rule3()
   {

      v3.setXYZ(0,0,0);

      for (int i=0; i < NUM_BOIDS; ++i)
      {
         if (this != flock[i])
         {
            v3.x +=  flock[i].vx;
            v3.y +=  flock[i].vy;
            v3.z +=  flock[i].vz;
         } // end if
      } // end for

      v3.x /= (NUM_BOIDS - 1);
      v3.y /= (NUM_BOIDS - 1);
      v3.z /= (NUM_BOIDS - 1);

      v3.x = (v3.x - vx)/VELOCITY_PULL_FACTOR; //8
      v3.y = (v3.y - vy)/VELOCITY_PULL_FACTOR; //8
      v3.z = (v3.z - vz)/VELOCITY_PULL_FACTOR; //8
   } // end rule3()

   // head the mouse
   void rule4()
   {
      //v4.setXY(0,0);
      v4.x = (mouseX - xpos) / TARGET_PULL_FACTOR;
      v4.y = (mouseY - ypos) / TARGET_PULL_FACTOR;
      v4.z = (0 - zpos) / TARGET_PULL_FACTOR;

      //stroke(255, 50);
      //line(xpos+v4.x, ypos+v4.y, mouseX, mouseY);
   } // end rule4()





   // obstacle avoidance
   void rule5() {
      v5.setXYZ(0,0,0);
      for (int i=0; i < obstacles.length; ++i)
      {

         float distance = dist(xpos, ypos, zpos, obstacles[i].x, obstacles[i].y, obstacles[i].z);

         if (distance < obstacles[i].minDistance)
         {
            v5.x -= (obstacles[i].x - xpos);
            v5.y -= (obstacles[i].y - ypos);
            v5.z -= (obstacles[i].z - zpos);

            /*
        v5.x -= (obstacles[i].x - xpos)/obstacles[i].minDistance*(obstacles[i].minDistance-distance);
             v5.y -= (obstacles[i].y - ypos)/obstacles[i].minDistance*(obstacles[i].minDistance-distance);
             v5.z -= (obstacles[i].z - zpos)/obstacles[i].minDistance*(obstacles[i].minDistance-distance);
             */

         } // end if
      } // end for
   }


   // go for food

   /* needs updating!!!! */
   void rule6() {
      v6.setXYZ(0,0,0);

      for (int i=0; i < foods.size(); ++i)
      {
         Food currentFood = (Food) foods.get(i);
         float distance = dist(xpos, ypos, zpos, currentFood.x, currentFood.y, currentFood.z);

         //v6.x += (currentFood.x - xpos) / FOOD_PULL_FACTOR * (1.0/MAX_DISTANCE*distance*2);
         //v6.y += (currentFood.y - ypos) / FOOD_PULL_FACTOR * (1.0/MAX_DISTANCE*distance*2);
         v6.x = (currentFood.x - xpos) / FOOD_PULL_FACTOR;
         v6.y = (currentFood.y - ypos) / FOOD_PULL_FACTOR;
         v6.z = (currentFood.z - zpos) / FOOD_PULL_FACTOR;

         if (distance < currentFood.minDistance)
         {
            currentFood.filling--;
            currentFood.vx += vx/50;
            currentFood.vy += vy/50;
            currentFood.vz += vz/50;
         } // end if
      } // end for
   }

} // end class Boid
