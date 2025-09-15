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
    // re-init presence measurements just to make sure something else isn't changing them
    presenceFront = 0;
    presenceMiddle = 0;
    presenceBack = 0;
    videoImage = kinect.getVideoImage(); // Read a new video frame
    videoImage.loadPixels();//display the frame
    for (int x = 0; x < kw; x++) {
      for (int y = 0; y < kh; y++) {
        // Mirroring the image
        int offset = kw-x-1+y*kw;
        int i = offset;
        //
        int currColor = videoImage.pixels[i];
        int bkgdColor = averagePixels[i];//turning the pixel average into an array that I can reference

        //setting what things look like now to be referenced next frame
        int currR = (currColor >> 16) & 0xFF;
        int currG = (currColor >> 8) & 0xFF;
        int currB = currColor & 0xFF;

        //setting the currColors last frame to the bkgdColor this frame
        int bkgdR = (bkgdColor >> 16) & 0xFF;
        int bkgdG = (bkgdColor >> 8) & 0xFF;
        int bkgdB = bkgdColor & 0xFF;

        //resets the background to not see anything
        if (resetBackground) {
          averagePixels[i] = videoImage.pixels[i];
          ;
        } 

        //subtracted background values
        int bgSubR = abs(currR - bkgdR);
        int bgSubG = abs(currG - bkgdG );
        int bgSubB = abs(currB - bkgdB);

        // background subtracted image
        bgSubAndThreshPixels[i] = 0xFF000000 | (bgSubR << 16) | (bgSubG << 8) | bgSubB;
        // threshold it!
        bgSubAndThreshPixels[i] = brightness(bgSubAndThreshPixels[i]) > thresh ? 1 : 0 ;// color(255) : color(0); // create a binary mask


        // Grabbing the raw depth
        int rawDepth = depth[offset];

        //************
        // eliminate any "background" depth measurements
        int correctedDepth = rawDepth * bgSubAndThreshPixels[offset];

        bgSubAndThreshPixels[i] = color(map(correctedDepth, 0, 2047, 0, 255));

        // start counting pixels
        if (correctedDepth > minDepth/ 2) {//map(mouseX, 0, width, 0, 2047)) {
          if (correctedDepth < minDepth) {
            presenceFront++;
          } else if (correctedDepth < maxDepth) {
            presenceMiddle++;
          } else {
            presenceBack++;
          }
        }
      }
    }

    if (resetBackground) {
      resetBackground = false;// turn the background reset back off
    }

    int [] list = {
      presenceFront, presenceMiddle, presenceBack
    };

    int currentPos = -1;
    int maxPresence = max(list);

    // HERE WE NAME OUR CURRENT POSITION BASED ON PRESENCE VALUES
    // LOTS OF LOGIC COMING UP!!!!!
    if (maxPresence < minimumPresence) {
      currentPos = NOTHING;
    } else if (maxPresence == presenceFront) {
      currentPos = NOTHING;
    } else if (maxPresence == presenceMiddle) {
      currentPos = SHOOT;
    } else if (maxPresence == presenceBack) {
      currentPos = BACK;
    }

    if (currentPos == whereIsVP) {
      // we haven't moved, so do nothing 
      return;
    }
    // then do checks cause something changed
    if (whereIsVP == NOTHING) {
      if (currentPos == SHOOT) {
        whereIsVP = SHOOT;
        // nothing special happens here
      } else if (currentPos == BACK) {
        whereIsVP = BACK;
      }
    } else if (whereIsVP == SHOOT) {
      if (currentPos == NOTHING) {
        whereIsVP = NOTHING;
        exited(); //reset bg 
      }
    } else if (whereIsVP == BACK) {
      if (currentPos == NOTHING) {
        whereIsVP = NOTHING;
      } else if (currentPos == SHOOT) {
        whereIsVP = SHOOT;
        lightsOn();
      }
    }
  }

  void exited() {
    println("EXITED!!");
    lights = false;
    currentPos = -1;
    whereIsVP = NOTHING;
    lightsOff();
  }

  void lightsOn() {//starts all of the things that we need to happen when the viewer enters zone 3
    port.write(255);//lights on
    println("ON!!!!");
  }

  void lightsOff() {//does all of the "reseting" things that happen when the viewer leaves
    port.write(0);//lights off
    println("LIGHTS OFF!!!!!!!");
    resetBackground = true;//reset the background again, now that things have change and have then changed back
  }


  void quit() {
    kinect.quit();
  }
}
