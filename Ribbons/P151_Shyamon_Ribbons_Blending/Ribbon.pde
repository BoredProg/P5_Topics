class Ribbon
{
  // array that stores vertices for ribbon	
  private RibbonPoint[] rPt;

  private int 		bezierStep = 5;
  private float 	widthFade = 0.7;
  private float 	widthMax = 15;
  private float  	maxDitance = 60;
  private float 	friction = 0.98;
  private float 	outForce = 0.03;
  private int 		ptCnt;
  private float 	randomness;
  private color 	col;

  Ribbon( int ribbonPointCount, color ribbonColor, float randomness )
  {
    //set constants
    this.ptCnt			= ribbonPointCount;
    this.col				= ribbonColor;
    this.randomness	= randomness;

    //creates ribbon points array
    rPt = new RibbonPoint[ptCnt];
    for ( int i=0; i < ptCnt; i++ ) rPt[i] = new RibbonPoint( new Vec3D(0, 0, 0), randomness, this );
  }


  public void Update( PVector pos )
  {
    //add new ribbon point and calculate the position of all points
    addNewPoint( pos );

    for ( int i = 1; i < ptCnt-1; i++ )
      rPt[i].CalcPoints( i, rPt[i-1], rPt[i+1] );
  }


  public void Render()
  {
    if ( drawMode ) { // draw colored polygon
      fill(col);
      noStroke();
    } 
    else { // draw wireframe
      noFill();
      stroke(#ff0000);
    }

    for ( int i = 1; i < ptCnt -2; i++ )
      DrawBezierQuads(i);
  }


  //Draw bezier subdivided quads
  private void DrawBezierQuads( int i )
  {
    int div = bezierStep;
    Vec3D[] bzPtL = new Vec3D[div+1];
    Vec3D[] bzPtR = new Vec3D[div+1];

    //Calc bezier points
    for ( int j = 0; j <= div; j++ ) {
      float t = (float)j / (float)div;
      bzPtL[j] = calcBezierPt( rPt[i+1].leftMidPt, rPt[i].leftPt, rPt[i].leftMidPt, t );
      bzPtR[j] = calcBezierPt( rPt[i+1].rightMidPt, rPt[i].rightPt, rPt[i].rightMidPt, t );
    }

    //Draw bezier quads!		
    beginShape(QUADS);
    for ( int k = 0; k < div; k++ ) {
      callVertex( bzPtL[k] );
      callVertex( bzPtL[k+1] );
      callVertex( bzPtR[k+1] );
      callVertex( bzPtR[k] );
    }
    endShape();
  }

  //Draw simple quads curve ( not used )
  private void DrawRibbonQuads( int i )
  {
    beginShape(QUADS);
    callVertex( rPt[i].leftPt );
    callVertex( rPt[i].rightPt);
    callVertex( rPt[i].rightMidPt );
    callVertex( rPt[i].leftMidPt );

    callVertex( rPt[i].leftMidPt );
    callVertex( rPt[i].rightMidPt );
    callVertex( rPt[i-1].rightPt );
    callVertex( rPt[i-1].leftPt );		
    endShape();
  }


  private void addNewPoint( PVector pos )
  {
    //slide points and add new point at the end
    for ( int i=1; i < ptCnt; i++ ) rPt[i-1] = rPt[i];
    rPt[ ptCnt-1 ] = new RibbonPoint( new Vec3D(pos.x, pos.y, pos.z), randomness, this );
  }


  // Calculate bezier point at "t" from "startPt", "controlPt" and "endPt"
  private Vec3D calcBezierPt( Vec3D startPt, Vec3D controlPt, Vec3D endPt, float t)
  {
    Vec3D p0 = startPt;
    Vec3D p1 = controlPt;
    Vec3D p2 = endPt;
    float invt = 1.0 - t;

    float x = invt*invt*p0.x + 2*t*invt*p1.x + t*t*p2.x;
    float y = invt*invt*p0.y + 2*t*invt*p1.y + t*t*p2.y;
    float z = invt*invt*p0.z + 2*t*invt*p1.z + t*t*p2.z;

    return new Vec3D(x, y, z);
  }

  private void callVertex( Vec3D pt ) { 
    vertex(pt.x, pt.y, pt.z );
  }
}



class RibbonPoint
{
  private Vec3D pt;

  //left point and right point
  private Vec3D leftPt, rightPt;
  //mid point between this point and previous point
  private Vec3D leftMidPt, rightMidPt;

  private Vec3D crossVec, speed;
  private float rWidth;
  private Ribbon ribbon;

  RibbonPoint( Vec3D pos, float randomness, Ribbon ribbon )
  {
    //initialize points
    pt = pos.copy();
    leftPt = new Vec3D(0.0, 0.0, 0.0);
    rightPt = new Vec3D(0.0, 0.0, 0.0);
    leftMidPt = new Vec3D(0.0, 0.0, 0.0);
    rightMidPt = new Vec3D(0.0, 0.0, 0.0);		
    crossVec = new Vec3D(0, 0, 0);
    speed = new Vec3D(0, 0, 0);

    rWidth = 0.0;
    this.ribbon = ribbon;
  }

  public void CalcPoints( int index, RibbonPoint pMinus1, RibbonPoint pPlus1 )
  {	
    //calc middle points with neighbor points
    Vec3D m1 = pt.add( pMinus1.pt ).scale(0.5);
    Vec3D m2 = pt.add( pPlus1.pt ).scale(0.5);

    //calc point direction and its length
    Vec3D dir = m2.sub(m1);
    float dist = dir.magnitude();

    //add outForce
    if ( ribbon.outForce > 0.0 ) {			

      if ( dist > ribbon.maxDitance ) {
        speed = speed.add(dir.scale(ribbon.outForce));
      }	
      speed = speed.scale(ribbon.friction);
      pt = pt.add(speed);
    }

    //add random movement
    float rand = ( (ribbon.randomness/2) - random(ribbon.randomness) ) * dist;
    pt = pt.add( rand, rand, rand );

    //calc ribbon width..................................................
    if ( index < ribbon.ptCnt / 2.0 ) rWidth = pPlus1.rWidth * ribbon.widthFade;
    else rWidth = dist;

    if ( rWidth > ribbon.widthMax ) rWidth = ribbon.widthMax;


    //calc ribbon points....................................................
    crossVec = m1.sub(pt).cross( m2.sub(pt) );


    //check orientation of cross vector so that ribbon surface won't flip
    float angle1 = crossVec.angleBetween( pMinus1.crossVec, true );
    float angle2 = crossVec.scale(-1.0).angleBetween( pMinus1.crossVec, true);

    if ( angle2 > angle1 ) crossVec = crossVec.scale(-1.0);


    leftPt = crossVec.normalizeTo(rWidth).add(pt);
    rightPt = crossVec.normalizeTo(-rWidth).add(pt);
    leftMidPt = pMinus1.leftPt.add( leftPt ).scale(0.5);
    rightMidPt = pMinus1.rightPt.add( rightPt ).scale(0.5);
  }
}

