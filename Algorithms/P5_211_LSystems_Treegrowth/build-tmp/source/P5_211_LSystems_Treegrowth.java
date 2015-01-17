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

public class P5_211_LSystems_Treegrowth extends PApplet {

/*

tree.growth
September, 2005
blprnt@blprnt.com

This sketch generates an infinite set of generative trees. 

The L-System classes in this example could be used for any number of purposes. In this case, the Engine that I have written
to process the L-System string draws a tree, but it could be used to play music, to generate architecture - anything.

The general flow of the system is as such:

1) An member of the Lsystem Class is created with a starting axiom (ie 'FF')
2) A set of rules is created (a RuleSet) made up from individual string substitution rules (a Rule).
3) An Engine is created which will take the final axiom and do something with it (in this case, make a tree).
4) The RuleSet and the Engine are registered to the Lsystem
5) We tell the Lsystem to recurse a certain number of times, then set the Engine going

Controls:
---------

Mouse click - generate new tree set
't' - toggle background from black to white


*/

//FIRST, DECLARE SOME VARIABLES --------------------------
int renderCount = 0;                          //How many steps have we rendered?
boolean playing = true;

int count = 0;                                //Basic frame counter used to refresh

int leafcount;                                //How many leaves are there?
int branchcount;                              //How many branches are there?
Leaf[] leaves = new Leaf[50000];              //Array to store leaves (this could be an ArrayList)
int [] flowercolors = new int[1000000];       //Array to store sampled flower colours (this could be an ArrayList)
int [] leafcolors = new int[1000000];         //Array to store sampled leaf colours (this could be an ArrayList)
int [] branchcolors = new int[1000000];       //Array to store sampled branch colours (this could be an ArrayList)

float startw;                                 //Starting width of the trunk
float leaftype;                               //Leaves are round (<80) or triangular (>80)
float leafinc;                                //Smaller leafinc = more vector shapes per leaf
int fr;                                       //framerate
int drawcount;                                //used for refresh
int bg;                                       //background colour

Lsystem[] currentTrees;

//SET THE FILE UP TO OPEN FULL SCREEN ON EXPORT  --------------------------
//static public void main(String args[]) {
  //PApplet.main(new String[] { "--display=1", "--present", "treegrowth" });
//}

//SET SOME STUFF UP --------------------------
public void setup() {
  
  size(1000,800); 
  smooth();
  frameRate(30);
  
  bg = 255;
  background(bg);
  
  fr = 60;
  restart();
  
};

//GRAB SOME ARRAYS OF COLOURS FROM SAMPLE IMAGES  --------------------------
public void setColors() {

  String leaves[] = {
    "leaves.gif", "leaves2.gif","cherry.gif","flower.gif","leaves3.gif"          };
  int s = ceil(floor(random(leaves.length)));
  String toload = leaves[s];
  PImage b;
  b = loadImage(toload);
  image(b,0,0);
  loadPixels();
  for(int i=0; i<250000; i++) {
    leafcolors[i] = pixels[i];
  };

  String bark[] = {
    "bark1.gif", "bark2.gif","bark3.gif"          };
  int s2 = ceil(floor(random(bark.length)));
  String toload2 = bark[s2];
  PImage b2;
  b2 = loadImage(toload2);
  image(b2,0,0);
  loadPixels();
  for(int i=0; i<250000; i++) {
    branchcolors[i] = pixels[i];
  };

  String flowers[] = {
    "flower.gif","flower2.gif"          };
  int s3 = ceil(floor(random(flowers.length)));
  String toload3 = flowers[s3];
  PImage b3;
  b3 = loadImage(toload3);
  image(b3,0,0);
  loadPixels();
  for(int i=0; i<250000; i++) {
    flowercolors[i] = pixels[i];
  };

  background(bg);
};

//MAKE SOME TREES! --------------------------
public void restart() {
  
  //Set some random values to make the trees look different
  drawcount = 0;
  leafinc = random(0.3f);

  setColors();
  leaftype = random(100);

  branchcount = 0;
  startw = 15 + random(50);
  leafcount = 0;
  
  //Set a random number of trees
  int totalTrees = PApplet.parseInt( random(2,7));
  currentTrees = new Lsystem[totalTrees];
  
  //Make the trees
  for (int i = 0; i < totalTrees; i++) {
    Lsystem nls = new Lsystem("FF");
    nls.axiom = "FF";
    nls.renderindex = 0;
    nls.rendercount = 0;
    nls.rc = 0;
    
    RuleSet rs = new RuleSet();
    Engine e = new Engine(random(width - 200) + 100, height, -0 - random(60), random(-80,20));
    
    rs.init();
    
    String[] rax = {"FF-[-F+F+F-]+[+F-F-F+]:90", "++:5", "--:5"};
    Rule r1 = new Rule("F", rax);
    
    rs.addRule(r1);
    nls.registerRuleSet(rs);
    nls.registerEngine(e);
    nls.recurse(PApplet.parseInt(random(4,7)));
    
    currentTrees[i] = nls;
    
  };

};

//UPDATE THE TREES --------------------------

public void draw() {
  if (playing) {
    count ++;
    drawcount ++;
    if (drawcount > 3500) {
      saveImage();
      renderCount ++;
      if (renderCount < 100) {
        restart();
      }
      else {
        exit();
      };
    };
    if (drawcount > 3600) {
      
    }
    else {
      for (int j = 0; j < currentTrees.length; j++) {
        currentTrees[j].render(0);
      };

      for (int i=0; i<leafcount; i++) {
        leaves[i].render();
      };
    };

  };
};

public void keyPressed() {
  if (key == 't') {
    bg = (bg == 0) ? (255):(0);
    restart();
  };
  if (key == 32) {
    playing = (!playing);
  };
};

public void mousePressed() {
  restart();
};

public void saveImage() {
  save("tree" + month() + "_" + day() + "_" + hour() + "_" + minute() + ".png");
};
/*

Branch
September, 2005
blprnt@blprnt.com

-Renders branches 

*/

public class Branch{

