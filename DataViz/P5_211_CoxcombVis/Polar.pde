//POLAR class/////////////////////////////////////////////////////////////////////////////////////////////
//It's pretty complex --maybe I can clarify this--, cause it's composed of an internal class,
//PolarElement, composed by other internal class, called Sector. Although I love internal 
//classes, maybe this composition is hard to get at first sight and 'baroque'...
//So, we have:
//· Polar element -- polar element is a diagram that visualizes the data contained in ONE table,
//what you see when yo run the sketch. 
//· Sector -- sector is the element that builds the polar element, there's one sector for each data bucket
//in the parent PolarElement table. They act as buttons that can trigger display of data, and they have
//hover functions.
//· Polar -- is the class that gathers all PolarElements (with its Sectors) and Tables (external objects
//passed by in the constructor as a TableGroup) in a common frame. 
//It has some methods: a graphic scale tool, that allows a viewer to measure quickly the amounts behind
//the visualization; a method for rotating the display, cause I realized this'd make easier to understand
//and interact with the data displayed; and the bottom row, to display data regarding current element.
////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Polar {
  
  TableGroup tables;       //group of tables
  PolarElement[] P;        //group of elements
  PolarElement current;    //current element
  ControlRow controlRow;   //upper strip of buttons
  PShape[] shapes;         //icons for the legend 
  PVector 
  c;                       //center of the diagram
  int 
  currentIndex=0,          //index of the current element
  NUM_TABLES,              //number of tables/elements
  ROWS,                    //number of rows
  COLS;                    //number of columns
  float  
  SCALE_FACTOR,            //the graphic scale of the diagram  
  ANGLE,                   //the angle of each sector
  HALF_ANGLE,              //suppose it...
  currentAngle=0;          //current angle for displaying the diagram, in order to rotate it  
  float [] 
  shapesF;                 //factor for display the shape with the accurate proportions
  color[] 
  sectorColors=colores,
  hoverColors;          
  color
  SCALER_COLOR=#dddddd, 
  HOVER_COLOR=#9B2A2C,
  BOTTOM_COLOR=0xccffffff;
  PGraphics
  scaler;
  boolean 
  sectorHovered=false,     //do we have the mouse on a sector?  
  scaling=false,            //do we have the graphic scale on?
  shifting=false;          //is the diagram making a transition to other values currently?

  
  //CONSTRUCTOR
  Polar (TableGroup tables,int centerX,int centerY,int maxRadius,int scalerSteps,int scalerStepValue) {
    c=new PVector(centerX,centerY);
    
    //Tables 
    this.tables=tables;
    NUM_TABLES=tables.getN();
    ROWS=tables.getRows();
    COLS=tables.getCols();
    //Constants -- ...
    ANGLE=TWO_PI/tables.getRows();
    HALF_ANGLE=ANGLE/2;
    SCALE_FACTOR=getScale(maxRadius,ANGLE);
    //Colors
    hoverColors=new color[sectorColors.length];
    for (int i=0;i<hoverColors.length;i++){
      hoverColors[i]=sectorColors[i]|0x333300; 
    }
    //Shapes
    shapes=new PShape[COLS];
    shapesF=new float[COLS];
    for (int i=0;i<shapes.length;i++){
      shapes[i]=loadShape(i+".svg"); 
      shapes[i].disableStyle();
      shapesF[i]=shapes[i].width/shapes[i].height;
    }
    
    //Polar Element is the class for only one diagram
    P=new PolarElement[NUM_TABLES];
    for (int i=0;i<P.length;i++) {
      P[i]=new PolarElement(tables.get(i),i);  //we assign the correspondent table to the element and we tell it its index in the whole
    }
    current=new PolarElement(tables.get(currentIndex),currentIndex);  //current diagram | cause of the transitions
    
    //Scaler //This tool is the graphic scale behind the diagram. It consists on a serie of ellipses that reflect certain values.
    //So we have scalerSteps (the number of steps), scalerStepValue (the value of each step) and scalerRadiuses (an array holding the diameter of all ellipses)
    //It doesn't change through execution, so we are going to store it on a PGraphics to save some resources
    float coef_calc=2*scalerStepValue/ANGLE;
    float[] scalerRadiuses=new float[scalerSteps];
    for (int i=0;i<scalerRadiuses.length;i++) {
      scalerRadiuses[i]=sqrt(coef_calc*i)*SCALE_FACTOR;
    }
    scaler=createGraphics(width,height,JAVA2D);
    scaler.beginDraw();
    scaler.background(BACKGROUND_COLOR);
    scaler.smooth();
    scaler.ellipseMode(RADIUS);
    scaler.stroke(SCALER_COLOR);
    scaler.noFill();
    for (int i=0;i<scalerRadiuses.length;i++) {
      scaler.strokeWeight(1.5-i%2);
      scaler.ellipse(c.x,c.y,scalerRadiuses[i],scalerRadiuses[i]);
    }
    scaler.endDraw();
  }

  //METHODS
  
  //This method returns the factor that scales the maximum radius found on the tables to a desired maximum radius (to have control of the layout) 
  float getScale (float desired_maxRadius,float sectorAngle){
    int value=0;
    for (int i=0;i<tables.getN();i++) {
      value = value < tables.get(i).maxRowSum() ? tables.get(i).maxRowSum() : value;   //iterate over the rows with maximum sum of values looking for the biggest value of all
    }
    float real_maxRadius = sqrt(2*value/sectorAngle);   //find the real radius related to that value
    return desired_maxRadius/real_maxRadius;           //returns the factor that transform the latter into desired
  }
  
  //Bunch of get-set methods
  PolarElement getElement (int index) {return P[index];}
  PolarElement getCurrentElement() {return current;}
  
  int  getCurrentIndex() {return currentIndex;}
  void setCurrentIndex (int newIndex) {currentIndex=newIndex;}

  boolean isShifting(){return shifting;}
  void shiftingIs(boolean what){shifting=what;}
  
  void toggleScaler(){scaling=!scaling;}

  //Method for rotating the diagram at will
  void rotateElement (int x,int px,float s) { 
    currentAngle+=(x-px)*s;
  } 
   
  //display methods 
  void displayLegend(int H,int xL){
    float shapeH=H*.75;
    float yL=(height-H)+(shapeH)*.1;
    float yT=yL+textAscent()+textDescent();
    fill(BOTTOM_COLOR);
    rect(0,height-H,width,height);
    fill(TEXT_COLOR);
    String toShow= "total "+tables.getTitle(currentIndex)+": "+nfc(tables.getSums(currentIndex));
    if(sectorHovered&&!shifting) { 
      toShow+="  "+current.getCountrySel()+": "+current.getCountryValueSel()+"  >>  "+current.getValueSel();
    }
    text(toShow,100,yT);
    for (int i=0;i<shapes.length;i++){
      fill(sectorColors[i]);
      shape(shapes[i],xL+=i*20,yL,shapesF[i]*shapeH,shapeH); 
    }
  }

  void displayTodo() {
    if (scaling) image(scaler,0,0);
    pushMatrix();
    translate(c.x,c.y);
    rotate(currentAngle);
    current.display();
    popMatrix();
    displayLegend(50,550);
  }
  
  //Calculates the radius of the sector, depending the value to represent and the scale factor we set up on Polar constructor
  //Area of a circular sector: ANGLE/2 * RADIUS² || i.e.: an ellipse has PI*R² area (angle:TWO_PI)  
  float calcR(int area,float angulo) {
      return sqrt(2*area/angulo)*SCALE_FACTOR;
  }

  //Polar Element | Internal to Polar ////////////////////////////////////////////////////////

  class PolarElement {
    Table      table;    //table related
    Sector[][] sectors;  //bunch of sectors
    int    
    index,               //the index of each element inside the array holder
    reachingCount,       //when we are shifting the element, this int shows us number of sectors that haven't arrived to 'shifting goal'
    valueSel,       //value of a selected sector
    countryValueSel,
    rH,                  //the row of a hovered sector
    cH;                  //the column of a hovered sector
    String
    countrySel="";   //...

    //CONSTRUCTOR
    PolarElement (Table table,int index) {
      this.table=table;
      sectors =new Sector[ROWS][COLS];
      this.index=index; 
      reachingCount=ROWS*COLS;
      //for making the sector we'll operate backwards: we start with the sector of maximum value (sum of all columns) and then 
      //we substract to it further values, cause we are going to overlap the sectors. Messy lines at first, but simple concept behind.
      for (int i=0; i<ROWS;i++) {
        int val=table.rowSum(i+1);
        sectors[i][COLS-1]=new Sector(calcR(val,ANGLE),sectorColors[COLS-1],hoverColors[COLS-1],table.getInt(i+1,COLS));
        for (int j=COLS-2;j>=0;j--) {
          sectors[i][j]=new Sector(calcR(val-=table.getInt(i+1,j+2),ANGLE),sectorColors[j],hoverColors[COLS-1],table.getInt(i+1,j+1));
        }
      }
    }  

    //METHODS
    //Displays the element. As said, we are going to do it backwards, from outside to inside, overlapping the sectors
    void display() {
      pushMatrix();
      //display sector
      for (int i=0;i<ROWS;i++) {                    //for each row of data
        for (int j=COLS-1;j>=0;j--) {               //start outside and go inside
          sectors[i][j].display(rH==i&&cH==j);      //display the sector, telling him if it's hovered
        }    
        //display text 
        rotate(HALF_ANGLE);
        fill(TEXT_COLOR);
        text(table.getString(i+1,0),sectors[i][COLS-1].getRadius()+25,textAscent()*.5);  //display legend
        rotate(HALF_ANGLE);
      }
      popMatrix();
    }

    //Hover method | I suppose there's a much clever way of handling the angle, too much exceptions here. Any good idea appreciated//
    void hover(int mX,int mY) {
      //First, we get the row. That'd be really easy, but atan2 returns a hard-to-handle angle
      float hoverAngle=atan2(mY-c.y,mX-c.x);            //atan2 returns angles from 0 to PI and from 0 to -PI
      if (hoverAngle<0) hoverAngle+=TWO_PI;             //now we have it from 0 to TWO_PI
      hoverAngle-=currentAngle;                         //we substract it the current rotation
      if(hoverAngle<currentAngle) hoverAngle+=TWO_PI;   //this for resolving sign exceptions
      //once we have the angle we want, we only have to divide it by the sector amplitude   
      rH= floor(hoverAngle/ANGLE%15);                   //as 15 triggers an exception, this way we can sort it out    
      float dist_Or= dist(mX,mY,c.x,c.y);
      for (int i=0;i<COLS;i++) {
        if (sectors[rH][i].getRadius()-dist_Or>0) {     //first positive difference reveals the hovered sector
          cH=i;
          sectorHovered= true;
          valueSel=sectors[rH][cH].getValue();
          countrySel=tables.get(0).getString(rH+1,0);
          countryValueSel=tables.get(currentIndex).rowSum(rH+1);
          break;
        }else {
          cH= -1;
          sectorHovered= false;
        }
      }
    }   
    
    String getValueSel(){return nfc(valueSel);}
    String getCountrySel(){return countrySel;}
    String getCountryValueSel(){return nfc(countryValueSel);}
    
    float getSectorRadius (int sR,int sC) {return sectors[sR][sC].getRadius();}
    int getSectorValue (int sR,int sC) {return sectors[sR][sC].getValue();}
    
    void setSectorsGoal(){
      for (int i=0;i<ROWS;i++) {
        for (int j=0;j<COLS;j++) {
           sectors[i][j].setNewGoal();
        }
      }
    }
    
    //This method tells sectors to shift and considers the process over when all they are done
    void shiftTo (int index) {
      for (int i=0;i<ROWS;i++) {
        for (int j=0;j<COLS;j++) {
          if(!sectors[i][j].hasReached()){
            sectors[i][j].shiftRadius(P[index].getSectorRadius(i,j),15f,P[index].getSectorValue(i,j));
          }
        }
      }
      if (reachingCount<=0) {              //if all they are done
        reachingCount=ROWS*COLS;           //so reset the shifting counter
        shifting=false;                    //process is over    
      }
    }

    //SECTOR CLASS///////////////////////////////////////////////////////////////////
    class Sector {
      boolean hovered, reached=true;
      float sectorRadius;
      int sectorValue;
      color sectorColor,hoverColor;

      //CONSTRUCTOR
      Sector (float sectorRadius,color sectorColor,color hoverColor,int sectorValue) {
        this.sectorRadius= sectorRadius; 
        this.sectorValue = sectorValue;
        this.sectorColor = sectorColor;
        this.hoverColor  = hoverColor;
        hovered=false;
      }

      //METODOS
      int getValue() {return sectorValue;}   
      void setValue(int newValue) {sectorValue=newValue;}  
      
      void setNewGoal(){reached=false; }
      boolean hasReached(){return reached;}
     
      float getRadius() {return sectorRadius;}
      void shiftRadius(float newRadius,float easingFactor,int newValue) {
        float distance=newRadius-sectorRadius;   //shift according to distance (easing)
        if (abs(distance)>0.1) {
          sectorRadius+=distance/easingFactor;
        }else{
          sectorValue=newValue;  //set the reached value
          reached=true;           
          reachingCount--;       //strike-through one of the list
        }
      }
      
      boolean isHovered() {return hovered;}
      void display(boolean hovered) {  
        fill(sectorColor);
        if (hovered) fill(hoverColor);
        arc(0,0,sectorRadius,sectorRadius,0,ANGLE);
      }
      
    }  //end of SECTOR CLASS
  }    //end of POLAR ELEMENT CLASS
}      //end of POLAR CLASS

