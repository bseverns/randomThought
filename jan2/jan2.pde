//video control
import processing.video.*;
Capture video;

int numParticles = 200;
NewParticle[] p = new NewParticle[numParticles];

float brightestX = 0; // X-coordinate of the brightest video pixel
float brightestY = 0; // Y-coordinate of the brightest video pixel
float brightestValue = 0; // Brightness of the brightest video pixel


void setup() {
  size(500, 500);
  noStroke();
  smooth();

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();

  frameRate(20); //make it fast enough for smooth responsiveness to the mouse


  for (int i = 0; i < p.length; i++) {
    float velX = random(-1, 1);
    float velY = -i;
    // Inputs: x, y, x-velocity, y-velocity,
    // radius, origin x, origin y
    p[i] = new NewParticle(width/2, height/2, velX, velY, 5.0, width/2, height/2);
  }
}

void draw() {
  if (video.available()) {
    video.read();
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

    fill(0, 36);
    rect(0, 0, width, height);
    fill(255, 60);
    for (int i = 0; i < p.length; i++) {
      p[i].update();
      p[i].regenerate();
      p[i].display();
    }
  }
}

