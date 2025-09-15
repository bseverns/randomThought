import processing.video.*;
import processing.serial.*;

int frames=240; 
int numPixels;
int[] backgroundPixels;
Capture video;
int presenceSum = 0;
float theta, rotAngle; 

void setup() {
  size(540, 540);
  
  video = new Capture(this, width, height);
  numPixels = video.width * video.height;
  // Create array to store the background image
  video.start();

  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();

  frameRate(1);
  
  smooth(8);
  noFill();
  stroke(255, 150);
  background(0);
}

void draw() {
  
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background

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

      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;

      // Render the difference image to the screen
      pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }

    updatePixels(); // Notify that the pixels[] array has changed
    //println(presenceSum*0.00001); // Print out the total amount of movement
  } 
  
  background(0);
  float t = (frameCount%frames)/float(frames);
  rotAngle = map(t, 0, 1, 0, TWO_PI)* ease(t, 2, 1);
  float sc = map(sin(theta+rotAngle*2), -1, 1, 1, 4);
  for (int i=0; i<numPixels; i++) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(TWO_PI/numPixels*i);
  float x = map(sin(theta+rotAngle+TWO_PI/numPixels*i*2), -1, 1, 30, 200);
    ellipse(x, 0, 30, 30*sc);
    popMatrix();
  }
  theta += TWO_PI/frames;
  //if (frameCount<=frames) saveFrame("image-###.gif");
}

float ease(float t, float e) {
  return t < 0.5 ? 0.5 * pow(2*t, e) : 1 - 0.5 * pow(2*(1 - t), e);
}

float ease(float t, float in, float out) {
  return (1-t)*ease(t, in) + t*ease(t, out);
}
