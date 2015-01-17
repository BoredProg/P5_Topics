import codeanticode.glgraphics.*;

public class BloomFx
{
	private GLTexture bloomMask;
	private GLTexture destTex;
	private GLTexture tex0, tex2, tex4, tex8, tex16;
	private GLTexture	tmp2, tmp4, tmp8, tmp16;
	private GLTextureFilter extractBloom, blur, blend4, toneMap;
	
	public BloomFx( PApplet parent )
	{
		// load required filters
		extractBloom = new GLTextureFilter(parent, "ExtractBloom.xml");
		blur = new GLTextureFilter(parent, "Blur.xml");
		blend4 = new GLTextureFilter(parent, "Blend4.xml");
		toneMap = new GLTextureFilter(parent, "ToneMap.xml");
		destTex = new GLTexture(parent, width, height);
		
		// initialize bloom mask and blur textures
		bloomMask = new GLTexture(parent, width, height, GLTexture.FLOAT);
		tex0 = new GLTexture(parent, width, height, GLTexture.FLOAT);
		tex2 = new GLTexture(parent, width/2, height/2, GLTexture.FLOAT);
		tmp2 = new GLTexture(parent, width/2, height/2, GLTexture.FLOAT);
		tex4 = new GLTexture(parent, width/4, height/4, GLTexture.FLOAT);
		tmp4 = new GLTexture(parent, width/4, height/4, GLTexture.FLOAT);
		tex8 = new GLTexture(parent, width/8, height/8, GLTexture.FLOAT);
		tmp8 = new GLTexture(parent, width/8, height/8, GLTexture.FLOAT);
		tex16 = new GLTexture(parent, width/16, height/16, GLTexture.FLOAT);
		tmp16 = new GLTexture(parent, width/16, height/16, GLTexture.FLOAT);
	}

	public GLTexture DoFx( GLTexture srcTex, float brightThresh, float exposure )
	{	
		// extract bright area
		extractBloom.setParameterValue("bright_threshold", brightThresh);
		extractBloom.apply(srcTex, tex0);
	
		// downsample with blur
		tex0.filter(blur, tex2);
		tex2.filter(blur, tmp2);
		tmp2.filter(blur, tex2);
	
		tex2.filter(blur, tex4);        
		tex4.filter(blur, tmp4);
		tmp4.filter(blur, tex4);            
		tex4.filter(blur, tmp4);
		tmp4.filter(blur, tex4);            

		tex4.filter(blur, tex8);        
		tex8.filter(blur, tmp8);
		tmp8.filter(blur, tex8);        
		tex8.filter(blur, tmp8);
		tmp8.filter(blur, tex8);        
		tex8.filter(blur, tmp8);
		tmp8.filter(blur, tex8);

		tex8.filter(blur, tex16);     
		tex16.filter(blur, tmp16);
		tmp16.filter(blur, tex16);        
		tex16.filter(blur, tmp16);
		tmp16.filter(blur, tex16);        
		tex16.filter(blur, tmp16);
		tmp16.filter(blur, tex16);
		tex16.filter(blur, tmp16);
		tmp16.filter(blur, tex16);
	
		// blend downsampled textures
		blend4.apply( new GLTexture[]{tex2, tex4, tex8, tex16}, new GLTexture[]{bloomMask} );
	
		// tonemap into dest texture
		toneMap.setParameterValue("exposure", exposure);
		toneMap.setParameterValue("bright_threshold", brightThresh);
		toneMap.apply(new GLTexture[]{srcTex, bloomMask}, new GLTexture[]{destTex});
	
		return destTex;
	}
}
