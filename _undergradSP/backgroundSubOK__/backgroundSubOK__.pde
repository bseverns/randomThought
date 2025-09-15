import java.awt.Rectangle;
import org.openkinect.*;
import org.openkinect.processing.*;
//import processing.core.PApplet; 
//import processing.core.PImage;

// Dan O'Sullivan based on 
// Daniel Shiffman
// Kinect Point Cloud example
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

// Kinect Library object
Kinect kinect;

int presenceInFrontOfThreshold = 0;
int presenceInBackOfThreshold = 0;


// Size of kinect image
int w = 640;
int h = 480;
int frontThreshold = 500;
int backThreshold = 1300;

int minimumPresence = 1000;
int presenceFront = 0;
int presenceMiddle = 0;
int presenceBack = 0;

int depthXPicOffset = 30;
int depthYPicOffset = 30;

final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;

int whereIsViewer = NOTHING;

// Depth data

int[] depth;


void setup() {

  size(w, h);
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.enableRGB(true);
  // We don't need the grayscale image in this example
  // so this makes it more efficient
  kinect.processDepthImage(false);

  frameRate(2);
}

void draw() {
  println(whereIsViewer);
  fill(255);

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

  PImage myImage = kinect.getVideoImage();
  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 1;


  println(presenceInFrontOfThreshold + "/" + presenceInBackOfThreshold);


  for (int x = 0; x < w; x += skip) {
    for (int y = 0; y < h; y += skip) {
      int offset = x + y * w;
      int rawDepth = depth[offset];

      int imageOffset = x - depthXPicOffset + (y + depthYPicOffset) * w;

      if (rawDepth < frontThreshold) {
        presenceFront++;
      } 
      else if (rawDepth >= frontThreshold && rawDepth < backThreshold) {
        presenceMiddle++;
      } 
      else {
        presenceBack++;
      }
    }
  }

  int currentPos = -1;


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
      println("went from nothing to" + currentPos);
    }
    else if (whereIsViewer == RECORDING && currentPos == SOUND_PLAYBACK) {
      whereIsViewer = SOUND_PLAYBACK;
      println("went from recording to" + currentPos);
    }
    if (whereIsViewer == SOUND_PLAYBACK && currentPos == RECORDING) {
      whereIsViewer = NOTHING;
    }
    if (whereIsViewer == RECORDING && currentPos == ENTER) {
      whereIsViewer = NOTHING;
    }
    if (whereIsViewer == ENTER && currentPos == NOTHING) {
      whereIsViewer = NOTHING;
    }
  }
  else {
    // nothing changed, so nothing to do
  }
}




void fromNothingToEnter() {
}

void fromEnterToRecording() {
}


void stop() {
  kinect.quit();
  super.stop();
}

