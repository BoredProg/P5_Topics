// Gestion of all the particles
class PointsMovement
{
  float time = 0;  // Time since sketch start
  float tempo;     // How many times per second will a new random force be computed ?
  int lastTime;    // Last frame timestep
  Vector<Particle> particles;
   
  PointsMovement(float t) {
    tempo = t;
    lastTime = millis();
    particles = new Vector<Particle>();
  }
   
  void clear() { particles.clear(); }
   
  void add(PVector p, float r) { particles.add(new Particle(p, r)); }
   
  void reset(PVector p) { // To be called when the particle is moved by the user
    for(Particle pe : particles) {
      if(pe.pos == p) {
        pe.reset();
        return;
      }
    }
  }
   
  void update() {
    int newTime = millis();
    float dt = (newTime - lastTime) / 1000.0;
    lastTime = newTime;
    if(pause) return;
     
    // Is it time to choose new random forces ?
    if(floor(time * tempo) != floor( (time + dt) * tempo))
      for(Particle pe : particles)
        pe.changeDirection();
     
    for(Particle pe : particles)
      pe.update(dt);
    time += dt;
  }
}
