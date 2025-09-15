import processing.video.*;

int numPixels;

int[] averagePixels;
int[] toScreenPixels;
color white = color(255);
color black = color(0);

boolean firstTime = true;
boolean showBackgroundSubtraction = false;
boolean showThresholded = false;

PFont font;

Capture video;

void setup() {
  // Change size to 320 x 240 if too slow at 640 x 480
  size(640, 480); 

  font = createFont("Courier", 18);
  textFont(font);

  video = new Capture(this, width, height, 24);
  numPixels = video.width * video.height;
  // Create array to store the background image

  averagePixels = new int[numPixels];
  toScreenPixels = new int[numPixels];

  // Make the pixels[] array available for direct manipulation
  loadPixels();
}

void keyPressed() {
  if(key == 'b') {
    showBackgroundSubtraction = !showBackgroundSubtraction;
  }
  else if(key == 't') {
    showThresholded = !showThresholded;
  }
}

void draw() {
  // pick an alpha (a) value for the moving average
  float a = map(mouseX, 0, width, 0, 1);
  float thresh = map(mouseY, 0, height, 0, 255);

  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available

    for(int i = 0; i < numPixels; i++) {       
      int currColor = video.pixels[i];       
      int bkgdColor = averagePixels[i];       
      
      int currR = (currColor >> 16) & 0xFF;
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;

      int bkgdR = (bkgdColor >> 16) & 0xFF;
      int bkgdG = (bkgdColor >> 8)  & 0xFF;
      int bkgdB = bkgdColor & 0xFF;

      int redAvg = int(a * currR + (1 - a) * bkgdR);
      int greenAvg = int(a * currG + (1 - a) * bkgdG);
      int blueAvg = int(a * currB + (1 - a) * bkgdB);

      // equiv to color(redAvg, greenAvg, blueAvg); , but perhaps slightly faster
      averagePixels[i] = 0xFF000000 | (redAvg << 16) | (greenAvg << 8) | blueAvg; // equiv to color(redAvg, greenAvg, blueAvg);

      if(showBackgroundSubtraction) {
        int bgSubR = abs(bkgdR - currR);
        int bgSubG = abs(bkgdG - currG);
        int bgSubB = abs(bkgdB - currB);

        toScreenPixels[i] = 0xFF000000 | (bgSubR << 16) | (bgSubG << 8) | bgSubB;       }        else {         toScreenPixels[i] = averagePixels[i];       }       if(showThresholded) {         toScreenPixels[i] = brightness(toScreenPixels[i]) > thresh ? white : black;
      }
    }

    arraycopy(toScreenPixels, pixels);

    updatePixels();

    fill(255);
    text("avg = alpha * thisFrame + (1 - alpha) * lastFrame\n"
      +  "(X-Axis) Alpha: " + a + "\n"
      + "(Y-Axis) Binary Threshold: " + thresh + "\n"
      + "(b) Show Background Avg Background: " + showBackgroundSubtraction + "\n"
      + "(t) Show Thresholded: " + showThresholded, 10,20);
  }
}
