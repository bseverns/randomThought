// Elie Zananiri
// Depth thresholding example
// http://www.silentlycrashing.net

import org.openkinect.*;
import org.openkinect.processing.*;

Kinect kinect;
int kWidth  = 640;
int kHeight = 480;

PImage depthImg;
int minDepth =  60;
int maxDepth = 860;

int minimumPresence = 1000;
int presenceFront = 0;
int presenceMiddle = 0;
int presenceBack = 0;

final int NOTHING = 0;
final int ENTER   = 1;
final int RECORDING = 2;
final int SOUND_PLAYBACK  = 3;

int whereIsViewer = NOTHING;

int by = 0;

void setup() {
  size(kWidth*2, kHeight);

  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);

  depthImg = new PImage(kWidth, kHeight);
}

void draw() {
  by = frameCount;
  // draw the raw image
  image(kinect.getDepthImage(), 0, 0);

  // threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < kWidth*kHeight; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = 0xFFFFFFFF;
    } else {
      depthImg.pixels[i] = 0;
    }
  }

  // draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, kWidth, 0);

  fill(0);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  
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
  
  if (rawDepth[by] < minDepth) {
        presenceFront++;
      } 
      else if (rawDepth[by] >= minDepth && rawDepth[by] < maxDepth) {
        presenceMiddle++;
      } 
      else {
        presenceBack++;
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

void keyPressed() {{
 if (key == 'a') {
    minDepth = constrain(minDepth+10, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-10, 0, maxDepth);
  }
  
  else if (key == 'z') {
    maxDepth = constrain(maxDepth+10, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-10, minDepth, 2047);
  }
}
}

void stop() {
  kinect.quit();
  super.stop();
}
