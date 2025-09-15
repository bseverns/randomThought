import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 
import ddf.minim.signals.*; 
import org.openkinect.*; 
import org.openkinect.processing.*; 
import processing.serial.*; 
import cc.arduino.*; 

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

public class sP_1 extends PApplet {

//------------------------------------------GLOBAL THINGS--------------------------------------
//libraries







boolean isPlaying = false;

//global variables for everything to sample from
int presenceSum = 0;
int rawDepthToMeters = 0;

// Gathers the look up table
float[] depthLookUp = new float[2048];

// The serial port
Serial port;

//Arduino
Arduino arduino;
int relayPin = 3;

//Kinect
KinectTracker tracker;
Kinect kinect;

//Audio
Minim minim;
AudioInput in;
AudioOutput out;
AudioRecorder recorder;
PSaw vsaw;


//------------------------------------------SETUP---------------------------------------------
public void setup() {
  //don't want to display anything, just want the computer to know what's happening and so just processes the 3D info
  size(P3D);
  //kinect things
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  kinect.start();
  kinect.enableRGB(true);
  kinect.enableDepth(true);
  kinect.processDepthImage(false);
  // Lookup table for all possible depth values (0 - 2047) to rawDepthToMeters
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }


  //minim things
  minim = new Minim(this);
  //input and output of the recorded material 
  out = minim.getLineOut(Minim.STEREO, 2048);
  in = minim.getLineIn(Minim.STEREO, 512);
  recorder = minim.createRecorder(in, "currentActivity.wav", true);
  //low pass filter for the recording
  lpfilter = new LowPassFS(300, currentActivity.sampleRate());
  //files that the sounds will be recorded to and played back from
  //sPOne = minim.loadfile("sp1.wav", 2048);
  //sPTwo = minim.loadfile("sp2.wav", 2048);
  vsaw = new PSaw();
  // adds the signal to the output
  out.addSignal(vsaw);


  // serial/arduino things
  String arduinoPort = Serial.list()[0]; 
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino
  arduino.pinMode(relayPin, OUTPUT);


  //overall setting
  frameRate(15);
}


//--------------------------------------------DRAW LOOP---------------------------------------------------
public void draw() {
  // Run the tracking analysis
  tracker.track();
}


//----------------------------------------------STOP---------------------------------------------------------
public void stop() {
  out.close();
  currentActivity.close();
  serial.stop();
  arduino.stop();
  minim.stop();
  kinect.quit();
  tracker.quit();
  super.stop();
}

//-----------------------------ARDUINO CONTROL-------------------------------------
class Arduino {
  
{
  //check depth
  if (isPlaying == true) {
    port.write("off");
  } 

  //set the arduino to wait until the light is off, and then keeps it off for 30 seconds, then turns it back on again
  if (isPlaying == false) {    
    port.write("on");
  }
}

//-------------------------------------------KINECT SETUP------------------------------------
class KinectTracker {

  // Size of kinect image
  int kw = 640;
  int kh = 480;
  int frontThreshold = 500;
  int backThreshold = 800;

  int depthXPicOffset = 30;
  int depthYPicOffset = 30;

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;

  KinectTracker() {
    kinect.start();
    kinect.enableDepth(true);

    loc = new PVector(0,0);
    lerpedLoc = new PVector(0,0);
  }

  //---------------------------------------KINECT TRACKER-----------------------------------------
  public void tracker() {

    PImage myImage = kinect.getVideoImage();
    // Get the raw depth as array of integers
    int[] depth = kinect.getRawDepth();
    // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
    int skip = 1;

    for (int x = 0; x < w; x += skip) {
      for (int y = 0; y < h; y += skip) {
        int offset = x + y * w;
        int rawDepth = depth[offset];
        if (rawDepth > frontThreshold && rawDepth < backThreshold) {
          int imageOffset = x - depthXPicOffset + (y + depthYPicOffset) * w;
          if (imageOffset < myImage.pixels.length) (pixels[offset] )  = myImage.pixels[imageOffset] ;
        }
      }
    }
    updatePixels();
  }
}

//-------------------------------------------MINIM--------------------------------------
class PSaw implements AudioSignal
{


  //------------------------------------------SOUND PROCESSOR-----------------------------
  public void generate(float[] samp)
  {
    // gotta scale this stuff!
    int maxPresenceSum = 255 * 3 * 640 *480;
    int localPresenceSum = 0;  // make a local version of the presence sum

    if(presenceSum > 1000) { // this large number is an arbitrary threshold
      localPresenceSum = presenceSum;
    } 
    else {
      presenceSum = 0;
    }

    float range = map(localPresenceSum, 0, maxPresenseSum, 0, 1);
    float peaks = map(localPresenceSum, 0, maxPresenseSum, 1, 20);

    float inter = PApplet.parseFloat(samp.length) / peaks;
    for ( int i = 0; i < samp.length; i += inter )
    {
      for ( int j = 0; j < inter && (i+j) < samp.length; j++ )
      {
        samp[i + j] = map(j, 0, inter, -range, range);
      }
    }
  }

  //-----------------------------------------SOUND GENERATOR--------------------------------
  // this is a stricly mono signal
  public void play(float[] left, float[] right)
  {
    if (rawDepthToMeters > 3) {
      currentActivity.addEffect(lpfilter);
      currentActivity = minim.loadFile("currentActivity.wav", 2048);
      currentActivity.play();
      isPlaying = true;
    } 
    else {
      isPlaying = false;
    }
  }

    //-------------------------------------------RECORDING---------------------------------------
    public void record()
    {
      if (localPresenceSum > 5)
      {
        recorder.beginRecord();
        if ( recorder.isRecording()||localPresenceSum < 5)
        {
          recorder.save();
          recorder.endRecord();
        }
      }
    }
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "sP_1" });
  }
}
