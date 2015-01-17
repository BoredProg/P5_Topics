class Flock {
  ArrayList boids; // An arraylist for all the boids

    Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }

  void init() {
    //VerletPhysics.addConstraintToAll(world, physics.particles);
  }

  void run() {
    for (int i = boids.size()-1 ; i >= 0 ; i--) {
      Boid b = (Boid) boids.get(i);
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    convertToMesh();
  }

  void addBoid(Boid b) {
    boids.add(b);
    physics.addParticle(b.vp);
    VerletPhysics.addConstraintToAll(world, physics.particles);
  }

  void convertToMesh() {
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
