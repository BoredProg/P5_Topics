
int squareList;

void initGL()
{
  pgl.beginGL();
  squareList = gl.glGenLists(1);
  gl.glNewList(squareList, GL.GL_COMPILE);
  gl.glBegin(GL.GL_POLYGON);
  gl.glTexCoord2f(0, 0);  gl.glVertex2f(-0.5, -0.5);
  gl.glTexCoord2f(1, 0);  gl.glVertex2f( 0.5, -0.5);
  gl.glTexCoord2f(1, 1);  gl.glVertex2f( 0.5,  0.5);
  gl.glTexCoord2f(0, 1);  gl.glVertex2f(-0.5,  0.5);
  gl.glEnd();
  gl.glEndList();
  pgl.endGL();
}

void setupBlendMode()
{
	gl.glDepthMask(false);
	gl.glDisable(GL.GL_DEPTH_TEST);
	gl.glEnable(GL.GL_BLEND);
	myGlBlendFunc("add");
}

void renderImage( PVector _pos, float _diam, PVector _col, float _alpha)
{
  gl.glPushMatrix();
    gl.glTranslatef( _pos.x, _pos.y, _pos.z);
    gl.glScalef(_diam, _diam, _diam);
    gl.glColor4f( _col.x, _col.y, _col.z, _alpha);
    gl.glCallList( squareList );
  gl.glPopMatrix();
}

//Set BlendFunc ...................................................
void myGlBlendFunc( String op )
{
  if( op == "alpha" )
    gl.glBlendFunc( GL.GL_ONE, GL.GL_ONE_MINUS_SRC_ALPHA );
  else if( op == "add" )
    gl.glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE );
  else if( op == "multiply" )
    gl.glBlendFunc( GL.GL_DST_COLOR, GL.GL_ONE_MINUS_SRC_ALPHA );

}

//Create random color..............................................
private PVector randomColor()
{
	// color[] cols = { #13a1eb, #00ff30, #ec3bc0, #ff8d13 };
	color[] cols = { #fdaf15, #6bab77, #0e8d94, #434d53 };
	int index = floor( random(cols.length) );
	return new PVector( red(cols[index]), green(cols[index]), blue(cols[index]) );
}

//Draw horizontal gradation
void drawGrad( float viewW, float viewH )
{
  gl.glBegin(GL.GL_POLYGON);
  gl.glColor3f(0.263, 0.607, 1.0);
  gl.glVertex2f( 0,  0);
  gl.glVertex2f( 0, viewH);
  gl.glColor3f(0.078, 0.5, 0.9);
  gl.glVertex2f( viewW/2,  viewH);
  gl.glVertex2f( viewW/2,  0);
  gl.glEnd();
  
  gl.glBegin(GL.GL_POLYGON);
  gl.glColor3f(0.078, 0.5, 0.9);
  gl.glVertex2f( viewW/2,  0);
  gl.glVertex2f( viewW/2, viewH);
  gl.glColor3f(0.0, 0.15, 0.259);
  gl.glVertex2f( viewW, viewH);
  gl.glVertex2f( viewW, 0);
  
  gl.glEnd();
}
