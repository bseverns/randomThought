import processing.core.*; 
import processing.xml.*; 

import org.openkinect.*; 
import org.openkinect.processing.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class pcloud_2_ extends PApplet {

// Daniel Shiffman
// Kinect Point Cloud example
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing
// Size, speed, displayType variables added by clay@shirky.com




// Kinect Library object
Kinect kinect;

// displayType set as input form keyboard: n=normal, g=green-to-red, b=bright-to-dim
char displayType = 'n';

// CHANGE THESE VARIABLES
// Size from 1-5, larger size = larger image
int size = 2;
// rotateStep: 0.001 is slooow. 0.1 is fast.
float rotateStep = 0.01f;

float a = 0;

// Size of kinect image
int w = 640;
int h = 480;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

public void setup() {
  size(800,600,P3D);
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  // We don't need the grayscale image in this example
  // so this makes it more efficient
  kinect.processDepthImage(false);

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

public void draw() {

  background(0);
  fill(255);
  textMode(SCREEN);
  text("Kinect FR: " + (int)kinect.getDepthFPS() + "\nProcessing FR: " + (int)frameRate,10,16);
  text("\nPress 'g' to activate green-to-red. Press 'b' to activate near-to-far. Press 'n' to return to Normal mode");

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 4;

  // Translate and rotate
  translate(width/2,height/2,-50);
  rotateY(a);

  for(int x=0; x<w; x+=skip) {
    for(int y=0; y<h; y+=skip) {
      int offset = x+y*w;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x,y,rawDepth);

      // Create color variables based on the Z-axis of the vector, times 60 (good for a 15' deep room)
      int farToNear = PApplet.parseInt(v.z*60);
      int nearToFar = 255 - farToNear;

      // Set the color of the pixels, based on the displayType
      if (displayType == 'n') {
          // Single value sets grayscale, 255 is white
          stroke(255);
      } else if (displayType == 'g') {
          // Three values set RGB (Blue set to 0 here)
          stroke(farToNear, nearToFar, 0);
      } else if (displayType == 'b') {
          // Four values set RGB + Alpha, for fadeout.
          stroke(nearToFar, nearToFar, nearToFar, farToNear);
      } else { // If no sensible key is pressed, default to normal
          stroke(255);
      }
      pushMatrix();
      // Scale up by 200
      float factor = size * 100;
      translate(v.x*factor,v.y*factor,factor-v.z*factor);
      // Draw a point
      point(0,0);
      popMatrix();
    }
  }

  // Rotate
  a += rotateStep;
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
public float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0f / ((double)(depthValue) * -0.0030711016f + 3.3309495161f));
  }
  return 0.0f;
}

public PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0f / 5.9421434211923247e+02f;
  final double fy_d = 1.0f / 5.9104053696870778e+02f;
  final double cx_d = 3.3930780975300314e+02f;
  final double cy_d = 2.4273913761751615e+02f;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}

public void keyReleased() {
  displayType = key;
}

public void stop() {
  kinect.quit();
  super.stop();
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "pcloud_2_" });
  }
}
