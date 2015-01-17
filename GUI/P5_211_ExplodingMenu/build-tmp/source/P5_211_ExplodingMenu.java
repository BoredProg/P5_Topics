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

public class P5_211_ExplodingMenu extends PApplet {

/**
 * Exploding Menu as basic example sketch.
 * Three buttons are displayed. When you click on the cluster an radial menu appears.
 * Slide over one of the buttons to select or deselect.
 *
 * Exploding Menu enables high precision selection of multiple overlapping markers.
 * See http://tillnagel.com/2011/07/exploding-menu/ for more information.
 *
 * Copyright (c) 2011 Till Nagel, tillnagel.com
 * Licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
 */

ArrayList explodingButtons = new ArrayList();
ExplodingButtonGroup explodingButtonGroup;

public void setup() {
  size(300, 300);
  smooth();

  float cx = width/2;
  float cy = height/2;
  PVector groupCenter = new PVector(cx, cy);
  float groupRadius = 80;

  explodingButtons.add(new ExplodingButton(this, cx, cy, 50));
  ExplodingButton preselectedButton = new ExplodingButton(this, cx, cy, 40);
  preselectedButton.setSelected();
  explodingButtons.add(preselectedButton);
  explodingButtons.add(new ExplodingButton(this, cx, cy, 30));

  explodingButtonGroup = new ExplodingButtonGroup(groupCenter, groupRadius);
  explodingButtonGroup.setExplodingButtonGroup(explodingButtons);
}

public void draw() {
  background(240);

  explodingButtonGroup.updatePositionsInGroupCircle();

  for (int i = 0; i < explodingButtons.size(); i++) {
    ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
    explodingButton.drawDebug();
    explodingButton.draw();
  }
}

public void mousePressed() {
  explodingButtonGroup.pressed(mouseX, mouseY);
}

public void mouseReleased() {
  explodingButtonGroup.released(mouseX, mouseY);
}

public void mouseDragged() {
  explodingButtonGroup.dragged(mouseX, mouseY);
}

public void keyPressed() {
  if (key == '+') {
    explodingButtons.add(new ExplodingButton(this, 300, 300, random(20, 60)));
  } 
  else if (key == '-') {
    explodingButtons.remove(explodingButtons.size() - 1);
  }
}

public class ExplodingButton {

  protected PApplet p;

  protected PVector pos = new PVector();
  protected PVector explodedPos = new PVector();
  protected float size = 50;

  private String statusNormal = "normal";
  private String statusExploded = "exploded";
  private String statusHighlighted = "highlighted";
  private String statusSelected = "selected";
  private String statusExplodedSelected = "explodedSelected";
  private String statusExplodedSelectedHighlighted = "explodedSelectedHighlighted";

  private String status = statusNormal;

  public ExplodingButton(PApplet p) {
    this.p = p;
  }

  public ExplodingButton(PApplet p, PVector pos, PVector explodedPos, float size) {
    this.p = p;
    this.pos = pos;
    if (explodedPos != null) {
      this.explodedPos = explodedPos;
    }
    this.size = size;
  }

  public ExplodingButton(PApplet p, float x, float y, float explodedX, float explodedY, float size) {
    this.p = p;
    this.pos = pos;
    this.explodedPos = new PVector(explodedX, explodedY);
    this.size = size;
  }

  public ExplodingButton(PApplet p, float x, float y, float size) {
    this.p = p;
    this.pos = new PVector(x, y);
    this.size = size;
  }

  public void draw() {
    p.strokeWeight(2);
    p.stroke(10, 150);
    if (status.equals(statusNormal)) {
      drawNormal();
    }
    if (status.equals(statusExploded)) {
      drawExploded();
    }
    if (status.equals(statusHighlighted)) {
      drawExplodedHighlighted();
    }
    if (status.equals(statusSelected)) {
      drawSelected();
    }
    if (status.equals(statusExplodedSelected)) {
      drawExplodedSelected();
    }
    if (status.equals(statusExplodedSelectedHighlighted)) {
      drawExplodedSelectedHighlighted();
    }
  }

  protected void drawNormal() {
    p.fill(200);
    p.ellipse(pos.x, pos.y, size, size);
  }

