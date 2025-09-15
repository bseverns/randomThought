//John Fireman Project
//Kinect/video
//Based on a room x by x feet

import org.openkinect.*;
import org.openkinect.processing.*;
import processing.video.*;

//taking away everything that's not moving
boolean resetBackground = true;

//setting the display's dimensions with hard variables
//-------------------------------------------------------------------------------MAKE SURE VIDEOS ARE SIZED TO THESE NUMBERS OR VICE VERSA
int kw  = 640;
int kh = 360;

//------------------------------KINECT STUFF
// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;
PImage depthImg;

//-----------------------------DEPTH VALUES
//The values here could be seen as lines. The numbers 
//should be adjusted to move those lines in space, the 
//bigger the number, the farther from the kinect the line is.
int minDepth =  800;//end of zone 1 
int maxDepth = 1080;//start of zone 3
//---------------------------------------------------------------------------

int minimumPresence = 100;//number of change needed for anything to happen
int currentPos = -1;//place the viewer starts at

//accumulated totals of amount of movements in zones
int presenceFront = 0;
int presenceMiddle = 0;
int presenceBack = 0;

//zones
final int NOTHING = 0;
final int ENTERANCE = 1;
final int CRYING = 2;
final int STOPPING  = 3;
//sevond variable for checking the viewer/the program's logic
int whereIsViewer = NOTHING;

//presence needed and amount the program looks for things to move
float a;
float thresh;
//frame differencing stuff within the kinect image
int numPixels;
int[] averagePixels;
int[] bgSubAndThreshPixels;

//---------------------------status of the file
boolean sIP = false;
//Video things to be changed
Movie demo1;


void setup() {
  size(kw, kh);

  //-----------------------------KINECT STUFF
  numPixels = kw * kh;//total pixels in the image
  averagePixels = new int[numPixels];
  bgSubAndThreshPixels = new int[numPixels];

  // Make the pixels[] array available for direct manipulation
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableRGB(true);
  kinect.enableDepth(true);

  // We could skip processing the grayscale image for efficiency
  // but if the computer is decent leaving this the way it is aids
  //in the computer not being as confused. Probably.
  kinect.processDepthImage(true);
  tracker = new KinectTracker();
  loadPixels();

  //-------------------------------VIDEO
  //Movies must be located in the sketch's data directory or an accessible place on the network to load without an error.
  demo1 = new Movie(this, "021.m4v");
  demo1.play();
  demo1.loop();
  //video playback speed (fps)
  frameRate(30);
}

void draw() {
  background(255);
  // a = 0.35;
  thresh = 150;
  // Run the tracking analysis
  tracker.track();
  // Show the image from the kinect behind the video
  arraycopy(bgSubAndThreshPixels, pixels);
  updatePixels();

  //-----------------------------------VIDEO THINGS
  if (demo1.available()) {
    demo1.read();
  }
  //Movie frame displayed
  image(demo1, 0, 0);
}


//VIDEO EVENTS
void movieEvent(Movie m) {
  m.read();
  sIP = true;
}


void stop() {
  demo1.stop();
  kinect.stop();//no more kinect
  tracker.quit();//no more tracking
  super.stop();//stop everything!
}

