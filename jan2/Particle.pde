class Particle {

  float xp, yp; // The x- and y-coordinates
  float vx, vy; // The x- and y-velocities
  float radius; // Particle radius
  float gravity = 0.1;

  Particle(int xpos, int ypos, float velx, float vely, float r) {
    brightestX = xpos;
    brightestY = ypos;
    vx = velx;
    vy = vely;
    radius = r;
  }

  void update() {
    vy = vy + gravity;
    brightestY += vy;
    brightestX += vx;
  }

  void display() {
    ellipse(brightestX, brightestY, radius, radius*2);
  }
}

class NewParticle extends Particle {
  float originX, originY;
  NewParticle(int xIn, int yIn, float vxIn, float vyIn, 
  float r, float ox, float oy) {
    super(xIn, yIn, vxIn, vyIn, r);
    originX = ox;
    originY = oy;
  }
  void regenerate() {
    if ((brightestX > width+radius) || (brightestX < -radius) ||
      (brightestY > height+radius) || (brightestY < -radius)) {
      brightestX = originX;
      brightestY = originY-20;
      vx = random(-50, 50);
      vy = random(50, -50);
    }
  }
}
