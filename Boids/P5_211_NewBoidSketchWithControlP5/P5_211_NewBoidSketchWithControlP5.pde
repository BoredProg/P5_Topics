//http://www.camnewnham.com/flocking-attractors/

//Libraries
import damkjer.ocd.*;
import peasy.*;
import controlP5.*;

// Cameras, Scene and UI
Camera camOCD;
PeasyCam camPeasy;
ControlP5 cp5;
float sceneSize = 300;

// Flocking Controls
// Set with the HUD Sliders
float neighbourhood;
float separation; float alignment; float cohesion;
float separationDist;
float speed;

// Agents
ArrayList<Agent> agents = new ArrayList<Agent>(); int numAgents = 100; int currentAgent = 0; 

// Attractors
ArrayList<Attractor> attractors = new ArrayList<Attractor>(); int numAttractors = 5; float attrPower;

// Trails
boolean shortTrails = true; boolean drawTrails = true; int trailToggle = 0;

// Camera Controls
boolean followAgents = true; float chaseDist;

void setup() {
  background(0);
  frame.setResizable(true);
  size(1280,720,P3D);
  smooth(32);
  camPeasy = new PeasyCam(this, sceneSize/2, sceneSize/2, sceneSize/2, 500);
  cp5 = new ControlP5(this); set_hud();
  camOCD = new Camera(this, 0.00001, 50000); ViewButton();
  frameRate(100);
  
  create_attractors(numAttractors);
  create_agents(numAgents); agents.get(0).current=true;
}

Agent _currentAgent;

void draw() {
  set_current_camera();
  
  // Draws the agents and attractors
  background(0);
  for (Agent agent:agents) 
  {
     _currentAgent = agent;
    
    agent.find_neighbours();
    
    agent.update();
    agent.display();
    
  }
  
  for (Attractor attractor: attractors) {
    attractor.display();
  }
  
  draw_gui();
}





void create_agents(int numAgents) {
  for (int i=0; i<numAgents; i++)add_agent();
}

void add_agent() {
  PVector loc = new PVector(random(sceneSize), random(sceneSize), random(sceneSize));
  PVector vec = new PVector().random3D();
  Agent agent = new Agent(loc, vec);
  agents.add(agent);
}

void remove_agent(int index) {
  agents.remove(index);
}

class TrailPt {
  PVector loc;
  int age;

  // Initialisation
  TrailPt(PVector _loc, int _age) {
    loc = _loc;
    age = _age;
  }
}

class Agent {
  PVector loc;
  PVector vec;
  PVector centroid = new PVector();
  ArrayList<Agent> neighbours = new ArrayList<Agent>();
  ArrayList<TrailPt> trailPts = new ArrayList<TrailPt>();
  boolean current = false;

  // Initialisation
  Agent(PVector _loc, PVector _vec) {
    loc = _loc;
    vec = _vec;
  }

  void update() {
    find_centroid();
    align();
    cohede();
    separate();
    attract();
    vec.normalize();
    vec.mult(speed);
    loc.add(vec);
    trailPts.add(new TrailPt(loc.get(), 0));
  }

  // Finds the centroid of itself and its neighbours
  void find_centroid() {
    centroid = loc.get();
    for (Agent n: neighbours) {
      centroid.add(n.loc);
    }
    centroid.div(neighbours.size()+1);
  }

  // Find which other agents are nearby
  void find_neighbours() {
    neighbours.clear();
    for (Agent n:agents) {
      if (dist(loc.x, loc.y, loc.z, n.loc.x, n.loc.y, n.loc.z) <= neighbourhood && this != n) {
        neighbours.add(n);
      }
    }
  }    

  // Move away if too close to neighbours
  void separate() {
    if (dist(loc.x, loc.y, loc.z, centroid.x, centroid.y, centroid.z) < neighbourhood*separationDist) {
      PVector separationVec = new PVector(centroid.x - loc.x, centroid.y - loc.y, centroid.z - loc.z);
      separationVec.normalize(); separationVec.mult(-1); separationVec.mult(separation);
      vec.add(separationVec);
    }
  }

