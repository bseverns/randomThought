import processing.opengl.*;
import processing.video.*;

//respiro//
float num = 0;
float bi = random(-1, 1);
float theta;

//video analysis
int numPixels;
int[] backgroundPixels;
Capture video;
int presenceSum = 0;// amount the video feed has changed

// gotta scale this stuff!
int maxPresenseSum = 255 * 3 * video.width * video.height;
int localPresenceSum = 0;  // make a local version of the presence sum

void setup() {
  size(940, 640);

  video = new Capture(this, 160, 130, 20);
  numPixels = video.width * video.height;

  background(0);
  stroke(255, 50);
  fill(255, 50);

  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  video.loadPixels();

  frameRate(25);
}


void draw() {

  translate(width/2.1, height/2.1);
  translate( cos(num/99)*width/2, sin(num/97)*height/2);
  rotate(radians(num));
  fill( 0, 5 ); 
  rect( 0, 0, width, height ); 
  fill( 255, 50 );

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

  if (presenceSum > 1000) { // this large number is an arbitrary threshold
    localPresenceSum = presenceSum;
  } else {
    presenceSum = 0;
  }

  for (int i = 0; i < 150; i+=20) {

    num = map(localPresenceSum, 0, maxPresenseSum, 0, 360);
    bi = map(localPresenceSum, 0, maxPresenseSum, 0, 1);
    background(0);

    //map x and y to presenceSum somehow
    float x = sin(radians(i+frameCount))*num;
    float y =sin(radians(num)) /frameCount+num;

    ellipse(x, y, 1, 1);
    ellipse(y, x, 1, 1);
    ellipse(x, y, 1, 5);
    line(y, x, 1, 2);
  }

  num +=bi;
}

void mouseReleased() {
  num = map(localPresenceSum, 0, maxPresenseSum, 0, 360);
  bi = map(localPresenceSum, 0, maxPresenseSum, 0, 1);
  background(0);
}

void stop() {
  video.stop();
  super.stop();
}

