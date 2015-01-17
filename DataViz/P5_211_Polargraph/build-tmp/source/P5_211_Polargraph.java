import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_211_Polargraph extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34748*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
///Polar graph tool///2010//Ale Gonz\u00e1lez//http://60rpm.tv/////////////////
//////////////////////////////////////////////////////////////////////////
//An interactive application for the visualization of connection graphs///
//////////////////////////////////////////////////////////////////////////
/*
This is a generic tool for the generation of connection polar graphs.
Graphs show the relationship between elements throught the drawing
of connection lines linking them, in this particular case, in a polar/circular display.
Each line is scaled according to a value that reflects the strength
of the connection, and the amplitude of each element is scaled according to the total strenghth
of all its relationships. There's also the chance to group elements, what\u00b4ll be reflected in the hue of 
them automathically.
This graph takes its data from a .csv file. I didn't find any information on how to store the data 
of a connection graph, so I invented my own way of doing it (better ideas welcome!!).
In order to do that you can find a LibreOffice template in the folder: 
use it, export it as .csv and voil\u00e1. It's pretty straightforward and I really like it cause the data 
is coherent by nature stored this way.
This sketch is intended to be a generic html5/canvas tool, and it works perfectly this way, but it's not
possible as far as I know to upload external files to openp5 processinjs plugin so I uploaded as an
applet. In order to use it in processingjs you have to be specially careful with method overloading (look at
Tabla class) cause it may crush the display with what I call blank-window-crisis, that anxiety crisis that 
overcomes when you have to debug a quite big code in order to find what the f* isn't going on with the f* canvas. 
^-^
*/



PolarGraph graph;  //Main object
int w=18,           //Width of the elements           
R=450,             //radius of the graph
orX,               //x del centro ""
orY,               //y del centro ""
curv_fact=10,       //curve tightness of the connections
cR=360;            //colormode range
float sep=25e-4f,   //sector separation
cR25=cR*.25f,       //generic value one for alpha
cR75=cR*.75f,       //generic value two for alpha
fSw=2.5f;          //connections strokeWeight scaling factor 
int bg=0xffeeeeee;  //background color

public void commonSettings (PGraphics pg){  //basic settings
  pg.colorMode(HSB,cR);
  pg.ellipseMode(RADIUS);
  pg.strokeCap(SQUARE);
  pg.imageMode(CENTER);
  pg.noFill();
  pg.smooth();
}

public void setup(){
  size(1000,1000);
  commonSettings(g);
  orX=width/2+30; orY=height/2;  //Center of the graph
  graph=new PolarGraph("tabla.csv",orX,orY,R,w,curv_fact,sep);
}

public void draw(){
  background(bg);         
  graph.displayBase();                              //shows the polar display of elements
  graph.creaConnect();                              //check selected connections and show them
  if (graph.hover(dist(mouseX,mouseY,orX,orY))){    //show hovered connections
    cursor(HAND);
    graph.creaConnect(atan2((mouseY-orY),(mouseX-orX)));
  }else{
    cursor(CROSS);
  }

}

public void mousePressed(){
  if (mouseButton==LEFT){
    if (graph.hover(dist(mouseX,mouseY,orX,orY))) {   //check if mouse is inside an element
      graph.click(atan2((mouseY-orY),(mouseX-orX)));  //if so, toggle its display
    }else{
      graph.all(false); //if you click outside erase everything
    }
  }else{
    graph.all(true);    //right-click shows everything
  }
}

//POLARGRAPH class/////Main class here///////////////////////////////////////////////////////////////////////////////////////////


class PolarGraph {
  Tabla t;                    //This is the object for storing the external data
  PolarElement[] P;           //Array of elements to be connected
  PGraphics b;                //PGraphics for storing these last. This way we calculate once, and we save resources
  int num,R,R1,w,pesoT_T=0,posX,posY,f,rh1,rh2,nG;  //see below 
  float offs;                 //idem
  int[] groupN,groupC;        //idem
  
