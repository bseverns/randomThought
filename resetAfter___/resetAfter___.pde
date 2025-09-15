//Reset-SoftSculptural
//Ben Severns, 3/2017
// Automatic Doodler
// Levente Sandor, 2013

//Activate based on Minim level input - softsculpture visuals
import ddf.minim.*;

Minim minim;
AudioInput in;


ArrayList<PVector> points;
float x0, y0, x, y, angle;
float r, g, b;
float newR, newG, newB;
float xoff = 0.0;
final float step = 5;
final float minDist = step / 2;
final float maxDist = 500;
float alpha = noise(xoff) * 5;

void setup() {

  minim = new Minim(this);                                       
  in = minim.getLineIn();

  fullScreen();
  background(255);
  smooth();

  frameRate(30);
  points = new ArrayList<PVector>();
  x0 = random(width);
  y0 = 0;
  angle = random(TWO_PI);

  r = random(255);
  g = random(255);
  b = random(255);
}

void draw() {
  fill(0, 9);
  rect(0, 0, width, height);
  newR = r * noise(xoff)*3;
  newG = g * noise(xoff)*3;
  newB = b * noise(xoff)*random(3);

  stroke(newR, newG, newB, alpha);
  
  x = (width + x0 + step * cos(angle)) % width;
  y = (height + y0 + step * sin(angle)) % height;

  if (in.left.level() *100000 > 3) {
    PVector pt = new PVector(x, y);
    for (PVector p : points) {
      if (pt.dist(p) < minDist) { 
        pt = points.size() > 500 ? points.get(int(random(500))) : new PVector(random(width), 0);
        break;
      }
    }
    for (PVector p : points) {
      if (pt.dist(p) < maxDist) { 
        line(p.x, p.y, pt.x, pt.y);
      }
    }
    points.add(0, pt);
    x0 = pt.x;
    y0 = pt.y;
    angle += random(-0.3, 0.3);
  }
}

void mouseClicked() {
  setup();
}

void keyPressed() {
  //volume up/down
  if (key == CODED) {
    if (keyCode == UP) {
      xoff = xoff + 0.1;
    } else if (keyCode == DOWN) {
      if (xoff>0.0)
      {
        xoff = xoff - 0.1;
      }
    }
  }
}