String getAntialiasSampleRate(GL gl)
{
  
  gl = GLU.getCurrentGL();
  
  int buf[] = new int[1];
  int sbuf[] = new int[1];
    
  gl.glGetIntegerv(GL.GL_SAMPLE_BUFFERS, buf, 0);
  //System.out.println("number of sample buffers is " + buf[0]);
  gl.glGetIntegerv(GL.GL_SAMPLES, sbuf, 0);
  //System.out.println("number of samples is " + sbuf[0]);

  return "Antialias Buffers == " + buf[0] + ", " + sbuf[0] + " anti-alias samples.";


}