  //CONSTRUCTOR
  PolarGraph(String data,int posX,int posY,int R,int w,int f,float offs){
    t=new Tabla(data);                 //url of the location of the data
    this.posX=posX;this.posY=posY;     //center of the graph     
    this.R=R;                          //radius
    this.w=w;                          //width of the elements
    this.f=f;                          //bezier tightness
    this.offs=offs;                    //separation between elements
    num=t.getNumFilas()-1;             //number of elements (considering first row is the legend of the table)
    pesoT_T=t.getTodo(1,num,1,num);    //total number of connections (with this number we'll scale the lenght of the elements)
    R1=R+(w*2);                        //text radius
    rh1=R-(w/2); rh2=R+(w/2);          //min and max to check the hover
    nG=t.getMaxCol(num+1);             //higher value of group (thus, number of groups-1)
    groupN=new int[nG+1];              //number of elements in each group         
    for(int i=0;i<groupN.length;i++){  
      groupN[i]=0; 
    }
    for(int i=1;i<num+1;i++){          //iterate over the group column, each time you find a value add one to its counter 
      groupN[t.getInt(i,num+1)]++;
    } 
    groupC=new int[nG+1];              
    arrayCopy(groupN,groupC);          //lets keep intact that info and create a mirror to use it as a counter afterwards (see createBase method)
    P=new PolarElement[num];           //instantiate group of elements
    for (int i=0;i<P.length;i++){      //calculate the start angle of the element
      P[i]=new PolarElement(i,num);    
      if (i>0){
        int a=0;
        while (a<i){                      
          P[i].addAng(P[a++].getAmp());  //iterate over the elements adding the amplitude of the arcs till we reach current element
        }
      }
      P[i].setCoordinates();  //calculate coordinates of the center of the element and the correspondent control point for the bezier
    } //
    createBase(); //just draw the base
  }  
 
  public void createBase(){
    b=createGraphics(width,height,JAVA2D);
    b.beginDraw();
    commonSettings(b);
    b.strokeWeight(w);
    for (int i=0;i<P.length;i++){                  //Now we'll assignate hue depending on group 
      int eHue=getElement(i).getGroup();           //this the group value
      --groupC[eHue];                              //substract one to its counter
      //this may seem tricky or complex,but it's easy:
      //divide the spectre of hue by number of groups,divide the 75% of spectre of brightness by number of group elements and it the other 25% 
      int strokeColor=color(cR/(nG+1)*eHue,cR75,(cR75/groupN[eHue]*groupC[eHue])+cR25);  
      b.stroke(strokeColor,cR75);
      float n=i<P.length-1?getElement(i+1).getAng():2*PI;  //jumping over an exception
      b.arc(b.width/2,b.height/2,R,R,getElement(i).getAng()+offs,n-offs);  //drawing arcs 
    }
    b.translate(b.width/2,b.height/2);
    b.fill(cR25);
    for (int i=0;i<P.length;i++){   //draw the names
      b.rotate(P[i].getAmp()*.5f);
      b.text(P[i].getElemName(),R1,0);
      b.rotate(P[i].getAmp()*.5f);
    }  
    b.endDraw();
  }
  
  public int getElement(float mouseAngle){  //This method is the responsible of detecting the element hovered
    float teta=(mouseAngle>0)?mouseAngle:map(mouseAngle,-PI,0,PI,2*PI);  //Atan2 can be hateful, I do this trick to handle the angles in a more intuitive way
    int element=0; 
    while (element<P.length){    
      if (P[element].getAng()>teta){
        break;
      } 
      element++;
    } 
    return element-1;  
  }
  
  public void creaConnect(float beta){                        //display hovered connections  
    int i=getElement(beta); 
    text(P[i].getElemName(),50,65);                        //take name
    text(P[i].getElemInfo(),50,80);                         //take info 
    pushMatrix();
    translate (posX,posY); 
    rotate(atan2((P[i].getYc()-posY),(P[i].getXc()-posX)));
    fill(0xff000000,cR75);                                //overwrite the text of the base, I dont like this much but I was lazy to change it
    text(P[i].getElemName(),R1,0);
    popMatrix(); 
    doConnections(i,color(cR25,cR75));                 //draw connections
  }
  
