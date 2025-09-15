//------------------------------------------GLOBAL THINGS--------------------------------------
//libraries
import beads.*;
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

final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;
int whereIsViewer = NOTHING;
boolean hasEntered = false;


// The serial port
Serial port;

//Arduino
boolean firstContact = false;
int relayPin = 7;

//Audio
String currentRecorderFilename = "currentActivity.wav";
AudioContext acRecord;
AudioContext acPlay;
Glide carrierFreq, modFreqRatio;
Sample mySample;
String[] sound;
boolean isRecording = false;
boolean isPlaying = false;
RecordToSample cp;


//------------------------------------------SETUP---------------------------------------------
void setup() {
  //don't want to display anything, just want the 
  //computer to know what's happening and so just processes the 3D info
  size(WIDTH, HEIGHT, P3D);

  //kinect things
  kinect = new Kinect(this);
  tracker = new KinectTracker();

  //beads things
  acRecord = new AudioContext();
  acPlay = new AudioContext ();
  carrierFreq = new Glide(acRecord, 500);
  modFreqRatio = new Glide(acRecord, 1);
  sound = loadStrings("mySample.wav");

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
  acRecord.stop();// stop recording
  acPlay.stop();// stop playing (if anything)
  super.stop(); // call the parent stop class
}

