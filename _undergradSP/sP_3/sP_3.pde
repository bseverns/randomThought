//------------------------------------------GLOBAL THINGS--------------------------------------
//libraries
import org.openkinect.*;
import org.openkinect.processing.*;
import processing.serial.*;
import oscP5.*;
import netP5.*;

final int WIDTH = 640;
final int HEIGHT = 480;

//Kinect
KinectTracker tracker;
Kinect kinect;
//global variables for everything to sample from
int presenceSum = 0;
int rawDepthToMeters = 0;
// Gathers the look up table
float[] depthLookUp = new float[2048];

final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;
int currentPos = -1;
int whereIsViewer = NOTHING;
boolean hasEntered = false;

//oscP5 vairables
OscP5 oscP5;
NetAddress myRemoteLocation;
int processingListeningPort = 12000;
int maxMSPListeningPort = 7400;
String maxMSPipAddress = "127.0.0.1";

//status of the file
boolean isPlaying = false;
boolean isRecording = false;

// The serial port
Serial port;

//Arduino
boolean firstContact = false;
int relayPin = 7;

//------------------------------------------SETUP---------------------------------------------
void setup() {
  //don't want to display anything, just want the 
  //computer to know what's happening and so just processes the 3D info
  size(WIDTH, HEIGHT, P3D);

  //kinect things
  kinect = new Kinect(this);
  tracker = new KinectTracker();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, processingListeningPort);
  /* set it to send to the maxmsp on port 7400 */
  myRemoteLocation = new NetAddress(maxMSPipAddress, maxMSPListeningPort);

  // serial/arduino things
  String arduinoPort = Serial.list()[0]; 
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino

  //overall setting
  frameRate(2);
}


//--------------------------------------------DRAW LOOP---------------------------------------------------
void draw() {
  println(whereIsViewer);
  // Run the tracking analysis
  tracker.tracker();
}

//----------------------------------------------STOP---------------------------------------------------------
void stop() {
  port.stop();// stop talking to your little buddy, arduino
  kinect.quit();// turn off the kinect
  super.stop(); // call the parent stop class
}

