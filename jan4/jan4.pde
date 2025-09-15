import processing.video.*;

Capture video;

float r=0;
float g=150;
float b=255;

int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
float brightestValue = 0; // Brightness of the brightest video pixel

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start(); 
  strokeWeight(7);
  background(255);
  smooth();
}

void draw() {
  if (video.available()) {
    video.read();
    //test image
image(video, 0, 0, 64, 48);
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

    stroke(r, g, b);
    line(300, 300, brightestX, brightestY);

    if (brightestX > width/2 & brightestY>height/2) {
      r = r + 1;
      g=g-1;
      b=b+2;
    } else {
      r = r - 1;
    }
    if (brightestX<width/2 & brightestY > height/2) {
      b = b + 3;
      g=g+4;
      r=r+3;
    } else {
      b = b - 2;
    }
    if (brightestX>width/2) {
      g = g - 3;
    } else {
      g = g + 5;
    }
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
    //save ("doodle.png");
  }
}

