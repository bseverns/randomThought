// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

import org.openkinect.*;
import org.openkinect.processing.*;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

boolean resetBackground = true;

int kw  = 640;
int kh = 480;

PImage depthImg;
int minDepth =  800;
int maxDepth = 990;

int minimumPresence = 100;
int presenceFront = 0;
int presenceMiddle = 0;
int presenceBack = 0;


final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;
int whereIsViewer = NOTHING;

int by = 0;

float a;
float thresh;
//frame differencing stuff
int numPixels;
int[] averagePixels;
int[] bgSubAndThreshPixels;

boolean firstTime = true;
boolean showBackgroundSubtraction = false;
boolean showThresholded = false;

void setup() {
  size(640, 520);
  numPixels = kw * kh;
  averagePixels = new int[numPixels];
  bgSubAndThreshPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  //loadPixels();

  kinect = new Kinect(this);
  kinect.start();

  kinect.enableRGB(true);
  kinect.enableDepth(true);

  // We could skip processing the grayscale image for efficiency
  // but this example is just demonstrating everything
  kinect.processDepthImage(true);

  tracker = new KinectTracker();
  frameRate(10);

  loadPixels();
}

void draw() {
  background(255);
  a = 0.35;//map(mouseX, 0, width, 0, 1);//I'm not sure what to put instead of mouseX or Y
  //println("MOUSEX=" + mouseX + " / a=" + a); // 
  thresh = 150;// map(mouseY, 0, height, 0, 255);
  // Run the tracking analysis
  tracker.track();
  // Show the image
  arraycopy(bgSubAndThreshPixels, pixels);
  updatePixels();
}

void keyPressed() {
  if (key == ' ') 
    resetBackground = true;
}

void stop() {
  tracker.quit();
  super.stop();
}















