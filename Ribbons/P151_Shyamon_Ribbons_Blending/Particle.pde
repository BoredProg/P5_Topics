class Particle
{
  public float moveRange = 150;

  private Ribbon[] ribbons;
  private PVector pos;
  private float 	decay;

  private float theta1 = 0.0;
  private float theta2 = 0.0;
  private float theta3 = 0.0;
  private float inc1 = random(0.02, 0.1);
  private float inc2 = random(0.02, 0.1);
  private float inc3 = random(0.02, 0.1);

  Particle()
  {		
    pos = new PVector(0, 0, 0);
    decay = 0.98;

    // create ribbons
    ribbons = new Ribbon[5];
    for ( int i=0; i < ribbons.length; i++ ) {
      color col = ribbonColImg.get( int(random(ribbonColImg.width)), int(random(ribbonColImg.height)) );
      ribbons[i] = new Ribbon( (int)random(10, 20), col, 0.05 );
    }

    inc1 *= 2;
    inc2 *= 2;
    inc3 *= 2;
  }

  public void Update()
  {
    // calculate particle movement
    float n = noise(frameCount)*0.2;

    pos.x = moveRange * sin(theta1+=inc1+n);
    pos.y = moveRange * cos(theta2+=inc2+n);
    pos.z = moveRange * sin(theta3+=inc3+n);

    // update ribbon position
    for ( int i=0; i<ribbons.length; i++) { 
      ribbons[i].Update(pos);
    }

    if ( moveRange > 200) moveRange -= 10;
    else moveRange = random(300, 600);
  }

  public void Render()
  {
    for ( int i=0; i<ribbons.length; i++) ribbons[i].Render();
  }
}

