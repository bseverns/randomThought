import org.openkinect.*;
import org.openkinect.processing.*;

int kWidth  = 640;
int kHeight = 480;

PImage depthImg;
int minDepth =  800;
int maxDepth = 960;

int numPixels;

int[] averagePixels;
int[] toScreenPixels;
color white = color(255);
color black = color(0);

boolean firstTime = true;
boolean showBackgroundSubtraction = false;
boolean showThresholded = false;

PImage display;

// Kinect Library object
Kinect kinect;

void setup() {
  // Change size to 320 x 240 if too slow at 640 x 480
  size(kWidth, kHeight); 

  kinect = new Kinect(this);
  kinect.start();
  //kinect.enableDepth(depth);
  kinect.enableRGB(true);
  kinect.enableDepth(true);
  depthImg = new PImage(kWidth, kHeight);


  numPixels = kWidth * kHeight;
  // Create array to store the background image

  averagePixels = new int[numPixels];
  toScreenPixels = new int[numPixels];

  // Make the pixels[] array available for direct manipulation
  loadPixels();
}


void draw() {
  // draw the raw image
  image(kinect.getDepthImage(), 0, 0);
  // pick an alpha (a) value for the moving average
  float a = map(kWidth, 0, width, 0, 1);//I'm not sure what to put instead of mouseX or Y
  float thresh = map(kHeight, 0, height, 0, 255);
  display = createImage(kWidth, kHeight, PConstants.RGB);

  //if (kinect.available()) {
  kinect.getVideoImage(); // Read a new video frame
  //kinect.getPix (); // Make the pixels of video available

    for (int i = 0; i < numPixels; i++) {       
    int currColor = display.pixels[i];       
    int bkgdColor = averagePixels[i];       
    int currR = (currColor >> 16) & 0xFF;
    int currG = (currColor >> 8) & 0xFF;
    int currB = currColor & 0xFF;

    int bkgdR = (bkgdColor >> 16) & 0xFF;
    int bkgdG = (bkgdColor >> 8) & 0xFF;
    int bkgdB = bkgdColor & 0xFF;

    int redAvg = int(a * currR + (1 - a) * bkgdR);
    int greenAvg = int(a * currG + (1 - a) * bkgdG);
    int blueAvg = int(a * currB + (1 - a) * bkgdB);

    // equiv to color(redAvg, greenAvg, blueAvg); , but perhaps slightly faster
    averagePixels[i] = 0xFF000000 | (redAvg << 16) | (greenAvg << 8) | blueAvg; // equiv to color(redAvg, greenAvg, blueAvg);

    if (showBackgroundSubtraction) {
      int bgSubR = abs(bkgdR - currR);
      int bgSubG = abs(bkgdG - currG);
      int bgSubB = abs(bkgdB - currB);

      toScreenPixels[i] = 0xFF000000 | (bgSubR << 16) | (bgSubG << 8) | bgSubB;
      /* }        
       else {         
       toScreenPixels[i] = averagePixels[i];
       }     */
      if (showThresholded) {
        toScreenPixels[i] = brightness(toScreenPixels[i]) > thresh ? 1 : 0;
      }
    }

    //arraycopy(toScreenPixels, pixels);

    //updatePixels();

    fill(255);
  }

  // threshold the depth image
  int rawDepth = depth[offset] * toScreenPixels[offset];
  for (int i=0; i < kWidth*kHeight; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = 0xFFFFFFFF;
    } 
    else {
      depthImg.pixels[i] = 0;
    }
  }

  // draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, kWidth, 0);

  fill(0);
}

void stop() {
  kinect.quit();
  super.stop();
}