  // Steer towards the average heading
  void align() {
    PVector avgHeading = vec.get();
    for (Agent n:neighbours) {
      avgHeading.add(n.vec);
    }
    avgHeading.div(neighbours.size()+1);
    avgHeading.normalize();
    avgHeading.mult(alignment);
    vec.add(avgHeading);
  }

  // Steer towards the average position of local flockmates
  void cohede() {
    PVector cohede = new PVector(centroid.x - loc.x, centroid.y - loc.y, centroid.z - loc.z);
    cohede.normalize();
    cohede.mult(cohesion);
    vec.add(cohede);
  }

  // Move towards the nearby attractors at a 1/d relationship
  void attract() {
   // PVector sumVec = new PVector(0,0,0);
    for (Attractor a: attractors) {
      PVector attrVec = new PVector(a.loc.x-loc.x,a.loc.y-loc.y,a.loc.z-loc.z);
      float dist = attrVec.mag();
      attrVec.setMag(1/dist);
      attrVec.mult(a.mag);
      attrVec.mult(attrPower);
      vec.add(attrVec);
    }
  }
    
  void display() {
    // Draw the agent as a point
    if (current==false) {
      stroke(255);
      strokeWeight(3);
    } 
    else if (current==true) {
      stroke(0, 255, 0);
      strokeWeight(5);
    }
    beginShape(POINTS); 
    vertex(loc.x, loc.y, loc.z); 
    endShape();

    if (drawTrails == true) {
      // Draw the trail as a shape
      beginShape(); 
      noFill();
      for (int i=0; i<trailPts.size(); i++) {
        TrailPt pt = trailPts.get(i);
        pt.age++;
        if (shortTrails==true) {
          if (current==false) {
            stroke(255, 255-pt.age); 
            strokeWeight(1);
          } 
          else if (current==true) {
            stroke(color(0, 255, 0), 255-pt.age); 
            strokeWeight(2);
          }
          if (pt.age < 255) {
            vertex(pt.loc.x, pt.loc.y, pt.loc.z);
          } 
          else { 
            
            trailPts.remove(i);
          }
        } else {
          if (current==false) {
            stroke(255); strokeWeight(1);
            vertex(pt.loc.x, pt.loc.y, pt.loc.z);
          } else if (current==true) {
            stroke(color(0, 255, 0)); strokeWeight(2);
            vertex(pt.loc.x, pt.loc.y, pt.loc.z);
          }
        }          
      }
      endShape();
    }
  }
}
void create_attractors(int numAttractors) {
  for (int i=0; i<numAttractors; i++) {
    add_attractor();
  }
}

void add_attractor() {
  PVector loc = new PVector(random(sceneSize), random(sceneSize), random(sceneSize));
  Attractor attractor = new Attractor(loc, 1);
  attractors.add(attractor);
}

void remove_attractor(int index) {
  attractors.remove(index);
}

class Attractor {
  PVector loc;
  float mag;
  
  // Initialisation
  Attractor(PVector _loc, float _mag) {
    loc = _loc;
    mag = _mag;
  }
  
  void display() {
    // Draw the attractor as a point
    stroke(255,0,0); strokeWeight(5);
    beginShape(POINTS);
    vertex(loc.x, loc.y, loc.z);
    endShape();
  } 
}
// Chooses which camera to use
void set_current_camera() {
  if (followAgents==true) { set_follow_cam(); camPeasy.setMouseControlled(false); }
  else if (cp5.window(this).isMouseOver()) { camPeasy.setMouseControlled(false);  } 
  else { camPeasy.setMouseControlled(true); }
}

