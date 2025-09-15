//import processing.serial.*;
//import cc.arduino.*;
import org.openkinect.*;
import org.openkinect.processing.*;

import processing.video.*;

import processing.opengl.*;
import s373.flob.*;

// Kinect Library object
Kinect kinect;
//Arduino arduino;

Capture video;    // processing video capture
Flob flob;        // flob tracker instance
ArrayList blobs;  // an ArrayList to hold the gathered blobs

int numPixels;
int[] backgroundPixels;

int tresh = 14;   // adjust treshold value here or keys t/T
int fade = 10;
int om = 1;
int videores=128;//64//256
String info="";
PFont font;
float fps = 5;
int videotex = 3;


void setup() {
  size(640,480,OPENGL);
  //kinect = new Kinect(this);
  video = new Capture(this, width, height, (int)fps);
  numPixels = video.width * video.height;
  //kinect.start();
  //kinect.enableDepth(true);
  //kinect.processDepthImage(true); //grayscale depth
  loadPixels();
  try { 
    quicktime.QTSession.open();
  } 
  catch (quicktime.QTException qte) { 
    qte.printStackTrace();
  }
  frameRate(fps);

  rectMode(CENTER);
  /*
  // Lookup table for all possible depth values (0 - 2047)
   for (int i = 0; i < depthLookUp.length; i++) {
   depthLookUp[i] = rawDepthToMeters(i);
   }*/

  // init blob tracker
  flob = new Flob(video, width,height);
  flob = new Flob(video, this); 
  flob = new Flob(videores, videores, width, height);

  flob.setTresh(tresh); //set the new threshold to the binarize engine
  flob.setThresh(tresh); //typo
  flob.setSrcImage(videotex);
  flob.setImage(videotex); //  pimage i = flob.get(Src)Image();

  flob.setBackground(video); // zero background to contents of video
  flob.setBlur(0); //new : fastblur filter inside binarize
  flob.setMirror(true,false);
  flob.setOm(0); //flob.setOm(flob.STATIC_DIFFERENCE);
  flob.setOm(1); //flob.setOm(flob.CONTINUOUS_DIFFERENCE);
  flob.setFade(fade); //only in continuous difference

    /// or now just concatenate messages
  flob.setThresh(tresh).setSrcImage(videotex).setBackground(video)
    .setBlur(0).setOm(1).setFade(fade).setMirror(true,false);

  font = createFont("monaco",9);
  textFont(font);
  blobs = new ArrayList();
}



void draw() {


  if (video.available()) {
    video.read();
    blobs = flob.calc(flob.binarize(video));

    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen

    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    int presenceSum = 0;
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
      // Add these differences to the running tally
      presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      pixels[i] = color(diffR, diffG, diffB);
      // The following line does the same thing much faster, but is more technical
      //pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    updatePixels(); // Notify that the pixels[] array has changed
    println(presenceSum); // Print out the total amount of movement
  }
  image(flob.getSrcImage(), 0, 0, width, height);

  rectMode(CENTER);

  //get and use the data
  int numblobs = blobs.size();//flob.getNumBlobs();  

  for(int i = 0; i < numblobs; i++) {

    ABlob ab = (ABlob)flob.getABlob(i); 
    //     trackedBlob tb = (trackedBlob)flob.getTrackedBlob(i); 
    //now access all blobs fields.. float tb.cx, tb.cy, tb.dimx, tb.dimy...

    // test blob coords here    
    //b1.test(ab.cx,ab.cy, ab.dimx, ab.dimy);

    //box
    fill(0,0,255,100);
    rect(ab.cx,ab.cy,ab.dimx,ab.dimy);
    //centroid
    fill(0,255,0,200);
    rect(ab.cx,ab.cy, 5, 5);
    info = ""+ab.id+" "+ab.cx+" "+ab.cy;
    text(info,ab.cx,ab.cy+20);
  }

  //report presence graphically
  fill(255,152,255);
  rectMode(CORNER);
  rect(5,5,flob.getPresencef()*width,10);
  String stats = ""+frameRate+"\nflob.numblobs: "+numblobs+"\nflob.thresh:"+tresh+
    " <t/T>"+"\nflob.fade:"+fade+"   <f/F>"+"\nflob.om:"+flob.getOm()+
    "\nflob.image:"+videotex+"\nflob.presence:"+flob.getPresencef();
  fill(0,255,0);
  text(stats,5,25);
}


void keyPressed() {
  video.loadPixels();
  arraycopy(video.pixels, backgroundPixels);
}

