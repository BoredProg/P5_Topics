class Vehicle {
   float x;
   float y;

   float xv, yv;
   float xf, yf;

   float theta;
   float angle;
   float angleDelta;
   float speed = random(2.0f, 10.0f);
   //float speed = random(1.0f, 10f);;

   Vehicle (int xSent, int ySent){
      x = randomx;
      y = randomy;
   }

   void exist()
   {
      findVelocity();
      move();

      
      render();
      
   }

   void findVelocity(){
      noiseVal= noise  ((x - xCount) * noiseScale,  (y - yCount) * noiseScale, noiseCount);
      
      angle -= (angle - noiseVal*720.0f) * .4f;      
      theta = (-(angle * PI))/180.0f;
      
      xv = cos(theta) * speed;
      yv = sin(theta) * speed;
   }

   void move()
   {
      
      x -= xv;
      y -= yv;
     
     /* Uncomment this to continue the drawing on the opposite border.
    if (x < -50){
       x += width + 100;
       } else if (x > width + 50){
       x -= width + 100;
       }
       
       if (y < -50)
       {
          y += height + 100;
       } 
       else if (y > height + 50)
       {
          y -= height + 100;
       }
      */
   }

   void render(){
      //stroke(0, 1);  
      if ( ! _invertColors )
         stroke(0,(angle - 180)/100.0f + 1);
      else
         stroke(360,(angle - 180)/100.0f + 5);
      
      //stroke(0,(angle - 180)/100.0f + 1);
      line(x,y, x+xv, y+yv);
   }
}
