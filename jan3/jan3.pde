Blade diagonal;

//video control
import processing.video.*;
Capture video;

//image analysis
int numPixels;
int[] previousFrame;

int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
float brightestValue = 0; // Brightness of the brightest video pixel

void setup() {
  size(400, 400);
  diagonal = new Blade(200, 200);
  stroke(3);
  fill(10, 100, 250);
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();
}


void draw() {
  diagonal.grow();
  stroke(3);
  fill(255);

  if (video.available()) {
    video.read();
    video.loadPixels();
    int index = 0;

    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];

      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;

      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;

      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);

      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;

      // Render the difference image to the screen
      //  pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }

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
    if (movementSum>=250000) {
      diagonal.seed(brightestX, brightestY);
      stroke(3);
      fill(100, 100, 255);
    }
  }
}

