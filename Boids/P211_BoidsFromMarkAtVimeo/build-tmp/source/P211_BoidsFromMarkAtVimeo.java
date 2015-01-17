import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.processing.*; 
import toxi.geom.*; 
import toxi.geom.mesh.*; 
import toxi.math.*; 
import toxi.physics.*; 
import toxi.physics.constraints.*; 
import toxi.physics.behaviors.*; 
import wblut.math.*; 
import wblut.processing.*; 
import wblut.core.*; 
import wblut.hemesh.*; 
import wblut.geom.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class P211_BoidsFromMarkAtVimeo extends PApplet {














int DIM = 350;
int NUM = 480;
int NEIGHBOR_DIST = 128;
int SEPARATION = 32;
float BOID_SIZE = 4;

SphereConstraint world;
VerletPhysics physics;

HE_Mesh mesh;
HE_Mesh[] cells;
WB_Render render;
boolean drawBoids;
boolean drawMesh;
boolean drawWorld;
boolean drawCells;
boolean runFlock;

Flock flock;

public void setup() {
	size(1600, 900, OPENGL);
	colorMode(RGB, 255);
	initPhysics();

	flock = new Flock();
	// Add an initial set of boids into the system
	for (int i = 0; i < NUM; i++) {
		flock.addBoid(new Boid(new Vec3D(), 0.8f, 0.02f, NEIGHBOR_DIST, SEPARATION));
	}

	flock.init();
	render = new WB_Render(this);
	drawWorld = true;
	drawBoids = true;
	drawMesh = false;
	drawCells = false;
	runFlock = true;
}

public void draw() {
	background(224);
	lights();
	translate(width/2,height/2,0);
	rotateY(mouseX*0.01f);
	if (drawCells) {
		for(int i=0;i<cells.length;i++) {
    	render.drawFaces(cells[i]);
  	}
	} else {
		if (runFlock) flock.run();

		if (drawWorld) {
			noFill();
			stroke(128, 64);
			sphere(DIM);
		}

		if (drawBoids) {
			noStroke();
			fill(64, 192, 128);

			for (int i = 0; i < flock.boids.size(); i++) {
	      Boid b = (Boid) flock.boids.get(i);
	      pushMatrix();
	      translate(b.loc.x, b.loc.y, b.loc.z);
	      sphereDetail(16);
	      sphere(4);
	      popMatrix();
	    }
		}

		if (drawMesh) {
			noStroke();
			fill(64);
			render.drawFaces(mesh);
		}
	}
}

public void keyReleased() {
	switch(key) {
		case 'z':
			drawWorld = !drawWorld;
		break;
		case 'x':
			drawBoids = !drawBoids;
		break;
		case 'c':
			drawMesh = !drawMesh;
		break;
		case 'v':
			runFlock = false;
    	HEMC_VoronoiCells multiCreator=new HEMC_VoronoiCells();
			multiCreator.setMesh(mesh, true);
    	multiCreator.setOffset(5);
    	multiCreator.setSurface(false);
    	multiCreator.setCreateSkin(false);
    	cells=multiCreator.create();
    	background(224);
    	drawCells = true;
		break;
	}
}

public void mouseReleased() {
	flock.addBoid(new Boid(new Vec3D(), 0.8f, 0.02f, NEIGHBOR_DIST, SEPARATION));
}
// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {
  Vec3D loc;
  Vec3D vel;
  Vec3D acc;
  VerletParticle vp;

  float maxforce;
  float maxspeed;

  float neighborDist;
  float desiredSeparation;

  Boid(Vec3D l, float ms, float mf, float nd, float sep) {
    loc=l;
    acc = new Vec3D();
    vel = Vec3D.randomVector();
    maxspeed = ms;
    maxforce = mf;
    neighborDist=nd*nd;
    desiredSeparation=sep;
    vp = new VerletParticle(loc);
  }

  public void run(ArrayList boids) {
    flock(boids);
    update();
    //borders();
  }
  
  // Method to update location
  public void update() {
    // Update velocity
    vel.addSelf(acc);
    vel.limit(maxspeed);
    loc.addSelf(vel);
    vp.x = loc.x;
    vp.y = loc.y;
    vp.z = loc.z;
    vp.update();
    loc.x = vp.x;
    loc.y = vp.y;
    loc.z = vp.z;
    acc.clear();
  }

  // We accumulate a new acceleration each time based on three rules
  public void flock(ArrayList boids) {
    Vec3D sep = separate(boids);   // Separation
    Vec3D ali = align(boids);      // Alignment
    Vec3D coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.scaleSelf(1.5f);
    ali.scaleSelf(1.0f);
    coh.scaleSelf(1.0f);
    // Add the force vectors to acceleration
    acc.addSelf(sep);
    acc.addSelf(ali);
    acc.addSelf(coh);
  }

  public void seek(Vec3D target) {
    acc.addSelf(steer(target,false));
  }

  public void arrive(Vec3D target) {
    acc.addSelf(steer(target,true));
  }


  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  public Vec3D steer(Vec3D target, boolean slowdown) {
    Vec3D steer;  // The steering vector
    Vec3D desired = target.sub(loc);  // A vector pointing from the location to the target
    float d = desired.magnitude(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0f)) desired.scaleSelf(maxspeed*(d/100.0f)); // This damping is somewhat arbitrary
      else desired.scaleSelf(maxspeed);
      // Steering = Desired minus Velocity
      steer = desired.sub(vel).limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new Vec3D();
    }
    return steer;
  }

  // Wraparound
  public void borders() {
    if (loc.x < -DIM) loc.x = DIM;
    if (loc.y < -DIM) loc.y = DIM;
    if (loc.z < -DIM) loc.z = DIM;
    if (loc.x > DIM) loc.x = -DIM;
    if (loc.y > DIM) loc.y = -DIM;
    if (loc.z > DIM) loc.z = -DIM;
  }

  // Separation
  // Method checks for nearby boids and steers away
  public Vec3D separate (ArrayList boids) {
    Vec3D steer = new Vec3D();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = boids.size()-1 ; i >= 0 ; i--) {
      Boid other = (Boid) boids.get(i);
      if (this != other) {
        float d = loc.distanceTo(other.loc);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if (d < desiredSeparation) {
          // Calculate vector pointing away from neighbor
          Vec3D diff = loc.sub(other.loc);
          diff.normalizeTo(1.0f/d);
          steer.addSelf(diff);
          count++;
        }
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.scaleSelf(1.0f/count);
    }

    // As long as the vector is greater than 0
    if (steer.magSquared() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(maxspeed);
      steer.subSelf(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  public Vec3D align (ArrayList boids) {
    Vec3D steer = new Vec3D();
    int count = 0;
    for (int i = boids.size()-1 ; i >= 0 ; i--) {
      Boid other = (Boid) boids.get(i);
      if (this != other) {
        if (loc.distanceToSquared(other.loc) < neighborDist) {
          steer.addSelf(other.vel);
          count++;
        }
      }
    }
    if (count > 0) {
      steer.scaleSelf(1.0f/count);
    }

    // As long as the vector is greater than 0
    if (steer.magSquared() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalizeTo(maxspeed);
      steer.subSelf(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  public Vec3D cohesion (ArrayList boids) {
    Vec3D sum = new Vec3D();   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = boids.size()-1 ; i >= 0 ; i--) {
      Boid other = (Boid) boids.get(i);
      if (this != other) {
        if (loc.distanceToSquared(other.loc) < neighborDist) {
          sum.addSelf(other.loc); // Add location
          count++;
        }
      }
    }
    if (count > 0) {
      sum.scaleSelf(1.0f/count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
}
class Flock {
  ArrayList boids; // An arraylist for all the boids

    Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }

  public void init() {
    //VerletPhysics.addConstraintToAll(world, physics.particles);
  }

  public void run() {
    for (int i = boids.size()-1 ; i >= 0 ; i--) {
      Boid b = (Boid) boids.get(i);
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    convertToMesh();
  }

  public void addBoid(Boid b) {
    boids.add(b);
    physics.addParticle(b.vp);
    VerletPhysics.addConstraintToAll(world, physics.particles);
  }

  public void convertToMesh() {
    WB_Point[] vertices = new WB_Point[boids.size()];

    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);
      vertices[i] = new WB_Point(b.loc.x, b.loc.y, b.loc.z);
    }

    HEC_ConvexHull creator=new HEC_ConvexHull();

    creator.setPoints(vertices);
    creator.setN(vertices.length); // set number of points, can be lower than the number of passed points, only the first N points will be used

    mesh = new HE_Mesh(creator);
  }
}
public void initPhysics() {
	world = new SphereConstraint(new Vec3D(0, 0, 0), DIM, true);
	physics = new VerletPhysics();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "P211_BoidsFromMarkAtVimeo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
