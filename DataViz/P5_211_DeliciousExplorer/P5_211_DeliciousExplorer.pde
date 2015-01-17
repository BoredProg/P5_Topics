import processing.opengl.*;

Circle c;
PFont font;

void setup(){
  size(1000,1000,OPENGL);
  font = loadFont("Arial48.vlw");  
  //noLoop();
  smooth();
  
  //an Array of names
  String[] names = {"Marius", "Claudia", "Carsten", "Andreas", "Mike", "Sven", "Paulina", "Marie", "Ben", "Ralph", "Carola", "Paul", "Antonia", "John", "Christian"};
  //every name in the names array has a corresponding int array which saves the positon of the contact in the names array
  //so the array for Marius contacts is {1,2,3,7} which means that he is in relation with Claudia Cartsen Andreas and Marie
  int[][] relations = {{1,2,3,7}, {0,3}, {0,4,9}, {1,4}, {2,3,7,8,9}, {3,4,6,7,8}, {0,3}, {0,4}, 
                       {1,4,10}, {1,2,3}, {11,2,3,4}, {0,3}, {0,14}, {1,12}, {1,9,12}};
                       
                       
  c = new Circle(names, relations, 200);
}

float rot;

void draw()
{
   background(210);
   pushMatrix();
   translate(width/2, height/2);
   
   rot +=0.1f;
   rotate(rot);
   

   popMatrix();
  
   c.draw();  
}

class Circle {
  String[] names;
  int[][] relations;
  float radius, degree;
  float centerX, centerY;
  float fontSize;

  Circle (String[] names, int[][] relations, float radius){
    this.names=names;
    this.relations=relations;
    this.radius = radius;
    degree = TWO_PI/names.length;
    centerX=width/2;
    centerY=height/2;
    
    // the maxFontSize is the length of one side regular polygon with names.length edges
    float maxFontSize = 2 * radius * sin(PI / names.length);
    fontSize = maxFontSize/2;
  }

  void draw(){
     
    stroke(125, 75);
    
    for(int i= 0; i<relations.length; i++){
      //we need the actual degree to get the coords and to rotate the text
      float actualDegree = degree*i;

      //the coordinates where the curves starts and the text is drawn 
      float x1 = centerX + cos(actualDegree) * radius;
      float y1 = centerY + sin(actualDegree) * radius;
      
      //drawing the name
      fill(125);
      pushMatrix();
      translate(x1, y1);
      rotate(actualDegree);
      
      
      fill(noise(i/2)*150,255,255 * noise(i));
      rect(0,-15,160,40);
      
      
      
      translate(max(0,400 *1.5 - frameCount*4), (fontSize / 2));      
      textFont(font);
      textSize(fontSize);
      
      fill(230);
      
      text(names[i], 0, 0);
      //sphere(30);
      popMatrix();

      //drawing the arcs for every single relation
      for(int j=0; j<relations[i].length; j++)
      {
        
        //getting the coords for where the arc is ending
        float relationsDegree = relations[i][j]*degree;
        float x2 = centerX + cos(relationsDegree) * radius;
        float y2 = centerY + sin(relationsDegree) * radius;
        
        //getting the two anchor points for the bezier curve 
        //(its a point 1/3 on a line between the center and the arc begin/end point)
        float x3 = lerp(x1, centerX, 0.3f);
        float y3 = lerp(y1, centerY, 0.3f);
        float x4 = lerp(x2, centerX, 0.3f);
        float y4 = lerp(y2, centerY, 0.3f);
        
        //drawing the arc
        noFill();
        beginShape();
        
        vertex(x1, y1);
        bezierVertex(x3, y3, x4, y4, x2, y2);
        endShape();
        
        
      }
      
    }
  }
}
