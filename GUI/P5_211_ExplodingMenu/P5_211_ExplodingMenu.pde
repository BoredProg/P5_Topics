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

