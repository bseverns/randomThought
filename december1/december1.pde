//B.Severns
//December 1, 2014
//Program analyzes webcam feed, draws brightestX&Y point with converging
//fading lines. Lines change color based on input volume from audio source (mic)

//sound library & analysis reference
import ddf.minim.*;
import ddf.minim.analysis.*;

//video control
import processing.video.*;
Capture video;

//linepoint variables
int strokeFuzz=9; //sets stroke thickness. Higher number implies thicker stroke.
int strokeLucidity=8; // sets stroke translucency. Lower number implies more translucent stroke.
int lineDensity=75; //determines the space between each line horizontally
int eraserStrength=6; //determines the extent the drawing is erased using the space bar

//audio stuff
Minim minim;
AudioInput input;

// A boolean to track whether we are recording are not
boolean recording = false;

//set initial sound level
float in = 0;
//stroke color designator
float s = 0;
//volume control
float vol = 200;

//timer things
int actualSecs; //actual seconds elapsed since start
int actualMins; //actual minutes elapsed since start
int startSec = 0; //used to reset seconds shown on screen to 0
int startMin = 0; //used to reset minutes shown on screen to 0
int cSecs; //seconds will be 0-60
int cMins = 0; //minutes will be reset at 5
int restartSecs = 0; //number of seconds elapsed at last click or 60 sec interval
int restartMins = 0; //number of seconds ellapsed at most recent minute or click


void setup() {
  size(640, 480);

  //audio
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 512);

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();

  background(0);
  frameRate(20); //make it fast enough for smooth responsiveness to the mouse

  smooth();
  strokeJoin(BEVEL);
}

void draw() {

  int brightestX = 0; // X-coordinate of the brightest video pixel
  int brightestY = 0; // Y-coordinate of the brightest video pixel
  float brightestValue = 0; // Brightness of the brightest video pixel

  //map input level
  in = input.left.level ()*vol;
  //println(in);

  //start timer
  actualSecs = millis()/1000; //convert milliseconds to seconds, store values.
  actualMins = millis()/1000 / 60; //convert milliseconds to minutes, store values.
  cSecs = actualSecs - restartSecs; //seconds to be tracked in the artificial stopwatch
  cMins = actualMins - restartMins; //minutes to be tracked in the artificial stopwatch

  if (in > 0) { //if the volume is over a certain level, different color stroke, etc.- add control to threshold w/ keypressed?
    erase(); //erase over time- variable shift keypressed?
  }


  //Video brightness tracking stuff
  if (video.available()) {

    video.read();

    //image(video, 0, 0, width, height); // Draw the webcam video onto the screen

    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {

      for (int x = 0; x < video.width; x++) {

        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];

        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);

        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }

        index++;
      }
    }
  }

  if (in > 12) {
    //draw the point    
    for (int i=-100; i<=width+100; i+=lineDensity) {
      for (int p =-100; p<=height+100; p+=lineDensity) {
        //      noFill();
        if (in > 25) { //if the volume is over a certain level, different color stroke, etc.- add control to threshold w/ keypressed?
          strokeWeight(random(2, strokeFuzz)); 
          stroke((in*4), 0, 255, random(strokeLucidity));
        } else { //stroke variables
          strokeWeight(random(strokeFuzz)); 
          stroke(245, random(0, 245), 0, random(strokeLucidity)*0.75);
        }

        //draw that bright point!
        line(i, p, brightestX, brightestY); 
        //line(brightestX, brightestY, i, (p*random(2, -2)));
        line(i, p, (brightestX*random(1.85, 0.85)), (brightestY*random(1.85, 0.85)));
      }
    }
  }

  if (in > 40) {
    erase();
  }

  updatePixels(); 

  if (recording) {
    saveFrame("output/frames####.tga");
    println("F");
  }
}

void erase() {
  fill(0, eraserStrength); 
  rect(0, 0, width, height); 
  s = 0; 
  //println("erase 1");

  if (in < 200) {
    s = 1;     
    if (s == 1) {
      fill(random(255), random(255), random(255), eraserStrength); 
      rect(0, 0, width, height);
      //println("erase2");
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
    println("rec");
  }
  if (key == CODED) {
    if (keyCode == UP) { 
      //brings the volume up
      vol += 200;
    } else if (keyCode == DOWN) {
      //down
      vol -= 200;
    }
  }
}