  public void creaConnect () {                 //display selected connections
    for (int i=0; i<P.length; i++){
      if (P[i].getOn()){                //if element is selected
        doConnections(i,0xffcdc6b3);       //do the job
      }
    }
  }
   
  public void doConnections(int e,int connection_color){    //element to connect and colour of connections
    noFill(); 
    stroke(bg);
    strokeWeight(1);
    ellipse(P[e].getXc(),P[e].getYc(),w*.5f,w*.5f);            //this little ellipse clarifies elements selected
    stroke(connection_color);
    for (int j=0; j<num;j++){
      if(P[e].getRel(j)>0){ 
      strokeWeight(P[e].getRel(j)/fSw);                //do thicker lines as connection goes stronger
      noFill();
      bezier(P[e].getXc(),P[e].getYc(),P[e].getCx1(),P[e].getCy1(),P[j].getCx1(),P[j].getCy1(),P[j].getXc(),P[j].getYc());  //make connections 
      }   
    }
  } 
   
  public void click(float beta){   //Select elements clicked
    P[getElement(beta)].toggleOn();
  }
  
  public void all (boolean onOff){            //Clean all selected connections
    for (int i=0;i<P.length;i++){
      P[i].setOn(onOff);
    }
  }
  
  public boolean hover (float d){  //Is the mouse inside an element (anyone)?
    return (d>=rh1 && d<=rh2)?true:false;
  }
  
  public void displayBase(){  //show the base
    image(b,posX,posY); 
  }
   
  public PolarElement getElement(int n_ord){  //a method for getting the elements inside the graph
    return P[n_ord];
  }
   
  //PolarElement class//(!)Internal to PolarGraph////////////////////////////////////////////////////////////////////////////
  
  class PolarElement{
    int[] rels;          //relationship values array
    int ord,nElem,group; //position, number of elements linked to this and group of the element
    float amp,ang,       //element amplitude, beginning angle                     
    xc,yc,cx1,cy1;       //extreme point and control point of a bezier going to this element
    String name,info;     //information about the element
    boolean on=false;    //boolean to check whether an element is selected or not
    
    //CONSTRUCTOR
    PolarElement(int ord,int nElem){
      this.ord=ord; this.nElem=nElem;               
      rels= new int[nElem];                  
      int pesoT=0;                            //total strength of relationships
      for (int i=0;i<=ord;i++){
        pesoT+=(rels[i]=t.getInt(i+1,ord+1));
      }
      for (int i=ord+1;i<nElem;i++){
        pesoT+=(rels[i]=t.getInt(ord+1,i+1));
      }
      amp  =(PI*pesoT/pesoT_T);               //make amplitude proportional to total weight of relationships        
      group=t.getInt(ord+1,nElem+1);          //get rest of info from the table directly
      name =t.getString(ord+1,nElem+2);
      info  =t.getString(ord+1,nElem+3);  
    }
    
    //Rest of methods, quite straightforward
    
    //GET methods
    public float   getAmp(){return amp;}  
    public float   getAng(){return ang;}     
    public int   getGroup(){return group;}
    public String  getElemName(){return name;}
    public String  getElemInfo(){return info;}    
    public float    getXc(){return xc;}
    public float    getYc(){return yc;}
    public float   getCx1(){return cx1;}
    public float   getCy1(){return cy1;}
    public boolean  getOn(){return on;}
    public int     getRel(int position){return rels[position];}    
    
