//Sandor, 2013
//Severns, 2017

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;

int inOFF = 10000;

ArrayList<PVector> points;
float x0, y0, x, y, angle;
int r, g, b;
float xoff = 0.0;
final float step = 5;
final float minDist = step / 2;
final float maxDist = 500;
final float animationThreshold = 200;

void setup() {
  fullScreen();
  //size(200, 200);
  background(255);
  smooth();
  minim = new Minim(this);
  in = minim.getLineIn();
  frameRate(60);
  points = new ArrayList<PVector>();
  x0 = random(width);
  y0 = 0;
  angle = random(TWO_PI);
  r = int(random(100, 255));
    g = int(random(100, 255));
    b = int(random(100, 255));
}

void draw() {
  println(in.left.level());
  fill(0, 1);
  rect(0, 0, width, height);
  if (in.left.level()*inOFF>0.15) {
    r = int(random(100, 255));
    g = int(random(100, 255));
    b = int(random(100, 255));
    float alpha = noise(xoff) * random(25, 75);
    stroke(r, g, b, alpha);
    x = (width + x0 + step * cos(angle)) % width;
    y = (height + y0 + step * sin(angle)) % height;
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

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      inOFF = inOFF + 50;
    } else if (keyCode == DOWN) {
      inOFF = inOFF - 50;
    }
  }
}

void mouseClicked() {
  setup();
}