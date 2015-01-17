
void setupBlendMode()
{
  gl.glDepthMask(false);
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  myGlBlendFunc("add");
}


//Set BlendFunc ...................................................
void myGlBlendFunc( String op )
{
  if ( op == "alpha" )
    gl.glBlendFunc( GL.GL_ONE, GL.GL_ONE_MINUS_SRC_ALPHA );
  else if ( op == "add" )
    gl.glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE );
  else if ( op == "multiply" )
    gl.glBlendFunc( GL.GL_DST_COLOR, GL.GL_ONE_MINUS_SRC_ALPHA );
}

