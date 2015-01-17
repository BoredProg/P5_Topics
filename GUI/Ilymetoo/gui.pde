ControlP5 cp5;

void setupGui() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  ControlWindow guiWin = cp5.addControlWindow("P5Win",10,10,300,200);
  guiWin.setBackground(color(0));
  guiWin.setColorForeground(color(0));

  controlP5.Slider ctlspeedMove = cp5.addSlider("speedMove")
    .setPosition(5,5)
    .setSize(150,15)
    .setRange(1,50)
    .setValue(10);
  ctlspeedMove.setWindow(guiWin);
  
  controlP5.Slider ctlc1Alpha = cp5.addSlider("c1Alpha")
    .setPosition(5,25)
    .setSize(150,15)
    .setRange(0,255)
    .setValue(0);
  ctlc1Alpha.setWindow(guiWin);
  
  controlP5.Slider ctlc2Alpha = cp5.addSlider("c2Alpha")
    .setPosition(5,45)
    .setSize(150,15)
    .setRange(0,255)
    .setValue(0);
  ctlc2Alpha.setWindow(guiWin);

  controlP5.Toggle ctlc2Fill = cp5.addToggle("c2Fill")
    .setPosition(220,45)
    .setSize(15,15)
    .setValue(true);
  ctlc2Fill.setWindow(guiWin);
  
  controlP5.Toggle ctlnbProp = cp5.addToggle("nbProp")
    .setLabel("NBP")
    .setPosition(250,45)
    .setSize(15,15)
    .setValue(false);
  ctlnbProp.setWindow(guiWin);

  controlP5.Slider ctllinkWeight = cp5.addSlider("linkWeight")
    .setPosition(5,65)
    .setSize(150,15)
    .setRange(0,3.0)
    .setValue(1.0);
  ctllinkWeight.setWindow(guiWin);

  controlP5.Slider ctlmaxDist = cp5.addSlider("maxDist")
    .setPosition(5,85)
    .setSize(150,15)
    .setRange(1,127)
    .setValue(25);
  ctlmaxDist.setWindow(guiWin);

  controlP5.Slider ctlbgAlpha = cp5.addSlider("bgAlpha")
    .setPosition(5,105)
    .setSize(150,15)
    .setRange(0,255)
    .setValue(75);
  ctlbgAlpha.setWindow(guiWin);

  controlP5.Toggle ctlstand = cp5.addToggle("stand")
    .setPosition(5,125)
    .setSize(20,20)
    .setValue(false);
  ctlstand.setWindow(guiWin);

  controlP5.Toggle ctlplay = cp5.addToggle("play")
    .setPosition(35,125)
    .setSize(20,20)
    .setValue(true);
  ctlplay.setWindow(guiWin);
  
  controlP5.Slider ctlPop = cp5.addSlider("pop")
    .setPosition(5,160)
    .setSize(150,15)
    .setRange(0,MAXPOP)
    .setValue(300);
  ctlPop.setWindow(guiWin);


}
