/* colorMode(rgb) with established variables mapped to "r", "g", and "b" of the in variable in void draw()*/

//sound library & analysis reference
import ddf.minim.*;
import ddf.minim.analysis.*;

//audio stuff
Minim minim;
AudioInput input;

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

  //audio
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 512);

  //do this junk fast
  frameRate(60);
}

void draw() {

  //map input level
  in = ((input.left.level ()*vol)+(input.right.level ()*vol));

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

  //controls the sensitivity
  if (in > 0) {
    colorShift();
  }

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

//decides color
void colorShift() {
  //black
  stroke(0);
  //reset lines/colors
  s = 0;

  //change value to make more/less black/white lines appear based on input value
  if (in > 25) {
    s = 1;
    if (s == 1) {
      stroke (255);
    }
  }
}

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

