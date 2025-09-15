import ddf.minim.*;
import ddf.minim.analysis.*;

StopWatchTimer t;
boolean reset = false;
int getElapsedTime;

Minim minim;
AudioInput input;

//float in = input.left.level ()*1000;

float s = 0;
int p = 0;

int w = 1440;
int h = 900;

void setup() {
  //size (150, 150, P3D);
  size(displayWidth, displayHeight, P3D);

  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 512);

  frameRate(5);
  //frameRate(60);

  t = new StopWatchTimer();
  t.start();
}

void draw() {
  line(random(w), random(h), random(w), random(h));
  line(random(w*0.85), random(h*0.85), random(w*0.85), random(h*0.85));
  line(random(w*0.65), random(h*0.65), random(w*0.65), random(h*0.65));
  line(random(w*0.35), random(h*0.35), random(w*0.35), random(h*0.35));

  println(input.left.level()*1000);
  //println(ErrorBreakpoint());
  if (input.left.level ()*1250 > 0) {
    colorShift();
  }
  //change millis to 3600000 for hour
  if (getElapsedTime > 36) { 
    reset = true;
    saveFrame("######.jpg");
  }
}

  void colorShift() {
    println("start"); 
    stroke(0);
    println("black");
    if (input.left.level ()*1000 > 3) {
      s = 1;
      if (s == 1) {
        stroke (255);
        println("white");
      }
    }
  }