  float xp1;
  float xp2;
  float yp1;
  float yp2;
  float sangle;
  float eangle;
  int branches;
  
  Branch(float x1, float y1, float x2, float y2) {
    xp1 = x1; xp2 = x2; yp1 = y1; yp2 = y2;
    sangle = atan2( (yp2 - yp1), (xp2 - xp1));
    branches = 0;
    render();
  };
  
  public void render() {
    
    float hyp = sqrt(pow((xp2 - xp1),2) + pow((yp2 - yp1),2));
    pushMatrix();
    translate(xp1,yp1);
    
    rotate(sangle);
    
    for (float i=0; i < hyp; i+=3) {
      branches ++;
      rectMode(CENTER);
      noStroke();
    
      int c = branchcolors[branches % branchcolors.length];
      fill(red(c),green(c),blue(c),140);
      rect(i,0,3 + random(2), (startw -   (i * ((startw - pow(startw,0.9f))/hyp))) );
   
    };
    startw = (startw -   (hyp * ((startw - pow(startw,0.9f))/hyp)));
    
    popMatrix();
  };

};
/*

Tree Engine

*/

public class Engine{ 
  float xpos;
  float ypos;
  float angle;
  float unitsize;
  float anglechange;
  float[] xpos_a;
  float[] ypos_a;
  float[] angle_a;
  float[] startw_a;
  int acount;
  
  Engine(float x, float y, float a, float u) {
    xpos = x;
    ypos = y;
    angle = 0;
    anglechange = a;
    unitsize = u;
    
    
    xpos_a = new float[1000];
    ypos_a = new float[1000];
    angle_a = new float[1000];
    startw_a = new float[1000];
    
    acount = 0;
  };
  
  public void init() {
  
  };
  
