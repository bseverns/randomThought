//------------------------------------------GLOBAL THINGS--------------------------------------
//libraries
import ddf.minim.*;
import ddf.minim.signals.*;
import org.openkinect.*;
import org.openkinect.processing.*;
import processing.serial.*;

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
boolean isRecording = false;

final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;

String currentRecorderFilename = "currentActivity.wav";

int whereIsViewer = NOTHING;

boolean hasEntered = false;

// The serial port
Serial port;

//Arduino
boolean firstContact = false;
int relayPin = 7;

//Audio
boolean isPlaying = false;
Minim minimIn;
Minim minimOut;
AudioInput in;
AudioOutput out;
AudioRecorder recorder;
AudioPlayer currentActivity;
PSaw vsaw;

//------------------------------------------SETUP---------------------------------------------
void setup() {
  //don't want to display anything, just want the 
  //computer to know what's happening and so just processes the 3D info
  size(WIDTH, HEIGHT, P3D);

  //kinect things
  kinect = new Kinect(this);
  tracker = new KinectTracker();

  //minim things
  minimIn = new Minim(this);
  minimOut = new Minim(this);
  //input and output of the recorded material
  in = minimIn.getLineIn(Minim.STEREO, 512);
  out = minimOut.getLineOut(Minim.STEREO, 2048);
  vsaw = new PSaw();
  // adds the signal to the output
  //out.addSignal(vsaw);

  // serial/arduino things
  String arduinoPort = Serial.list()[0]; 
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino

  //overall setting
  frameRate(30);
}


//--------------------------------------------DRAW LOOP---------------------------------------------------
void draw() {
  // Run the tracking analysis
  tracker.tracker();
}


//----------------------------------------------STOP---------------------------------------------------------
void stop() {
  out.close();
  currentActivity.close();
  port.stop();
  minimIn.stop();
  minimOut.stop();
  kinect.quit();
  super.stop(); // call the parent stop class
}