// Puts the OCD camera in position for following an agent
void set_follow_cam() {
  Agent thisAgent = agents.get(currentAgent);
  camOCD.aim(thisAgent.loc.x, thisAgent.loc.y, thisAgent.loc.z);
  PVector reverseVec = thisAgent.vec.get();
  reverseVec.mult(chaseDist);
  PVector tarVec = PVector.sub(thisAgent.loc, reverseVec);
  camOCD.jump(tarVec.x, tarVec.y, tarVec.z);
  camOCD.feed();
}
void draw_gui() {
  // Draws the GUI inside a peasy HUD
  hint(DISABLE_DEPTH_TEST);
  camPeasy.beginHUD();
  cp5.draw();
  camPeasy.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

// Just ensures the view button is saying the right thing
void update_view_buttons() {
  if (followAgents==true) {
    cp5.getController("ViewButton").setLabel("Following Agents");
    cp5.getController("NextAgent").setLabel("Next Agent");
  } else if (followAgents==false) {
    cp5.getController("ViewButton").setLabel("Free View");
    cp5.getController("NextAgent").setLabel("Follow Agents");
  }
}

////////////////////////////////////////////////////////////////////////// BUTTONS

// Activated when the "View" button is pressed
void ViewButton() {
  camPeasy.reset();
  followAgents = false;
  update_view_buttons();
}

// Activated when the "Next Agent" button is pressed
void NextAgent() {
  followAgents = true;
  update_view_buttons();
  Agent firstAgent = agents.get(currentAgent);
  firstAgent.current = false;
  if (currentAgent - 1 < numAgents) {
    currentAgent ++;
  } else {
    currentAgent = 0;
  }
  Agent thisAgent = agents.get(currentAgent);
  thisAgent.current = true;
}

// Reset button
void ResetButton() {
  agents.clear(); create_agents(numAgents);
  attractors.clear(); create_attractors(numAttractors);
}

// Toggle button for trails
void TrailsButton() {
  if (trailToggle%3 == 0) { drawTrails = true; shortTrails = false; }
  else if (trailToggle%3 == 1) { drawTrails = false; shortTrails = false; }
  else if (trailToggle%3 == 2) { drawTrails = true; shortTrails = true; }
  trailToggle ++;
}

////////////////////////////////////////////////////////////////////////// SLIDERS

// Activated when the "Agent" slider is moved
void AgentSlider(int value) {
  if (agents.size() < value) {
    for (int i=0; i < value - agents.size(); i++) {
      add_agent();
      numAgents += 1;
    }
  } else if (agents.size() > value) {
    for (int i=0; i > value - agents.size(); i+= -1) {
      int randInt = int(random(agents.size()));
      if (agents.get(randInt).current==false) {
        remove_agent(randInt);
        numAgents += -1;
      }
    }      
  }
}

// Activated when the "Attractor" slider is moved
void AttractorSlider(int value) {
  if (attractors.size() < value) {
    for (int i=0; i < value - attractors.size(); i++) {
      add_attractor();
      numAttractors +=1;
    }
  } else if (attractors.size() > value) {
    for (int i=0; i > value - attractors.size(); i+= -1) {
      int randInt = int(random(attractors.size()));
      remove_attractor(randInt);
      numAttractors += -1;
    }      
  }
}

// Activated when the "Camera" slider is moved
void CameraDistanceSlider(float value) {
  if (followAgents == true) chaseDist = value;
}

void CohesionSlider(float value) { cohesion = value; }
void AlignmentSlider(float value) { alignment = value; }
void SeparationSlider(float value) { separation = value; }
void SpeedSlider(float value) { speed = value; }
void NeighbourhoodSlider(float value) { neighbourhood = value; }
void SeparationDistSlider(float value) { separationDist = value; }
void AttractionSlider(float value) { attrPower = value; }

void set_hud() {
  cp5.setAutoDraw(false); // Makes sure it only draws while inside the peasy HUD
  // Colour scheme override fg, bg, active, caption, value
  CColor RED = new CColor(color(175,0,0),color(75,0,0),color(255,0,0),color(255),color(255));
  CColor PURPLE = new CColor(color(100,25,150),color(60,40,80),color(200,50,255),color(255),color(255));
  CColor GREEN = new CColor(color(0,100,0),color(0,75,0),color(0,255,0),color(255),color(255));

  ////////////////////////////////////////////////////////////////////////// BUTTONS
  float SPACER = 30; float SECTION = 123;

  cp5.addButton("ViewButton")
     .setLabel("Change View")
     .setPosition(width-90, height-(SECTION-SPACER*0))
     .setHeight(27).setWidth(85)
     .setColor(GREEN)
     ;
     
  cp5.addButton("NextAgent")
     .setLabel("Next Agent")
     .setPosition(width-90, height-(SECTION-SPACER*1))
     .setHeight(27).setWidth(85)
     .setColor(GREEN)
     ;
  
  cp5.addButton("TrailsButton")
     .setLabel("Trails")
     .setPosition(width-90, height-(SECTION-SPACER*2))
     .setHeight(27).setWidth(85)
     .setColor(GREEN)
     ;
   
    cp5.addButton("ResetButton")
     .setLabel("Reset")
     .setPosition(width-90, height-(SECTION-SPACER*3))
     .setHeight(27).setWidth(85)
     .setColor(GREEN)
     ;
  
  ////////////////////////////////////////////////////////////////////////// RED SLIDERS
  SPACER = 12; SECTION = 15;

  cp5.addSlider("CameraDistanceSlider")
     .setLabel("Camera")
     .setPosition(5,height-(SECTION+SPACER*0))
     .setWidth(width-100).setHeight(9)
     .setRange(1,200).setValue(10)
     .setColor(RED)
     .setDecimalPrecision(2)
     .getCaptionLabel().style().marginLeft = -100
     ;  
  
  cp5.addSlider("AgentSlider")
     .setLabel("Agents")
     .setPosition(5,height-(SECTION+SPACER*1))
     .setWidth(width-100).setHeight(9)
     .setRange(1, 1000).setValue(numAgents)
     .setColor(RED)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
  cp5.addSlider("AttractorSlider")
     .setLabel("Attractors")
     .setPosition(5,height-(SECTION+SPACER*2))
     .setWidth(width-100).setHeight(9)
     .setRange(0, 100).setValue(numAttractors)
     .setColor(RED)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
  cp5.addSlider("AttractionSlider")
     .setLabel("Attraction")
     .setPosition(5,height-(SECTION+SPACER*3))
     .setWidth(width-100).setHeight(9)
     .setRange(0.0,20).setValue(1)
     .setColor(RED)
     .setDecimalPrecision(2)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
     
  cp5.addSlider("SpeedSlider")
     .setLabel("Speed")
     .setPosition(5,height-(SECTION+SPACER*4))
     .setWidth(width-100).setHeight(9)
     .setRange(0.01,5).setValue(1)
     .setColor(RED)
     .setDecimalPrecision(2)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
     
  ////////////////////////////////////////////////////////////////////////// PURPLE SLIDERS
  SPACER = 12; SECTION = 75;
  
  cp5.addSlider("NeighbourhoodSlider")
     .setLabel("Neighbourhood")
     .setPosition(5,height-(SECTION+SPACER*0))
     .setWidth(width-100).setHeight(9)
     .setRange(1, 200).setValue(25)
     .setColor(PURPLE)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
  cp5.addSlider("SeparationDistSlider")
     .setLabel("Separation Threshold")
     .setPosition(5,height-(SECTION+SPACER*1))
     .setWidth(width-100).setHeight(9)
     .setRange(0.00, 1).setValue(.33)
     .setColor(PURPLE)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
  cp5.addSlider("SeparationSlider")
     .setLabel("Separation")
     .setPosition(5,height-(SECTION+SPACER*2))
     .setWidth(width-100).setHeight(9)
     .setRange(0.01,1).setValue(.5)
     .setColor(PURPLE)
     .setDecimalPrecision(3)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
  cp5.addSlider("AlignmentSlider")
     .setLabel("Alignment")
     .setPosition(5,height-(SECTION+SPACER*3))
     .setWidth(width-100).setHeight(9)
     .setRange(0.01,1).setValue(.5)
     .setColor(PURPLE)
     .setDecimalPrecision(3)
     .getCaptionLabel().style().marginLeft = -100
     ;
     
  cp5.addSlider("CohesionSlider")
     .setLabel("Cohesion")
     .setPosition(5,height-(SECTION+SPACER*4))
     .setWidth(width-100).setHeight(9)
     .setRange(0.01, 1).setValue(.2)
     .setColor(PURPLE)
     .setDecimalPrecision(3)
     .getCaptionLabel().style().marginLeft = -100
     ;
       
}
