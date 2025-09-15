import processing.video.*;

float[] x = new float[30];
float[] y = new float[30];
float segLength = 38;

Capture video;

// A boolean to track whether we are recording are not
boolean recording = false;

void setup() {
  size(displayWidth, displayHeight);
  
  stroke(255, 100);
  smooth();
  video = new Capture(this, width, height);
  video.start();
  frameRate(20);
}

void draw() {
  if (video.available()) {
    video.read();
    //image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    strokeWeight(abs(noise(brightestX, brightestY)*20));
    background(0);
    dragSegment(0, brightestX, brightestY);
    for (int i=0; i<x.length-1; i++) {
      dragSegment(i+1, x[i], y[i]);
    }
  }
    if (recording) {
    saveFrame("output/frames####.png");
  }
}

void dragSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
  float angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
}

void segment(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  popMatrix();
}

void keyPressed() {
  // If we press r, start or stop recording!
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
}
