/**
 * BezierRibbons by Felix Turner
 * www.airtightinteractive.com
 * Randomly moving bezier ribbons. Ribbon separation is determined by noise(). Uses OpenGL additive blending.
 * Press 'S' key to toggle saving images. Use mouse to move camera.
 * Uses the Obsessive Camera Direction Library for Processing: http://www.cise.ufl.edu/~kdamkjer/processing/libraries/ocd/
 */
import processing.opengl.*;
import damkjer.ocd.*;
import javax.media.opengl.*;

boolean SAVING = false;
int RIBBONCOUNT = 10;
float RIBBONWIDTH = 0.05;
float NOISESTEP = 0.005;
float MAXSEPARATION = 1500; //500

float ribbonSeparation,noisePosn;
float stageHeight, stageWidth,stageDepth;
Camera camera1;
RibbonCurve c;
Ribbon r;
Vector ribbons;
PGraphicsOpenGL pgl;
GL gl;
Point3D ribbonTarget;
int saveCount = 0;

void setup() {
    size(1280, 720, OPENGL);  
    hint(ENABLE_OPENGL_4X_SMOOTH);
    stageHeight   = height;
    stageWidth    = width;
    stageDepth    = width;    
    noisePosn          = 0;
    ribbonSeparation   = 0; 
    ribbonTarget       = new Point3D(0,0,0);     
    camera1            = new Camera(this, 0, 0, 1200, 0, 0, 0);   
    colorMode(HSB, 100);  
    frameRate(36);
    
    //create ribons
    ribbons = new Vector();
    for (int i=0;i<RIBBONCOUNT;i++){
        ribbons.addElement(new Ribbon(map(i,0,RIBBONCOUNT,0,100),RIBBONWIDTH));
    }
}


void draw() {

    //clear  
    background(0);

    //draw debug box
    //stroke(0,0,100,20);
    //noFill();
   // box(stageWidth*2, stageHeight*2, stageDepth*2);

    //cam motion
    camera1.feed();
    camera1.circle(0.002);

    //use additive blending
    pgl = (PGraphicsOpenGL) g;
    gl = pgl.beginGL(); 
    gl.glDisable(GL.GL_DEPTH_TEST);
    gl.glEnable(GL.GL_BLEND);
    gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
    pgl.endGL(); 

    ribbonTarget = new Point3D(random(-stageWidth,stageWidth), random(-stageHeight,stageHeight),random(-stageDepth,stageDepth)); 
    ribbonSeparation = lerp(-MAXSEPARATION,MAXSEPARATION,noise(noisePosn+=NOISESTEP));

    for (int i=0;i<RIBBONCOUNT;i++){
        Ribbon r =  (Ribbon) ribbons.elementAt(i);
        r.draw();
    }

    if( SAVING ){
        saveFrame( "images/image_" + saveCount + ".png" );
        saveCount ++;
    }
    
}

void mouseMoved() {
    camera1.arc(radians(mouseY - pmouseY)/4);
    camera1.circle(radians(mouseX - pmouseX)/4);
}

void keyPressed(){
    if( key == 's' || key == 'S' )
        SAVING       = !SAVING;
}

/**
* A ribbon is composed of multiple RibbonCurves
*/
class Ribbon {
    int NUMCURVES = 15;	//number of ribbonCurves per ribbon	
    int CURVERESOLUTION = 20; //lower -> faster
    Vector pts;
    LinkedList curves;
    float ribbonColor;
    float ribbonWidth;
    RibbonCurve currentCurve; //current RibbonCurve
    int stepId;   

    Ribbon(float pcolor, float width){
        ribbonColor = pcolor;
        ribbonWidth = width;
        curves = new LinkedList();
        pts = new Vector();
        pts.addElement(getRandPt());
        pts.addElement(getRandPt());
        pts.addElement(getRandPt());
        stepId = 0;
        addRibbonCurve();
    }

    void draw(){
        currentCurve.addSegment();	

        int size = curves.size();
        if (size > NUMCURVES-1) {
            RibbonCurve c = (RibbonCurve) curves.get(0);
            c.removeSegment();
        }
        stepId++;	

        if (stepId > CURVERESOLUTION) addRibbonCurve();

        //draw curves
        for (int i = 0; i < size; i++) {
            RibbonCurve c = (RibbonCurve) curves.get(i);
            c.draw();
        } 
    }

