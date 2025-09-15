import processing.video.*;

float a = 20;
float b = 30;

Capture video;

void setup() {
  size (displayWidth, displayHeight);

  video = new Capture(this, width, height);
  video.start();
  
  frameRate(10);
  stroke (255, 12);
}

void draw () {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    float brightestX = 0; // X-coordinate of the brightest video pixel
    float brightestY = 0; // Y-coordinate of the brightest video pixel
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
          brightestY = a;
          brightestX = b;
        }
        index++;
      }
    }
    background(0);
    lines(brightestX, brightestY);
  }
}

void lines(float xin, float yin) {
  line(100, 150, a, b);
  line(250, 400, a, b);
  line(400, 100, a, b);
}

