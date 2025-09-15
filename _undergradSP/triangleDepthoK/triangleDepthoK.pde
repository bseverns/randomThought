import org.openkinect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;


// start the kinect at 0 degrees
float deg = 0;

// Size of kinect image
int w;
int h;


// Gathers the look up table
float[] depthLookUp = new float[2048];

void setup() {
  size(screen.width,screen.height,P3D);
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  w = 640;
  h = 480;
  kinect.processDepthImage(false);

  // Lookup table for all possible depth values (0 - 2047) to rawDepthToMeters
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
  
}

void draw() {

  background(255);
  fill(0 );
  textMode(SCREEN);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  println(depth.length);
  // skip every nth pixel
  int skip = 3;


  for(int x=0; x<w; x+=skip) {
    for(int y=0; y<h; y+=skip) {
      int offset = x+y*w;

      // Convert kinect data to the xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x,y,rawDepth);

      stroke(255);
      pushMatrix();
      scale(2.5);
      float factor = 1000;
      translate((v.x*factor) + 200,v.y*factor,factor-v.z*factor);
      // Drawss the 'reflection'
      stroke(#FF0303);
      triangle(0,0, 40, 25, 20, 20);
      popMatrix();
      pushMatrix();
      translate(200, 0);
      popMatrix();
    }
  }

  // Rotate
 // a += 0.015f;
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html  -- the depthValue was what I adjusted based on my environment
float rawDepthToMeters(int depthValue) {
  if (depthValue < 1010) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}

void stop() {
  kinect.quit();
  super.stop();
}
