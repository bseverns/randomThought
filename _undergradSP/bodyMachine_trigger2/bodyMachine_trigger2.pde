//B.Severns

//reseting the program on its own is still an issue, though it may be more of a hardware thing/the installation
import org.openkinect.*;
import org.openkinect.processing.*;
import processing.serial.*;

//taking away everything that's not moving
boolean resetBackground = true;

//setting the video image's dimensions with hard variables
int kw  = 640;
int kh = 480;

//------------------------------KINECT STUFF
// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;
PImage depthImg;
int minDepth =  50;//end of zone 1
int maxDepth = 250;//start of zone 3
int minimumPresence = 100;//number of change needed for anything to happen
int currentPos = -1;//place the viewer starts at
//accumulated totals of amount of movements in zones
int presenceFront = 0;
int presenceMiddle = 0;
int presenceBack = 0;

//zones
final int NOTHING = 0;
final int SHOOT = 1;
final int BACK  = 2;
//sevond variable for checking the viewer/the program's logic
int whereIsVP = NOTHING;

//presence needed and amount the program looks for things to move
float a;
float thresh;
//frame differencing stuff within the kinect image
int numPixels;
int[] averagePixels;
int[] bgSubAndThreshPixels;

//things that I should be working more with as I debug
boolean firstTime = true;
boolean showBackgroundSubtraction = false;
boolean showThresholded = false;

//---------------------------status of the installation
boolean lights = false;

//---------------------------The serial port
Serial port;


void setup() {
  size(kw, kh);

  //KINECT
  numPixels = kw * kh;//total pixels in the image
  averagePixels = new int[numPixels];
  bgSubAndThreshPixels = new int[numPixels]; 
  // Make the pixels[] array available for direct manipulation
  kinect = new Kinect(this);
  kinect.start();
  println("starting");
  kinect.enableRGB(true);
  println("RGB");
  kinect.enableDepth(true);
  println("depth");
  // We could skip processing the grayscale image for efficiency
  // but I'm using the depthImage for reference, I believe
  kinect.processDepthImage(true);
  tracker = new KinectTracker();
  println("track"); 
  loadPixels();

  // serial/arduino things
  String arduinoPort = Serial.list()[0]; 
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino

  frameRate(10);
}

void draw() {
  background(255);
  a = 0.35;
  thresh = 350;
  // Run the tracking analysis
  tracker.track();
  // Show the image
  arrayCopy(bgSubAndThreshPixels, pixels);
  updatePixels();
}

void keyPressed() { //manual reset function
  if (key == ' ') 
    resetBackground = true;
}

void stop() {
  port.stop();// stop talking to your little buddy, arduino
  kinect.quit();//no more kinect
  tracker.quit();//no more tracking
  super.stop();//stop everything!
}
