
//video control
import processing.video.*;
int numPixels;
int[] previousFrame;
Capture video;

// initialize counter and its duration for debugging and additional future functionality
int countTime = 0;
int framePace = 15;
int countMax = framePace * 10; // make this a 80 second animation

// set background color
int backgroundColor = 255;

int rectColor = 255;  // Do not set it lower than 80, so that the border remains visible
int strokeColor = rectColor - 80; // to make border visible, use 80 as difference

// To set fill or stroke transparency of rectangles. 0 is fully transparent, 255 is fully opaque.
int transparency = 80;

// rectangle border smoothness. 1 equals sharp, 10+ equals very rounded.
int rectBorderShape = 2;

// Set up of the screen and animation properties
void setup() {
  size(1800, 600);

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();

  background(backgroundColor);   // set background to very light grey
  rectMode(CENTER);  // switch rectangle drawing mode for mouseClick user friendliness of interaction

  frameRate(framePace);     // set the framerate
}

void draw() {
  smooth();
  countTime++;  // increment timer for debugging and stopping the animation

  int brightestX = 0; // X-coordinate of the brightest video pixel
  int brightestY = 0; // Y-coordinate of the brightest video pixel
  float brightestValue = 0; // Brightness of the brightest video pixel


  // this if statement makes sure the animation does not go on forever
  if (countTime < countMax) {

    // if mouse is pressed, draw rectangles of random size with a color range from yellow to red
    if (video.available()) {

      video.read();

      //image(video, 0, 0, width, height); // Draw the webcam video onto the screen

      // Search for the brightest pixel: For each row of pixels in the video image and
      // for each pixel in the yth row, compute each pixel's index in the video
      video.loadPixels();

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
        //pixels[i] = color(diffR, diffG, diffB);
        // The following line is much faster, but more confusing to read
        //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
        // Save the current color into the 'previous' buffer
        //previousFrame[i] = currColor;
      }

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


      if (movementSum > 75) { //variable to be controlled with keyPressed
        pushMatrix(); // use this function to make sure the grid is reset after each loop
        translate(brightestX, brightestY);  // translate the origin of the grid to where the mouse is located
        rotate(random(PI));
        fill(255, random (240), 0, transparency);  // the RGB set this way leads to yellow to red colors only
        rect(0, 0, random(5, 80), random(5, 80), rectBorderShape);
      } else {
        noFill();
        strokeWeight(1);   // use small strokes of grey color
        rotate(random(PI));
        stroke(255, random (240), 0, transparency);  // the RGB set this way leads to yellow to red colors only
        rect(0, 0, random(0, 400), random(0, 400), rectBorderShape);

        popMatrix();
      }

      // if mouse is not pressed, draw all the grey rounded rectangles in the background

      float centerX = random(800);
      float centerY = random(800);
      rotate (random(TWO_PI));
      strokeWeight(1); 
      stroke(strokeColor, strokeColor, strokeColor, transparency);
      fill(rectColor, rectColor, rectColor, transparency/2);
      rect (centerX, centerY, random(400), random(400), random(rectBorderShape*5));
      rect (centerX, centerY, random(400), random(400), random(rectBorderShape*5));
    }

    // erase the screen when a key is pressed, and set the timer to 0
    if (countTime > 80) {
      saveFrame("######.jpg");
      background(backgroundColor);
      countTime = 0;
    }
  }
}