    //SET methods
    public void addAng(float numberToAdd){
     ang+=numberToAdd; 
    }
    public void setCoordinates(){
     xc = posX + (R-w/2) * cos (ang+(amp/2));
     yc = posY + (R-w/2) * sin (ang+(amp/2));
     cx1= posX + (R/f)   * cos (ang+(amp/2));
     cy1= posY + (R/f)   * sin (ang+(amp/2));
    }
    public void toggleOn(){
      on=!on;
    }
    public void setOn(boolean toSet){
      on=toSet; 
    } 
  }//Fin clase PolarElement  
    
//TABLA class//(!) Internal to PolarGraph//Based on Ben Fry's "Visualizing Data"
  
  class Tabla {
    String[][] data;           //data of the table
    int numFilas,numColumnas;  //number of rows and columns

    //CONSTRUCTOR
    Tabla(String source) {   
      String[] filas = loadStrings(source); 
      numFilas=filas.length;
      data = new String[numFilas][];
      for (int i = 0; i < filas.length; i++) {
        //jump over empty rows
        if (trim(filas[i]).length() == 0) {
          continue;
        }   
        //jump over commentaries, startsWith doesn't works on processingjs, you could fix this with substring... I was lazy again here :-)
        //if (filas[i].startsWith("#")) {
          //continue;
        //}   
        data[i] = split(filas[i],",");
      }       
      numColumnas=data[0].length;
    }

    //METHODS
    //Get number of rows
    public int getNumFilas() {
      return numFilas;
    }

    //Get number of columns
    public int getNumColumnas() {
      return numColumnas;
    }

    //Get name of a row specified by its order
    public String getNombreFila(int filas) {
      return getString(filas,0);
    }

    //Get value as a string //  Be careful with method overloading in processingjs // avoid blank window panic crisis!!
    public String getString(int indiceFilas, int columna) {
      return data[indiceFilas][columna];
    }
    public String getString(String nombreFila, int columna)  {      
      return getString(getIndiceFila(nombreFila),columna);
    }

    //Get value as an int   // Be careful with method overloading in processingjs
    public int getInt(String nombreFila, int columna) {
      return parseInt(getString(nombreFila,columna));
    }   
    public int getInt(int indiceFilas, int columna) {
      return parseInt(getString(indiceFilas,columna));
    }

    //Get value as a float // ""
    public float getFloat(String nombreFila, int columna) {
      return parseFloat(getString(nombreFila, columna));
    }
    public float getFloat(int indiceFilas, int columna) {
      return parseFloat(getString(indiceFilas, columna));
    }

    //finds file by its name and returns -1 if doesn't get it
    public int getIndiceFila(String name) {
      for (int i = 0; i < numFilas; i++) {
        if (data[i][0].equals(name)) {
          return i;
        }
      }
      println("No se encontro la fila llamada '"+ name+"'");
      return -1;
    }
    
    //returns total value in a row
    public int totalFila (int indiceFilas) {
      int total=0;
      for (int i=1;i<numColumnas;i++) {
        total+=getInt(indiceFilas,i);
      }
      return total;
    }
    
    //returns total value of an area
    public int getTodo(int f0,int f1,int c0,int c1){
      int todo=0;
      for (int i=1;i<=f1;i++){
        for (int j=1;j<=c1;j++){
           todo+=getInt(i,j);
        }
      }
      return todo; 
    }
    
    //returns maximum value in a column
    public int getMaxCol(int c0){
      int vmax=0;
      for(int i=1;i<getNumFilas();i++){
        int cval=getInt(i,c0);
        vmax=vmax<cval?cval:vmax;
      } 
      return vmax;
    }
    
    //returns maximum value of row sums
    public int maximoTotalesFilas() { 
      int total=0;  
      for (int i=1; i<getNumFilas(); i++) {
        if (totalFila(i)>=total) {
          total=totalFila(i);
        }
      }
      return total;
    }
    
    //returns the sum of every value
    public int sumaTotal() {
      int suma=0;  
      for (int i=1; i<getNumFilas(); i++) {
        suma+=totalFila(i);
      } 
      return suma;
    }
    
  } //end | tabla class
}//end | PolarGraph class
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Polargraph" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
