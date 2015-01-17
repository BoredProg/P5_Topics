class Particle
{
	public float moveRange = 150;
	public float outForce = 0;
	
	private Ribbon[] ribbons;
	private PImage 	img;
	private PVector pos;
	private float 	decay;
	
	private float theta1 = 0.0;
	private float theta2 = 0.0;
	private float theta3 = 0.0;
	private float inc1 = random(0.02, 0.1);
	private float inc2 = random(0.02, 0.1);
	private float inc3 = random(0.02, 0.1);
	
	Particle( PImage img )
	{
		this.img = img;
		
		pos = new PVector( random(400), random(400), random(400) );
		decay = 0.98;
		
		ribbons = new Ribbon[5];
		for( int i=0; i < ribbons.length; i++ )	{
			color col = ribbonColImg.get( int(random(ribbonColImg.width)), int(random(ribbonColImg.height)) );
			ribbons[i] = new Ribbon( (int)random(10, 20), col, 0.15 );
		}
		
		inc1 *= 2;
		inc2 *= 2;
		inc3 *= 2;
	}
	
	public void SetOffScreenRender( GLGraphicsOffScreen offScreen )
	{
		for( int i = 0; i < ribbons.length; i++ ) {
			ribbons[i].SetOffScreenRender( offScreen );
		}
	}
	
	public void Update()
	{
		float n = noise(frameCount)*0.2;
		
		moveRange += outForce;
		pos.x = moveRange * sin(theta1+=inc1+n);
		pos.y = moveRange * cos(theta2+=inc2+n);
		pos.z = moveRange * sin(theta3+=inc3+n);
		
		for( int i=0; i<ribbons.length; i++) { 
			// float rand = random(10.0);
			// pos.add(rand, rand, rand);
			ribbons[i].Update(pos);
		}
		
		if( moveRange > 200) 
                {
                  moveRange -= 5;
                }
		else 
                  moveRange = random(200, 300);
		
		outForce *= 0.75;
	}
	
	public void Render()
	{
		for( int i=0; i<ribbons.length; i++) ribbons[i].Render();
	}
}
