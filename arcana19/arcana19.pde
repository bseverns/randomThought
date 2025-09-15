import processing.video.*;
import processing.io.*;


Movie vis;
Movie run;

void setup() {
  size(640, 480);
  background(0);
  vis = new Movie(this, "....mp4");
  run = new Movie(this, "....mp4");
  GPIO.pinMode(4, GPIO.INPUT);
  vis.loop();
  run.loop();
}

void movieEvent(Movie m) {
  m.read;
}

void draw() {
  if (GPIO.digitalRead(4) == GPIO.HIGH) {
    image(run, 0, 0, width, height);
  } else {
    image(vis, 0, 0, width, height);
  }
}
