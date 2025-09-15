class KinectTracker {
  // Depth data
  int[] depth;
  PImage videoImage;

  void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();
    // Being overly cautious here
    if (depth == null) { 
      println("WHHHOOOOOA ARRAY LENGTH MISMATCH"); 
      return;
    }
    // re-init presence measurements
    presenceFront = 0;
    presenceMiddle = 0;
    presenceBack = 0;
    videoImage = kinect.getVideoImage(); // Read a new video frame
    videoImage.loadPixels();
    for (int x = 0; x < kw; x++) {
      for (int y = 0; y < kh; y++) {
        // Mirroring the image
        int offset = kw-x-1+y*kw;
        int i = offset;
        ///////////
        int currColor = videoImage.pixels[i];// it tells me that the method loadPixels() in the type PApplet is not applicable for the arguments (int)
        int bkgdColor = averagePixels[i];       

        int currR = (currColor >> 16) & 0xFF;
        int currG = (currColor >> 8) & 0xFF;
        int currB = currColor & 0xFF;

        int bkgdR = (bkgdColor >> 16) & 0xFF;
        int bkgdG = (bkgdColor >> 8) & 0xFF;
        int bkgdB = bkgdColor & 0xFF;

        if (resetBackground) {
          averagePixels[i] = videoImage.pixels[i];
          ;
        } 

        int bgSubR = abs(currR - bkgdR);
        int bgSubG = abs(currG - bkgdG );
        int bgSubB = abs(currB - bkgdB);

        // background subtracted image
        bgSubAndThreshPixels[i] = 0xFF000000 | (bgSubR << 16) | (bgSubG << 8) | bgSubB;
        // threshold it!
        bgSubAndThreshPixels[i] = brightness(bgSubAndThreshPixels[i]) > thresh ? 1 : 0 ;// color(255) : color(0); // create a binary mask
        ////////////////
        // Grabbing the raw depth
        int rawDepth = depth[offset];
        // eliminate any "background" depth measurements
        int correctedDepth = rawDepth * bgSubAndThreshPixels[offset];

        bgSubAndThreshPixels[i] = color(map(correctedDepth, 0, 2047, 0, 255));

        // start counting pixels
        if (correctedDepth > minDepth/ 2) {//map(mouseX, 0, width, 0, 2047)) {
          if (correctedDepth < minDepth) {
            presenceFront++;
          } 
          else if (correctedDepth < maxDepth) {
            presenceMiddle++;
          } 
          else {
            presenceBack++;
          }
        } 
        else {
        }
      }
    }

    if (resetBackground) resetBackground = false;

    int [] list = {
      presenceFront, presenceMiddle, presenceBack
    };

    int currentPos = -1;
    int maxPresence = max(list);

    // HERE WE NAME OUR CURRENT POSITION BASED ON PRESENCE VALUES
    if (maxPresence < minimumPresence) {
      currentPos = NOTHING;
    } 
    else if (maxPresence == presenceFront) {
      currentPos = ENTER;
    } 
    else if (maxPresence == presenceMiddle) {
      currentPos = RECORDING;
    } 
    else if (maxPresence == presenceBack) {
      currentPos = SOUND_PLAYBACK;
    }

    if (currentPos == whereIsViewer) {
      // we haven't moved, so do nothing 
      return;
    }
    // then do checks cause something changed
    if (whereIsViewer == NOTHING) {
      if (currentPos == ENTER) {
        whereIsViewer = ENTER;
        // nothing special happens here
      } 
      else if (currentPos == RECORDING) {
        whereIsViewer = RECORDING;
        enteredRecordingArea();
      } 
      else if ( currentPos == SOUND_PLAYBACK) {
        // this is an unusual situation .. it probably means that there was a tracking error or somebody was screwing around ... what do we do?
        enteredInvalidState();
      }
    } 
    else if (whereIsViewer == ENTER) {
      if (currentPos == NOTHING) {
        whereIsViewer = NOTHING;
        exited();
        // nothing special happens here
      } 
      else if (currentPos == RECORDING) {
        whereIsViewer = RECORDING;
        enteredRecordingArea();
      } 
      else if ( currentPos == SOUND_PLAYBACK) {
        // this is an unusual situation .. it probably means that there was a tracking error or somebody was screwing around ... what do we do?
        enteredInvalidState();
      }
    } 
    else if (whereIsViewer == RECORDING) {
      if (currentPos == NOTHING) {
        whereIsViewer = NOTHING;
        exited();
        // nothing special happens here
      } 
      else if (currentPos == ENTER) {
        whereIsViewer = ENTER;
        /// ???????
      } 
      else if ( currentPos == SOUND_PLAYBACK) {
        whereIsViewer = SOUND_PLAYBACK;
        enteredSoundPlayback();
      }
    } 
    else if (whereIsViewer == SOUND_PLAYBACK) {
      if (currentPos == NOTHING) {
        whereIsViewer = NOTHING;
        exited();
        // nothing special happens here
      } 
      else if ( currentPos == ENTER) {
        // we are leaving so ignore
        // it must have skipped recording.
        whereIsViewer = ENTER;
      } 
      else if (currentPos == RECORDING) {
        whereIsViewer = RECORDING;
        // we are leaving so ignore
      }
    }
  }

  void enteredRecordingArea() {
    println("ENTERED RECORDING AREA!!");
  }

  void enteredInvalidState() {
    //println("ENTERED INVALID STATE!!");
  }

  void exited() {
    println("EXITED!!");
  }

  void enteredSoundPlayback() {
    println("ENTERED SOUND PLAYBACK AREA!~!!!");
  }

  void reset() {
    whereIsViewer = NOTHING;
  }

  void quit() {
    kinect.quit();
  }
}

