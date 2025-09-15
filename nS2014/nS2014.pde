/* colorMode(rgb) with established variables mapped to "r", "g", and "b" 
of the in variable in void draw()- arduino/GSM stuff*/

//libraries
import processing.opengl.*;
import processing.video.*;

//video analysis
int numPixels;
int[] backgroundPixels;
Capture video;
int presenceSum = 0;// amount the video feed has changed

//reset the timer on/off
boolean reset = false;

//set initial sound level
float in = 0;
//stroke color designator
float s = 0;
//volume control
float vol = 0;
float r;
float g;
float b;
float d;

//height/width
int w = 1440;
int h = 900;

//timer things
int actualSecs; //actual seconds elapsed since start
int actualMins; //actual minutes elapsed since start
int startSec = 0; //used to reset seconds shown on screen to 0
int startMin = 0; //used to reset minutes shown on screen to 0
int cSecs; //seconds will be 0-60
int cMins=0; //minutes will be reset at 5
int restartSecs=0; //number of seconds elapsed at last click or 60 sec interval
int restartMins=0; //number of seconds ellapsed at most recent minute or click

void setup() {
  //sizing
  size(displayWidth, displayHeight);

  //video
  video = new Capture(this, 160, 130, 20);
  numPixels = video.width * video.height;

  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  video.loadPixels();

  //do this junk fast
  frameRate(60);
}

void draw() {
  //start timer
  actualSecs = millis()/1000; //convert milliseconds to seconds, store values.
  actualMins = millis() /1000 / 60; //convert milliseconds to minutes, store values.
  cSecs = actualSecs - restartSecs; //seconds to be tracked in the artificial stopwatch
  cMins = actualMins - restartMins; //minutes to be tracked in the artificial stopwatch

  //color
  float r = constrain(random(in), 0, w);
  float g = constrain(random(in), 0, w);
  float b = constrain(random(in), 0, h);
  float d = constrain(random(in), 0, h);

  //drawn lines
  line(noise(w), noise(h), noise(w), noise(h));
  line(noise(w*0.85), noise(h*0.85), noise(w*0.85), noise(h*0.85));
  line(noise(w*0.65), noise(h*0.65), noise(w*0.65), noise(h*0.65));
  line(noise(w*0.35), noise(h*0.35), noise(w*0.35), noise(h*0.35));
  line(noise(w*0.55), noise(h*0.55), noise(w*0.55), noise(h*0.55));

  //Picture/Timer stuff
  if (actualSecs % 60 == 0) { //after 60 secs, restart second timer 
    restartSecs = actualSecs;   //placeholder for this second in time
  }

  //save frame/begin reset
  if ((cMins == 1)) { 
    saveFrame("######.jpg");
    reset = true;
  }

  //send to reset
  if (reset = true) {
    restartSecs = actualSecs; //stores elapsed SECONDS
    cSecs = startSec; //restart timer 
    restartMins = actualMins; //stores elapsed MINUTES
    cMins = startMin; //restart timer
    reset = false;
  }
}

//sensitivity adjustments- should be translated to video noise
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) { 
      //brings the volume up
      vol += 50;
    } 
    else if (keyCode == DOWN) {
      //down
      vol -= 50;
    }
  }
}

