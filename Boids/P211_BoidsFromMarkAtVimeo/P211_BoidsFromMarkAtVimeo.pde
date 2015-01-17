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

void setup() {
	size(1600, 900, OPENGL);
	colorMode(RGB, 255);
	initPhysics();

	flock = new Flock();
	// Add an initial set of boids into the system
	for (int i = 0; i < NUM; i++) {
		flock.addBoid(new Boid(new Vec3D(), 0.8, 0.02, NEIGHBOR_DIST, SEPARATION));
	}

	flock.init();
	render = new WB_Render(this);
	drawWorld = true;
	drawBoids = true;
	drawMesh = false;
	drawCells = false;
	runFlock = true;
}

void draw() {
	background(224);
	lights();
	translate(width/2,height/2,0);
	rotateY(mouseX*0.01);
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

void keyReleased() {
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

void mouseReleased() {
	flock.addBoid(new Boid(new Vec3D(), 0.8, 0.02, NEIGHBOR_DIST, SEPARATION));
}
