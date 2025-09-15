//-------------------------------------------KINECT SETUP------------------------------------
class KinectTracker {

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

  KinectTracker() {
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
  }
  float rawDepthToMeters(int depthValue) {
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
    // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
    int skip = 4;

    for (int x = 0; x < kw; x += skip) {
      for (int y = 0; y < kh; y += skip) {
        int offset = x + y * kw;
        int rawDepth = depth[offset];

        int imageOffset = x - depthXPicOffset + (y + depthYPicOffset) * kw;

        if (rawDepth < frontThreshold) {
          presenceFront++;
        } 
        else if(rawDepth >= frontThreshold && rawDepth < backThreshold) {
          presenceMiddle++;
        } 
        else {
          presenceBack++;
        }

        int currentPos = -1;

        // which number is biggest?
        int maxPresence = max(max(presenceFront, presenceMiddle), presenceBack);

        // do we have a minimal amount of presence to proceed?
        if(maxPresence > minimumPresence) { // 1000 is the minimum
          if(maxPresence == presenceFront) {
            currentPos = ENTER;
          } 
          else if(maxPresence == presenceMiddle) {
            currentPos = RECORDING;
          } 
          else if(maxPresence == presenceBack) {
            currentPos = SOUND_PLAYBACK;
          }
        } 
        else {
          currentPos = NOTHING;
        }

        if(currentPos != whereIsViewer) {
          // then do checks cause something changed
          if (whereIsViewer == NOTHING && currentPos == ENTER) {
            whereIsViewer = ENTER;
          }
          else {
            println("went from nothing to" + currentPos);
          }
          if (whereIsViewer == ENTER && currentPos == RECORDING) {
            whereIsViewer = RECORDING;
            fromEnterToRecording();
          }
          if (whereIsViewer == RECORDING && currentPos == SOUND_PLAYBACK) {
            whereIsViewer = SOUND_PLAYBACK;
            fromRecordingtoSoundPlayback();
          }
          if (whereIsViewer == SOUND_PLAYBACK && currentPos == RECORDING) {
            reset();
            whereIsViewer = NOTHING;
          }
          if (whereIsViewer == RECORDING && currentPos == ENTER) {
            reset();
            whereIsViewer = NOTHING;
          }
          if (whereIsViewer == ENTER && currentPos == NOTHING) {
            reset();
            whereIsViewer = NOTHING;
          }
        }
        else {
          // nothing changed, so nothing to do
        }
      }
    }
  }


  //-------------------------------------STATE CHANGE--------------------------------------------------
  // entering the space

    //starting to record
  void fromEnterToRecording() {
    hasEntered = true;
    //runNonRealTime();
  }

  //done recording, now playing    
  void fromRecordingtoSoundPlayback() {
    turnRelayOff(); //lights off
    isPlaying = true; //yes, in fact I am playing that recording we just made.....
  }

  //person leaves installation
  void reset() { 
    hasEntered = false;
    isPlaying = false;
    isRecording = false;
    currentPos = -1;
    delay (300); //wait
    turnRelayOn(); //lights back on
  }
}

