/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/35488*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//Coxcomb Visualizer//0.5//2011//Dominio Publico//Alejandro González//60rpm.tv////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
/*
This is an interactive application that read a group of tsv files and displays a 'coxcomb chart',
some kind of statistical representation invented by Florence Nightingale in XIX century. 
  >> http://es.wikipedia.org/wiki/Archivo:Nightingale-mortality.jpg
Althought the polar nature of the representation is quite beautiful and has some remarkable qualities for making
nice layouts it must be said it's tricky cause it distorts data slightly: values represented near the center
seems bigger than they really are. I think this is one of the main features that
pushed Florence Nightingale to conceive/use it. Despite of all, it's one of the loveliest ways of representing
quantitative data. ^-^
In order to use this applet you need some .tsv files in the data folder and you have to name them 'X'.tsv, where 'X' is the number
that represents the order of display. For example '0.tsv' would be the first table to be displayed, then '1.tsv','2.tsv',etc.
I've used for this example the migration data in Spain from 2000 to 2010. I used data from the INE (Spanish National Institute 
of Statistics) >> http://www.ine.es/
I've used here:
- Travelcons (icons)   --  http://www.dafont.com/search.php?psize=m&q=travelcons
//
This sketch is a very first version of a coxcomb visualizing tool. It has to be seriouslly improved. ^-^
*/

Polar polar;                 //this object groups the polar diagram
ControlRow controlRow;       //and this one the button interface above
TableGroup tG;               //this is the group of tables we are going to use
                    
color 
BACKGROUND_COLOR=#ffffff,     
TEXT_COLOR=#111111;
color[] 
colores={#5E72AA,#5A8DCE};  //these are the sector colors in the diagrams, from inside to outside
int 
n=10;                        //number of tables

void setup() {
  //general settings
  size(700,700); 
  background(BACKGROUND_COLOR);
  noStroke();
  smooth(); 
  cursor(CROSS); 
  ellipseMode(RADIUS);
  colorMode(HSB);
  //constructing objects
  tG=new TableGroup(n);
  polar= new Polar (tG,width/2,height/2,250,18,50000);
  controlRow= new ControlRow(n,110,30,15,tG.getMaxSum(),tG.getMales(),tG.getSums(),tG.getTitles());
}

void draw() {
  background (BACKGROUND_COLOR);
  setCursor();                    //set the cursor
  if (polar.isShifting()) {       //if we are shifting data shift the radiuses of the current element
    polar.getCurrentElement().shiftTo(polar.getCurrentIndex());
  } 
  polar.displayTodo();                //display the element
  controlRow.display();           //display the buttons above
}
