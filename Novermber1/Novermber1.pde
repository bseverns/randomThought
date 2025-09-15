

import processing.video.*;

Capture video;

void setup() {
  size(displayWidth, displayHeight);
  smooth();
  video = new Capture(this, width, height);
  video.start();
  frameRate(20);
}

void draw() {
  int m = millis();
  if (video.available()) {
    video.read();
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
     if (brightestX < height/2) {
    background(0);
    }
    if (brightestY > height/2) {
      background(255);
    }
    if (brightestX < width/2) {
      fill(m % 255, 0, 0);
      rect(0, 0, width/2, height);
    }
    if (brightestY > width/2) {
      fill(0, 0, m % 255);
      rect(width/2, 0, width/2, height);
    }
  }
}

