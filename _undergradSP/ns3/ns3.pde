//libraries
import processing.opengl.*;
import processing.video.*;
import ddf.minim.*;
import ddf.minim.signals.*;

//video analysis
int numPixels;
int[] backgroundPixels;
Capture video;
int presenceSum = 0;// amount the video feed has changed

//sound genereation
Minim minim;
AudioOutput out;
PSaw vsaw;

void setup() {
  // Change size to 320 x 240 if too slow at 640 x 480
  size(1280, 960); 

  video = new Capture(this, 160, 130, 20);
  numPixels = video.width * video.height;
  minim = new Minim(this);

  out = minim.getLineOut(Minim.STEREO, 2048);
  vsaw = new PSaw();
  // adds the signal to the output
  out.addSignal(vsaw);


  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  video.loadPixels();

  frameRate(15);
}

void draw() {

  if (video.available()) {
    arraycopy(video.pixels, backgroundPixels);
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    image(video, 0, 0, width, height);//display the video for proper set up

    presenceSum = 0;

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixelÕs color
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract the red, green, and blue components of the background pixelÕs color
      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8) & 0xFF;
      int bkgdB = bkgdColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - bkgdR);
      int diffG = abs(currG - bkgdG);
      int diffB = abs(currB - bkgdB);

      presenceSum += (diffR + diffG + diffB);
    }
  }
}

void stop() {
  out.close();
  minim.stop();
  video.stop();
  super.stop();
}