  public void process(char c) {
    if (c == '+') {
      angle += anglechange;
    }
    else if (c == '-') {
      angle -= anglechange;
    }
    else if (c == 'F') {
      
       float us = unitsize * noise(angle/100);;
       float tx = xpos + (sin(angle * 0.0174532925f * noise(angle/100)) * us);
       float ty = ypos + (cos(angle * 0.0174532925f * noise(angle/200)) * us);
       
       
      stroke(0,0,0,70);
      if (branchcount > 40) {
        line(xpos, ypos, tx, ty);
       }
       else {
       Branch b = new Branch(xpos, ypos, tx, ty);
        };
       xpos = tx;
       ypos = ty;
       
       if (random(10) < (2 * branchcount)) {
         int lc = leafcount % leafcolors.length;
         Leaf l = new Leaf(tx,ty,angle + 90,us, leafcolors[lc]);
         Flower f = new Flower(tx,ty,angle + 90,us, flowercolors[lc]);
         leaves[leafcount] = l;
         leafcount ++;
         if (leafcount > 500) { leafcount = 0;};
         
         float dice = random(100);
         if (dice > 90) {
           int lc2 = leafcount % leafcolors.length;
           Leaf l2 = new Leaf(tx,ty,angle + (noise(angle/10) * 360),us, leafcolors[lc2]);
           leaves[leafcount] = l2;
           leafcount ++;
         };

       };
       
    }
    else if (c =='[') {
      branchcount ++;
      xpos_a = append(xpos_a, xpos);
      ypos_a = append(ypos_a, ypos);
      angle_a = append(angle_a, angle);
      startw_a = append(startw_a, startw);
    }
    else if (c ==']') {
      branchcount --;
      xpos = xpos_a[xpos_a.length - 1];
      ypos = ypos_a[ypos_a.length - 1];
      angle = angle_a[angle_a.length - 1];
      startw = startw_a[startw_a.length - 1];
      
      xpos_a = shorten(xpos_a);
      ypos_a = shorten(ypos_a);
      angle_a = shorten(angle_a);
      startw_a = shorten(startw_a);
    };

  };
  
};
/*

Branch
Flower, 2005
blprnt@blprnt.com

-Renders Flowers 

*/

public class Flower{

  float xpos;
  float ypos;
  float angle;
  float rot;
  float unitsize;
  float s;
  int id;
  int c;
  float scl;

  Flower(float x, float y, float a, float u, int col) {
    s = 0;
    angle = a;
    xpos = x;
    ypos = y;
    rot = 0;
    unitsize = u/4;
    c = col;
    scl = random(2);
    render();
  };

  public void render() {
    if (s<1) {

      if (random(1) < 0.1f) {
        ypos += random(height);
        if (ypos > height) {
          ypos = height - random(5);
        };
      };
      s += 0.2f;
      stroke(0,0,0,5);

      pushMatrix();
      translate(xpos,ypos);

      scale(s * scl);
      for (int i=0; i< 2 + random(10); i++) {
        fill(red(c), green(c), blue(c), 80);

        angle -= 3;
        rotate((angle) * 0.0174532925f);


        triangle(0,0,unitsize * 3,-3,random(2) * unitsize * 3,3);
        ellipseMode(CORNER);
        ellipse(0,0, 2 * unitsize, 2 * unitsize);
      };

      popMatrix();
    };
  };
};
/*

Leaf
September, 2005
blprnt@blprnt.com

-Renders leaves 

*/

public class Leaf{

  float xpos;
  float ypos;
  float angle;
  float rot;
  float unitsize;
  float s;
  int id;
  int c;
  float scl;
  
  Leaf(float x, float y, float a, float u, int col) {
    //angle = a + 90;
    s = 0;
    angle = a;
    xpos = x;
    ypos = y;
    rot = 0;
    unitsize = u/3;
    c = col;
    scl = random(0.2f,1.6f);
    render();
  };
  
