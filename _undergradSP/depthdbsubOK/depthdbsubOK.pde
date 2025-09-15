import org.openkinect.*;
import org.openkinect.processing.*;

Kinect kinect;
int kWidth  = 640;
int kHeight = 480;

PImage depthImg;
int minDepth =  800;
int maxDepth = 960;

void setup() {
  size(kWidth*2, kHeight);

  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);


  depthImg = new PImage(kWidth, kHeight);
}

void draw() {
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
}


void stop() {
  kinect.quit();
  super.stop();
}
