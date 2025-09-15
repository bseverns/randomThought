//MiM Surveilance
//2014
//B.Severns

import processing.video.*;

Capture video;

PFont f;
float fontSize = 18.5;

int dot = 0;

void setup() {
  size(640, 480);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, 640, 480);

  // Start capturing the images from the camera
  video.start();  

  f = createFont("AdobeHeitiStd-Regular-25.vlw", 25, true);
  textFont(f, 25);
  fill(255);

  frameRate(4);
}

void draw() {

  dot++;

  textAlign(CENTER);

  if (video.available() == true) {
    video.read();
  }
  set(0, 0, video);
  text(":TIMESTAMP:"+int(random(100001, 999999)), 505, 30);
  stroke(122.5);
  line(30, 30, 610, 30);
  line(610, 30, 610, 450);
  line(610, 450, 30, 450);
  line(30, 450, 30, 30);
  if (dot <= 19) {
    dot++;
  }
}