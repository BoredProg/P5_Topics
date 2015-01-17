import peasy.*;

class MyPeasyCam
{
	private PeasyCam cam;
	
	MyPeasyCam( PApplet p, float minDist, float maxDist, float initDist )
	{		
		// setup peasy cam
		cam = new PeasyCam(p, (double)initDist);
		cam.setMinimumDistance(minDist);
		cam.setMaximumDistance(maxDist);
	}
	
	public void beginHUD()
	{
		cam.beginHUD();
	}
	
	public void endHUD()
	{
		cam.endHUD();
	}
}
