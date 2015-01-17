import controlP5.*;  //import the library with the selectors
import java.util.*;  //import java stuffs used for temperature
 
//declare library
ControlP5 MyControler;
 
//declare background color 
int backgroundcolor = 90;
 
// two parallel 2D arrays
Cell[][] cellGrid = new Cell[6][6]; 
Slider[][] sliderValue = new Slider [6][6]; 
Slider[][] sliderTemp3X3 = new Slider [2][2];
Slider[][] sliderTemp2X2 = new Slider [3][3];
 
 
void setup() {
  size(1425, 800);
  background(backgroundcolor);
  MyControler = new ControlP5(this);
  // init
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 6; j++) {
      int rndValue= int (random (1, 4.99));
      cellGrid[i][j] = new Cell (i, j, rndValue);
      sliderValue[i][j] = MyControler.addSlider("Cell_"+i+"_"+j, 1, 4, i*54+500, j*65+25, 15, 40).setNumberOfTickMarks(4);
      MyControler.getController("Cell_"+i+"_"+j).setValue(rndValue);
    } // for
  } // for
  //Create Slider for Temperature 6X6
  Slider slidTemperature6X6 = MyControler.addSlider("Temp 6X6", 0, 3, 2, 600, 490, 50, 50);
  //Create Sliders for Temperatures 3X3
  for (int i = 0; i<2; i++) {
    for (int j = 0; j<2; j++) {
      sliderTemp3X3[i][j] = MyControler.addSlider("Temp 3X3_"+i+"_"+j, 0, 3, i*75+270, j*75+500, 50, 50);
    } // for
  } // for
 
  //Create Slider for Temperature 2X2
    for (int i = 0; i<3; i++) {
    for (int j = 0; j<3; j++) {
      sliderTemp2X2[i][j] = MyControler.addSlider("Temp 2X2_"+i+"_"+j, 0, 3, i*75+30, j*75+500, 40, 40);
    } // for
  } // for
 
 
} // func setup
 
void draw() {
  background(backgroundcolor);
  // update and show
  for (int i = 0; i<6; i++) {
    for (int j = 0; j<6; j++) {
      cellGrid[i][j].displayCell();
    } // for
  } // for
 
  //CALCUL TEMPERATURE 6X6
  //Create 1D array of all cell values in the grid
  int[] valueTemp6X6 = new int[36];
  for (int i = 0; i<6; i++) {
    for (int j = 0; j<6; j++) {
      valueTemp6X6[(6*i)+j] = cellGrid[i][j].v;
    } // for
  } // for
  //Calculate number of different values in this 1D array
  Set<Integer> setValueTemp6X6 = new TreeSet<Integer>();
  for (Integer element : valueTemp6X6 ) {
    setValueTemp6X6.add(element);
  } // for
  int nbrValueTemp6X6 = setValueTemp6X6.size();
  //Calculate temperature of the whole grid
  int temperature6X6 = (nbrValueTemp6X6 - 1);
  // Update Slider Temperature 6X6
  MyControler.getController("Temp 6X6").setValue(temperature6X6);
 
  //CALCUL ALL TEMPERATURE 3X3
  for (int y = 0; y<2; y++) {
    for (int z = 0; z<2; z++) {
      int[] valueTemp3X3 = new int [9];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          valueTemp3X3[(3*i)+j] = cellGrid[i+(y*3)][j+(z*3)].v;
        } // for
      } // for
      //Calculate number of different values in this 1D array
      Set<Integer> setValueTemp3X3 = new TreeSet<Integer>();
      for (Integer element : valueTemp3X3 ) {
        setValueTemp3X3.add(element);
      } // for
      int nbrValueTemp3X3 = setValueTemp3X3.size();
      //Calculate temperature of grid part
      int temperature3X3 = (nbrValueTemp3X3 - 1);
      // Update Sliders Temperature 3X3 
      MyControler.getController("Temp 3X3_"+y+"_"+z).setValue(temperature3X3);
    } // for
  } // for
 
  //CALCUL ALL TEMPERATURE 2X2
    for (int y = 0; y<3; y++) {
    for (int z = 0; z<3; z++) {
      int[] valueTemp2X2 = new int [4];
      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
          valueTemp2X2[(2*i)+j] = cellGrid[i+(y*2)][j+(z*2)].v;
        } // for
      } // for
      //Calculate number of different values in this 1D array
      Set<Integer> setValueTemp2X2 = new TreeSet<Integer>();
      for (Integer element : valueTemp2X2 ) {
        setValueTemp2X2.add(element);
      } // for
      int nbrValueTemp2X2 = setValueTemp2X2.size();
      //Calculate temperature of grid part
      int temperature2X2 = (nbrValueTemp2X2 - 1);
      // Update Sliders Temperature 2X2 
      MyControler.getController("Temp 2X2_"+y+"_"+z).setValue(temperature2X2);
    } // for
  } // for
 
} // func draw 
 
class Cell {
  //Global Variables
 
  int x;  //number of the cell on x axis, from 0 to 5
  int y;  //number of the cell on y axis, from 0 to 5
  int w = 65;  //width of the cell (tunable)
  int h = 65;  //height of the cell (tunable)
  int v;       //value of the cell = here white/pink/red/black
 
  int posX, posY;
 
  String nameSlider; 
 
  //Constructor
  Cell (int _x, int _y, int _v) {
    v = _v;
    x = _x;
    y = _y;
    posX = (x*w)+25;
    posY = (y*h)+25;
    nameSlider = "Cell_"+x+"_"+y;
  } // Constructor 
 
  //Functions
  void displayCell() {
 
    // update and show
 
    v = int( MyControler.getController(nameSlider).getValue());
 
    stroke(0);
    // noStroke();
 
    //COLORING :
    switch (int(v)) {   
    case 1:
      fill(255, 195, 225);
      break;
    case 2:
      fill(255, 145, 175);
      break; 
    case 3:
      fill(205, 95, 125);
      break;
    default:
      fill(185, 75, 105);
      break;
    } // switch     
    //DRAWING OF THE CELL ITSELF
    rect( posX, posY, w, h);
  } // method
} // class