  protected void drawExploded() {
    p.fill(200);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  protected void drawExplodedHighlighted() {
    p.fill(200, 0, 0, 170);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  protected void drawSelected() {
    p.fill(255, 0, 0);
    p.ellipse(pos.x, pos.y, size, size);
  }

  protected void drawExplodedSelected() {
    p.fill(255, 0, 0);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  protected void drawExplodedSelectedHighlighted() {
    p.fill(200, 200, 0, 170);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  public void drawDebug() {
    p.stroke(1);
    p.stroke(10, 40);
    p.noFill();
    p.ellipse(pos.x, pos.y, size, size);
    p.ellipse(explodedPos.x, explodedPos.y, size, size);
  }

  public void pressed(float checkX, float checkY) {
    if (isHit(checkX, checkY, pos)) {
      if (status.equals(statusNormal)) {
        status = statusExploded;
      } 
      else if (status.equals(statusSelected)) {
        status = statusExplodedSelected;
      }
    }
  }

  public void dragged(float checkX, float checkY) {
    if (status.equals(statusExploded) || status.equals(statusHighlighted)) {
      if (isHit(checkX, checkY, explodedPos)) {
        status = statusHighlighted;
      } 
      else {
        status = statusExploded;
      }
    }

    if (status.equals(statusExplodedSelected) || status.equals(statusExplodedSelectedHighlighted)) {
      if (isHit(checkX, checkY, explodedPos)) {
        status = statusExplodedSelectedHighlighted;
      } 
      else {
        status = statusExplodedSelected;
      }
    }
  }

  public void released(float checkX, float checkY) {
    if (status.equals(statusHighlighted) && isHit(checkX, checkY, explodedPos)) {
      status = statusSelected;
    } 
    else if (status.equals(statusExploded)) {
      status = statusNormal;
    } 
    else if (status.equals(statusExplodedSelectedHighlighted)) {
      if (isHit(checkX, checkY, explodedPos)) {
        status = statusNormal;
      } 
      else {
        status = statusSelected;
      }
    } 
    else if (status.equals(statusExplodedSelected)) {
      if (isHit(checkX, checkY, explodedPos)) {
        // This state is not accessible (as onOver it's still explodedSelectedHigh)
      } 
      else {
        status = statusSelected;
      }
    }
  }

  protected boolean isHit(float checkX, float checkY, PVector pos) {
    boolean hit = dist(checkX, checkY, pos.x, pos.y) < this.size / 2;
    return hit;
  }

  public void setSelected() {
    status = statusSelected;
  }

  public void setExplodedPos(float x, float y) {
    explodedPos.x = x;
    explodedPos.y = y;
  }

  public boolean isSelected() {
    return status.equals(statusSelected);
  }

  public boolean isNormal() {
    return status.equals(statusNormal);
  }
}
public class ExplodingButtonGroup {

  public static final float DEFAULT_RADIUS = 100;

  public PVector center = new PVector(300, 300);
  public float radius;

  ArrayList explodingButtons = new ArrayList();

  public ExplodingButtonGroup(PVector groupCenter) {
    this(groupCenter, DEFAULT_RADIUS, null);
  }

  public ExplodingButtonGroup(PVector groupCenter, float groupRadius) {
    this(groupCenter, groupRadius, null);
  }

  public ExplodingButtonGroup(PVector groupCenter, float groupRadius, ArrayList explodingButtons) {
    this.center = groupCenter;
    this.radius = groupRadius;
    if (explodingButtons != null) {
      this.explodingButtons = explodingButtons;
    }
  }

  public void updatePositionsInGroupCircle() {
    float angle = 0;
    float dAngle = TWO_PI / explodingButtons.size();

    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      angle += dAngle;
      float x = center.x + (int) (radius * Math.cos(angle));
      float y = center.y + (int) (radius * Math.sin(angle));
      explodingButton.setExplodedPos(x, y);
    }
  }

  public void draw() {
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.drawDebug();
      explodingButton.draw();
    }
  }

  public void addExplodingButton(ExplodingButton btn) {
    this.explodingButtons.add(btn);
    updatePositionsInGroupCircle();
  }

  public void setExplodingButtonGroup(ArrayList explodingButtons) {
    this.explodingButtons = explodingButtons;
  }

  public void pressed(int mouseX, int mouseY) {
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.pressed(mouseX, mouseY);
    }
  }

  public void dragged(int mouseX, int mouseY) {
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.dragged(mouseX, mouseY);
    }
  }

  public ExplodingButton released(int mouseX, int mouseY) {
    // TODO Return list to allow multiple selection
    ExplodingButton selectedExplodingButton = null;
    for (int i = 0; i < explodingButtons.size(); i++) {
      ExplodingButton explodingButton = (ExplodingButton) explodingButtons.get(i);
      explodingButton.released(mouseX, mouseY);
      boolean hit = explodingButton.isHit(mouseX, mouseY, explodingButton.explodedPos);
      if (hit && (explodingButton.isSelected() || explodingButton.isNormal())) {
        selectedExplodingButton = explodingButton;
      }
    }
    return selectedExplodingButton;
  }

  public boolean isEmpty() {
    return explodingButtons.isEmpty();
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P5_211_ExplodingMenu" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
