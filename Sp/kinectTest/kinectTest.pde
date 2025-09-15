import org.openkinect.*;
import org.openkinect.processing.*;

final int WIDTH = 640;
final int HEIGHT = 480;

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

// We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
int skip = 4;


// Size of kinect image
int kw = 640;
int kh = 480;
int frontThreshold = 300;
int backThreshold = 1000;

int minimumPresence = 1000;
int presenceFront = 0;
int presenceMiddle = 0;
int presenceBack = 0;

int depthXPicOffset = 20;
int depthYPicOffset = 20;

// Raw location
PVector loc;

// Interpolated location
PVector lerpedLoc;

// Depth data
int[] depth;

void setup() {
  //don't want to display anything, just want the 
  //computer to know what's happening and so just processes the 3D info
  size(WIDTH, HEIGHT, P3D);

  //kinect things
  kinect = new Kinect(this);


  kinect.start();
  kinect.enableDepth(true);
  kinect.enableRGB(true);
  kinect.processDepthImage(false);
  // Lookup table for all possible depth values (0 - 2047) to rawDepthToMeters


  frameRate(2);
}

void draw() {
  println(whereIsViewer);
  if (whereIsViewer == NOTHING) {
    background(0);
  }
  else if (whereIsViewer == ENTER) {
    background(255, 0, 0);
  }
  else if (whereIsViewer == RECORDING) {
    background(255, 255, 0);
  }
  else if (whereIsViewer == SOUND_PLAYBACK) {
    background(255);
  }
  // Run the tracking analysis
  tracker();  

  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }

  loc = new PVector(0, 0);
  lerpedLoc = new PVector(0, 0);

  rawDepthToMeters(depthValue); 
  if (depthValue < 1010) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}




//---------------------------------------KINECT TRACKER-----------------------------------------
void tracker() {

  //println(depth);

  fill(255);
  PImage myImage = kinect.getVideoImage();
  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();


  for (int x = 0; x < kw; x += skip) {
    for (int y = 0; y < kh; y += skip) {
      int offset = x + y * kw;
      int rawDepth = depth[offset];

      if (rawDepth < frontThreshold) {
        presenceFront++;
      } 
      else if (rawDepth >= frontThreshold && rawDepth < backThreshold) {
        presenceMiddle++;
      } 
      else {
        presenceBack++;
      }

      int currentPos = -1;

      // which number is biggest?
      int maxPresence = max(max(presenceFront, presenceMiddle), presenceBack);

      // do we have a minimal amount of presence to proceed?
      if (maxPresence > minimumPresence) { // 1000 is the minimum
        if (maxPresence == presenceFront) {
          currentPos = ENTER;
        } 
        else if (maxPresence == presenceMiddle) {
          currentPos = RECORDING;
        } 
        else if (maxPresence == presenceBack) {
          currentPos = SOUND_PLAYBACK;
        }
      } 
      else {
        currentPos = NOTHING;
      }

      if (currentPos != whereIsViewer) {
        // then do checks cause something changed
        if (whereIsViewer == NOTHING && currentPos == ENTER) {
          whereIsViewer = ENTER;
        }
        else {
          println("went from nothing to" + currentPos);
        }
        if (whereIsViewer == ENTER && currentPos == RECORDING) {
          whereIsViewer = RECORDING;
        }
        if (whereIsViewer == RECORDING && currentPos == SOUND_PLAYBACK) {
          whereIsViewer = SOUND_PLAYBACK;
        }
        if (whereIsViewer == SOUND_PLAYBACK && currentPos == RECORDING) {
        }
        if (whereIsViewer == RECORDING && currentPos == ENTER) {
        }
        if (whereIsViewer == ENTER && currentPos == NOTHING) {
        }
      }
      else {
        // nothing changed, so nothing to do
      }
    }
  }
}