    void addRibbonCurve(){
        //add new point
        pts.addElement(getRandPt());	

        Point3D nextPt = (Point3D) pts.elementAt(pts.size()-1);
        Point3D curPt = (Point3D) pts.elementAt(pts.size()-2);
        Point3D lastPt = (Point3D) pts.elementAt(pts.size()-3);

        Point3D lastMidPt = new Point3D ((curPt.x + lastPt.x)/2,
        (curPt.y + lastPt.y)/2,
        (curPt.z + lastPt.z)/2);

        Point3D midPt = new Point3D ((curPt.x + nextPt.x)/2,
        (curPt.y + nextPt.y)/2,
        (curPt.z + nextPt.z)/2);

        currentCurve = new RibbonCurve(lastMidPt, midPt,curPt,ribbonWidth,CURVERESOLUTION,ribbonColor);
        curves.add(currentCurve);

        //remove old curves
        if (curves.size() > NUMCURVES){
            //println("REMOVE FIRST CURVE");
            curves.removeFirst();
        }

        stepId = 0;

    }

    Point3D getRandPt(){
        return new Point3D(ribbonTarget.x + random(-ribbonSeparation,ribbonSeparation),
                            ribbonTarget.y + random(-ribbonSeparation,ribbonSeparation),
                            ribbonTarget.z + random(-ribbonSeparation,ribbonSeparation)); 
    }
}

/**
 * A bezier curve with a width
 */
class RibbonCurve {

    float ribbonWidth;
    float resolution;		
    Point3D startPt, endPt, controlPt;
    int stepId;
    float ribbonColor = 0;
    LinkedList quads;

    RibbonCurve(Point3D pStartPt, Point3D pEndPt, Point3D pControlPt, float pwidth, float presolution, float pcolor){
        startPt = pStartPt;
        endPt = pEndPt;
        controlPt = pControlPt;
        resolution = presolution;
        ribbonWidth = pwidth;
        stepId = 0;
        ribbonColor = pcolor;
        quads = new LinkedList();
    }

    void draw(){
        int size = quads.size(); 
        for (int i = 0; i < size; i++) {
            Quad3D q = (Quad3D) quads.get(i);
            q.draw();
        } 
    }

    void removeSegment(){
        if (quads.size() > 1) quads.removeFirst();
    }

    void addSegment()
    {
        fill( ribbonColor,100,100,70);
        float t =  stepId / resolution;							
        Point3D p0 = getOffsetPoint( t, 0 );			
        Point3D p3 = getOffsetPoint( t, ribbonWidth );

        stepId ++;
        if ( stepId > resolution) return;

        t =  stepId / resolution;	
        Point3D p1 = getOffsetPoint( t, 0 );			
        Point3D p2 = getOffsetPoint( t, ribbonWidth );

        Quad3D q = new Quad3D(p0,p1,p2,p3);
        quads.add(q);
    }	

    /**
     * Given a bezier curve defined by 3 points, an offset distance (k) and a time (t), returns a Point3D 
     */
     
    Point3D getOffsetPoint( float t, float k ){			
        Point3D p0 = startPt;
        Point3D p1 = controlPt;
        Point3D p2 = endPt;

        //-- x(t), y(t)
        float xt = ( 1 - t ) * ( 1 - t ) * p0.x + 2 * t * ( 1 - t ) * p1.x + t * t * p2.x;
        float yt = ( 1 - t ) * ( 1 - t ) * p0.y + 2 * t * ( 1 - t ) * p1.y + t * t * p2.y;
        float zt = ( 1 - t ) * ( 1 - t ) * p0.z + 2 * t * ( 1 - t ) * p1.z + t * t * p2.z;

        //-- x'(t), y'(t)
        float xd = t*(p0.x - 2*p1.x + p2.x) - p0.x + p1.x;
        float yd = t*(p0.y - 2*p1.y + p2.y) - p0.y + p1.y;
        float zd = t*(p0.z - 2*p1.z + p2.z) - p0.z + p1.z;
        float dd = pow( xd * xd + yd * yd + zd * zd,1/3); 

        return new Point3D(xt + ( k * yd ) / dd, yt - ( k * xd ) / dd, zt - ( k * xd ) / dd);

    }	

}

/**
* A quad defined by 4 3D points.
*/
class Quad3D{

    Point3D p0,p1,p2,p3;

    Quad3D(Point3D p0, Point3D p1, Point3D p2, Point3D p3){
        this.p0 = p0;
        this.p1 = p1;
        this.p2 = p2;
        this.p3 = p3;
    }   

    void draw(){
        noStroke();
        //smooth();
        beginShape(QUAD_STRIP);	
        vertex(p0.x,p0.y,p0.z);   
        vertex(p3.x,p3.y,p3.z);
        vertex(p1.x,p1.y,p1.z);
        vertex(p2.x,p2.y,p2.z);																					   
        endShape();
    }

}

class Point3D{
    float x, y, z;
    
    Point3D(){
    }

    Point3D(float x, float y, float z){
        this.x = x;
        this.y = y;
        this.z = z;
    }
}  