  public void render() {
    if (s<1) {
      s += leafinc;
      stroke(0,0,0,5);
    
      pushMatrix();
      translate(xpos,ypos);
   
      fill(red(c), green(c), blue(c), 80);
    
      angle -= 3;
      rotate((angle) * 0.0174532925f);
      scale(s * scl);
     
      if (leaftype <80) {
        ellipseMode(CORNER);
        ellipse(0,0, 2 * unitsize, 2 * unitsize);
      }
      else {
         triangle(0,0,unitsize * 3,-3,unitsize * 3,3);
      };
    
      popMatrix();
    };
  };
};
/*

L-system Class
Built for FlashBelt 2005
blprnt@blprnt.com

Feel free to use it as you wish. Note that it is a very early version and may not work all that well.

Required Classes: Lsystem, RuleSet, Rule, Engine
Test implementation: Tester

*/



public class Lsystem{
  
  String axiom;
  int rc, rm, renderindex, rint, rendercount;
  char[] sa;
  RuleSet ruleset;
  Engine eng;
  Lsystem(String axiom) {
    this.axiom = axiom;
    this.rc = 0;
    this.rendercount = 0;
    this.renderindex = 0;
  };
  
  public void registerRuleSet(RuleSet rs) {
    this.ruleset = rs;
  };
  
  public void registerEngine(Engine the_e) {
  // println("register" + e);
    this.eng = the_e;
    //this.eng.init();
  
  };
  
  public void recurse(int maxi) {
    //println("AXIOM" + this.axiom);
    this.rm = maxi;
    this.rc ++;
    
    this.sa = this.axiom.toCharArray();
    String[] ta = new String[sa.length];
    
    for (int n=0; n<this.sa.length; n++) {
      String replace = this.ruleset.runRule(this.sa[n]);
      
      ta[n] = replace;
    };
    
    this.axiom = join(ta, "");
    
    if (this.rc < this.rm) {
      this.recurse(this.rm);
    }
    else {
      this.rc = 0;
    }; 
  };
  public void render(int step) {
      rendercount = 0;
      doRender();
  };
  
  public void doRender() {
      char[] test = axiom.toCharArray();
      if (renderindex < test.length) {
      eng.process(axiom.charAt(renderindex));
      renderindex ++;
      };
  };
};
/*

L-system Rule Class
Built for FlashBelt 2005
blprnt@blprnt.com

Feel free to use it as you wish. Note that it is a very early version and may not work all that well.

Required Classes: Lsystem, RuleSet, Rule, Engine
Test implementation: Tester

*/

public class Rule{
  String id;
  String[] rules;
  Rule(String name, String[] theruleset) {
    id = name;
    rules = theruleset;
  };
};
/*

L-system RuleSet Class
Built for FlashBelt 2005
blprnt@blprnt.com

Feel free to use it as you wish. Note that it is a very early version and may not work all that well.

Required Classes: Lsystem, RuleSet, Rule, Engine
Test implementation: Tester

*/

public class RuleSet{

  Rule[] rules;
  int rulecount = 0; 
  int test;
  
  RuleSet() {
    rulecount = 0;
    rules = new Rule[10000];
  };
  
  public void init() {
    rulecount = 0;
  };
  
  public void addRule(Rule r) {
    rulecount ++;
    rules[rulecount] = r;
  };
  
   public String runRule(char rid) {

      for (int i=1; i<=rulecount; i++){
      //println(i);
      if (i != 4) {
        if (rules[i].id.charAt(0) == rid) {
          float dice = random(100);
          float chance = 0;
          boolean checked = false;
          int j = 0;
          while (!checked || j < 2) {
              String r = rules[i].rules[j];
              int prob = PApplet.parseInt(r.split(":")[1]);
              
              chance += PApplet.parseFloat(prob);
              
              if (dice < chance) {
                checked = true;
                return(r.split(":")[0]);
              };
              
              j++;
              
          };
        };
      };
      };
      return (str(rid));
   };
};

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_LSystems_Treegrowth" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
