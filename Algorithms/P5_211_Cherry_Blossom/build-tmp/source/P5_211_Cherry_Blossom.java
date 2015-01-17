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

public class P5_211_Cherry_Blossom extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/1103*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/*****************************************************************************
* Cherry Blossom Generator - Create new cherry trees with a mouse click!      *
* Copyright (C) 2009  Luca Ongaro                                             *
* Author's website: http://www.lucaongaro.eu/                                 *
*                                                                             *
* http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt (text of the licence)  *
*                                                                             *
* This program is free software; you can redistribute it and/or               *
* modify it under the terms of the GNU General Public License                 *
* as published by the Free Software Foundation; either version 2              *
* of the License, or (at your option) any later version.                      *
*                                                                             *
* This program is distributed in the hope that it will be useful,             *
* but WITHOUT ANY WARRANTY; without even the implied warranty of              *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               *
* GNU General Public License for more details.                                *
*                                                                             *
* You should have received a copy of the GNU General Public License           *
* along with this program; if not, write to the Free Software                 *
* Foundation, Inc., 51 Franklin Street, Fifth Floor,                          *
* Boston, MA  02110-1301, USA.                                                *
*                                                                             *
******************************************************************************/

int generations = 11;
int n = 1;
int slots = floor(pow(2, generations+1))-1;
int nextSlot = 1;
Branch[] branches = new Branch[slots];

public void setup() {
  size(1280, 720);
  smooth();
  noStroke();
  background(0xffEEEEFF);
  int c1 = color(0xffCCCCFF);
  int c2 = color(0xffEEEEFF);
  gradientBackground(c1, c2);
  branches[0] = new Branch(0, round(random(1, 3)), new Position((width+0.0f)/2, height+0.0f), PI/2);
}

public void draw() {
  stroke(0xff332010);
  fill(0);
  for(int i=0; i<slots; i++) {
    while(branches[i] != null && branches[i].steps > 0) {
      branches[i].drawStep();
    }
    if(nextSlot <= slots - 2) {
      branches[nextSlot] = branches[i].generateChild(0);
      nextSlot += 1;
      branches[nextSlot] = branches[i].generateChild(1);
      nextSlot += 1;
    }
    branches[i].active = false;
  }
  noStroke();
  for(int i=0; i<slots; i++) {
    if(branches[i].generation == generations) {
      ellipseMode(CENTER);
      fill(0xffF2AFC1);
      ellipse(branches[i].position.x+1.5f, branches[i].position.y, random(2, 10), random(2, 10));
      fill(0xffED7A9E);
      ellipse(branches[i].position.x, branches[i].position.y+1.5f, random(2, 10), random(2, 10));
      fill(0xffE54C7C);
      ellipse(branches[i].position.x-1.5f, branches[i].position.y, random(2, 10), random(2, 10));
      float rnd = random(10);
      if(rnd < 0.1f) {
        fill(0xffE54C7C);
        ellipse(branches[i].position.x+random(-100, 100), height-random(20), random(4, 10), random(4, 10));
      }
      else if(rnd > 9.9f) {
        fill(0xffF2AFC1);
        ellipse(branches[i].position.x+random(-100, 100), height-random(20), random(4, 10), random(4, 10));
      }
    }
  }
  noLoop();
}

public void mouseReleased() {
  int c1 = color(0xffCCCCFF);
  int c2 = color(0xffEEEEFF);
  gradientBackground(c1, c2);
  for(int i=0; i<slots; i++) {
    branches[i]=null;
  }
  branches[0] = new Branch(0, round(random(1, 3)), new Position((width+0.0f)/2, height+0.0f), PI/2);
  nextSlot = 1;
  loop();
}

public void gradientBackground(int c1, int c2) {
  for (int i=0; i<=width; i++){
    for (int j = 0; j<=height; j++){
      int c = color(
      (red(c1)+(j)*((red(c2)-red(c1))/height)),
      (green(c1)+(j)*((green(c2)-green(c1))/height)),
      (blue(c1)+(j)*((blue(c2)-blue(c1))/height)) 
        );
      set(i, j, c);
    }
  }
} 

public class Branch {
  public int generation;
  public int steps;
  private int maxSteps;
  private float stepLength;
  public Position position;
  public float angle;
  public float maxAngleVar = 0.2f;
  public boolean active = true;
  Branch(int gen, int mstep, Position p, float ang) {
    this.generation = gen;
    this.maxSteps = mstep;
    this.steps = mstep;
    this.stepLength = 100.0f/(this.generation+1);
    this.position = p;
    this.angle = ang;
  }
  public void drawStep() {
    float r = random(-1, 1);
    this.angle = this.angle + this.maxAngleVar*r;
    this.stepLength = this.stepLength - this.stepLength*0.2f;
    Position oldPosition = new Position(0.0f, 0.0f);
    oldPosition.x = this.position.x;
    oldPosition.y = this.position.y;
    this.position.x += this.stepLength*cos(this.angle);
    this.position.y -= this.stepLength*sin(this.angle);
    strokeWeight(floor(20/(this.generation+1)));
    line(oldPosition.x, oldPosition.y, this.position.x, this.position.y);
    this.steps = this.steps - 1;
  }
  public Branch generateChild(int cn) {
    int newGen = this.generation + 1;
    float angleShift = 0.5f;
    if (cn == 1) {
      angleShift = angleShift*(-1);
    }
    float childAngle = this.angle+angleShift;
    float px = this.position.x;
    float py = this.position.y;
    Position parentPos = new Position(px, py);
    Branch child = new Branch(newGen, floor(random(1, 4)), parentPos, childAngle);
    return child;
  }
}

public class Position {
  public float x;
  public float y; 
  Position(float ax, float ay) {
    this.x = ax;
    this.y = ay;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_Cherry_Blossom" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
