void initPhysics() {
	world = new SphereConstraint(new Vec3D(0, 0, 0), DIM, true);
	physics = new VerletPhysics();
}
