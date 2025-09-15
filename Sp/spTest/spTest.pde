import org.openkinect.*;
import org.openkinect.processing.*;

int presenceInFrontOfThreshold = 0;
int presenceInBackOfThreshold = 0;

boolean turnRelayOff = false;
boolean turnRelayOn = false;
boolean isRecording = false;
boolean isPlaying = false;
boolean hasEntered = false;

// Size of kinect image
int kw = 640;
int kh = 480;
int frontThreshold = 300;
int backThreshold = 1000;

final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;
int whereIsViewer = NOTHING;

int depthXPicOffset = 30;
int depthYPicOffset = 30;

// Raw location
PVector loc;
// Interpolated location
PVector lerpedLoc;
// Depth data
int[] depth;

float rawDepthToMeters(int depthValue) {
  if (depthValue < 1010) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

//Kinect
Kinect kinect;
//global variables for everything to sample from
int presenceSum = 0;
int rawDepthToMeters = 0;
// Gathers the look up table
float[] depthLookUp = new float[2048];


void setup() {
  //don't want to display anything, just want the computer to know what's happening and so just processes the 3D info
  size(640,480, P3D);
  background(102);
  //kinect things
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.enableRGB(true);
  kinect.processDepthImage(false);
  // Lookup table for all possible depth values (0 - 2047) to rawDepthToMeters
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }

  loc = new PVector(0,0);
  lerpedLoc = new PVector(0,0);
  
  frameRate(2);
}


void draw() {
  println(depth);  
  println(rawDepthToMeters);
  println(whereIsViewer);
  println(frameCount);
  PImage myImage = kinect.getVideoImage();
  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 4;

  for (int x = 0; x < kw; x += skip) {
    for (int y = 0; y < kh; y += skip) {
      int offset = x + y * kw;
      int rawDepth = depth[offset];

      int imageOffset = x - depthXPicOffset + (y + depthYPicOffset) * kw;

      if (rawDepth < frontThreshold ) {
        presenceInFrontOfThreshold = 0;
      } 
      else if (rawDepth > frontThreshold) {
        presenceInFrontOfThreshold = 1;
      } 

      if (rawDepth < backThreshold) {
        presenceInBackOfThreshold = 0;
      }
      else if (rawDepth > backThreshold) {
        presenceInBackOfThreshold = 1;
      }
    }
  }
}

//--------------------------------STATE CHANGE--------------------------------------------------
// entering the space
void fromNothingToEnter() {
  println("NOTHING");
  if(whereIsViewer == NOTHING) {
    if (presenceInFrontOfThreshold < 1) {
      delay(50);
    }
    else if (presenceInFrontOfThreshold == 0) {
      fromNothingToEnter();
    }
  }
}

//starting to record
void fromEnterToRecording() {
  println("RECORDING");
  whereIsViewer = RECORDING;
  isRecording = true; //start to record
  if (presenceInBackOfThreshold > 0) {
    fromRecordingtoSoundPlayback();
  }
}

//done recording, now playing    
void fromRecordingtoSoundPlayback() {
  println("PLAYING");
  whereIsViewer = SOUND_PLAYBACK;
  turnRelayOff = true; //lights off
  if (turnRelayOff == true) {
    println("LIGHTS OFF");
  }
  isRecording = false; //stop recording
  isPlaying = true; //yes, in fact I am playing that recording we just made.....
}

//person leaves installation
void reset() {
  if (whereIsViewer == SOUND_PLAYBACK) { //if they've already gotten to here
    if (presenceInBackOfThreshold == 0) {
      println("LEAVING");
      delay (300); //wait
      whereIsViewer = NOTHING; //reset 
      turnRelayOn = true; //lights back on
    }
    else if (presenceInBackOfThreshold > 0) { //double checks just in case someone moves back and forth on that line
      delay (50);
    }
  }
  if (whereIsViewer == RECORDING) {
    if (presenceInFrontOfThreshold < 1) {
      whereIsViewer = NOTHING;
      isRecording = false;
      //File.delete(currentActivity.wav);
      println("EARLY DEPARTURE");
    }
  }
}

void stop(){
  kinect.quit();
  super.stop();
}

