import processing.opengl.*;
import processing.video.*;

int numPixels;
int[] backgroundPixels;
Capture video;

float presenceSum = 0;

void setup() {
   video = new Capture(this, 80, 60, 30);
  numPixels = video.width * video.height;

  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  video.loadPixels();

  frameRate(15);
}

void draw() {

  if (video.available()) {
    arraycopy(video.pixels, backgroundPixels);
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available

    presenceSum = 0.0;

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixelÕs color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixelÕs color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);

      presenceSum += (diffR + diffG + diffB);
    }
  }
  presenceSum = map(presenceSum, 0, 1000000, 1, 10);
  println(presenceSum);
}

void stop()
{
  video.stop();
  super.stop();
}

