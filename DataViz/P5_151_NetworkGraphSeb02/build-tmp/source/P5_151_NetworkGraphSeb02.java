import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P5_151_NetworkGraphSeb02 extends PApplet {



   Circle c;
   PFont _font;
   int[] _colors = {0xFF04195, 
                    0xFF2262A9, 
                    0xff62ACF7 ,  
                    0xff899AC6 , 
                    0xff8EA5CF , 
                    0xff2A59B1 , 
                    0xff4973AD , 
                    0xff7287C6 , 
                    0xff86A9CF , 
                    0xff8D97D2 , 
                    0xff8EA5CF , 
                    0xff8EA5CF, 
                    0xffEF481, 
                    0xffEF8E1, 
                    0xffF2CE80,
                    0xff8EA5CF, 
                    0xffEF481, 
                    0xffEF8E1, 
                    0xffF2CE80};




public void setup(){
  size(1000,1000, OPENGL);

  
  _font = loadFont("Tahoma24.vlw");
  
  textFont(_font,24);
  //noLoop();
  smooth();
  //an Array of names
  String[] names = {"S\ufffdbastien", "Sarah", "L\ufffdonard", "Andreas", "Mike", "Sven", "Paulina", "Marie", "Ben", "Ralph", "Carola", "Paul", "Antonia", "John", "Christian"};
  //every name in the names array has a corresponding int array which saves the positon of the contact in the names array
  //so the array for Marius contacts is {1,2,3,7} which means that he is in relation with Claudia Cartsen Andreas and Marie
  int[][] relations = {{1,2,3,7,6,5}, 
                       {0,3,5,6}, 
                       {0,4,9}, 
                       {1,4,8,7,5,6}, 
                       {2,3,7,8,9}, 
                       {3,4,6,7,8}, 
                       {0,3,13,13}, 
                       {0,4,8,12}, 
                       {1,4,10}, 
                       {1,2,3}, 
                       {11,2,3,4}, 
                       {0,3,4,5,6,7,12,11}, 
                       {0,14,1,2,3,4,5}, 
                       {1,2,3,4,10,12,14,13,13,13}, 
                       {1,9,12,2,10,9,8,7,6,5,4,3,2}};
  c = new Circle(names, relations, 300);
}

public void draw()
{
   background(0);
   
   stroke(255,50);
  c.draw();
}

class Circle 
{
  String[] names;
  int[][] relations;
  float radius, degree;
  float centerX, centerY;
  float fontSize;

  Circle (String[] names, int[][] relations, float radius)
  {
    this.names          = names;
    this.relations      = relations;
    this.radius         = radius;
    degree              = TWO_PI/names.length;
    centerX             = width/2;
    centerY             = height/2;

    // the maxFontSize is the length of one side 
    // regular polygon with names.length edges
    float maxFontSize = 2 * radius * sin(PI / names.length);
    fontSize = maxFontSize/2;
  }

  float _nodeSize = 10;

  public void draw()
  {

     background(0);    
    
    for(int i= 0; i<relations.length; i++)
    {
      //we need the actual degree to get the coords and to rotate the text
      float actualDegree = degree*i;

      //the coordinates where the curves starts and the text is drawn 
      float x1 = centerX + cos(actualDegree) * radius ;
      float y1 = centerY + sin(actualDegree) * radius ;
      
      //drawing the name
      
      
      // Text drawing..
      pushMatrix();
      translate(x1 , y1 );
      rotate(actualDegree);
      translate(0, (fontSize / 2));

      
      //fill(_colors[i]);

      textFont(_font,24);
      textSize(fontSize/2);
      
      text(names[i], 2, 2);
      popMatrix();

      // Edges drawing
      //drawing the arcs for every single relation
      for(int j=0; j<relations[i].length; j++)
      {
        
        //getting the coords for where the arc is ending
        float relationsDegree = relations[i][j]*degree;
        float x2 = centerX + cos(relationsDegree) * radius ;
        float y2 = centerY + sin(relationsDegree) * radius ;
        
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
        
        stroke(_colors[i],100);
        //stroke(255,150);
        bezierVertex(x3, y3, x4, y4, x2, y2);
        endShape();
        
        ellipse(x2,y2,_nodeSize,_nodeSize);
      }

    }

  }
}



public class Node
{
   
   public Node()
   {}
   
   
   
}

public class Edge
{
   
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_151_NetworkGraphSeb02" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
