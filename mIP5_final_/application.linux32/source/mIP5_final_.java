import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class mIP5_final_ extends PApplet {

//sound library & analysis



//timer things
int actualSecs; //actual seconds elapsed since start
int actualMins; //actual minutes elapsed since start
int startSec = 0; //used to reset seconds shown on screen to 0
int startMin = 0; //used to reset minutes shown on screen to 0
int cSecs; //seconds displayed on screen (will be 0-60)
int cMins=0; //minutes displayed on screen (will be infinite)
int restartSecs=0; //number of seconds elapsed at last click or 60 sec interval
int restartMins=0; //number of seconds ellapsed at most recent minute or click

//audio stuff
Minim minim;
AudioInput input;

//reset the timer
boolean reset = false;

//sound level
float in = 0;

//this is a number dealing with milliseconds. An hour is 3600000 & 300000 is 5 minutes
int et = 30000;

//stroke color designator
float s = 0;

//height/width
int w = 1440;
int h = 900;

public void setup() {
  //sizing
  size(displayWidth, displayHeight);

  //audio
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 512);

  //do this junk fast
  frameRate(60);
}

public void draw() {

  //set input float
  in = input.left.level ()*1000;

  //start timer
  actualSecs = millis()/1000; //convert milliseconds to seconds, store values.
  actualMins = millis() /1000 / 60; //convert milliseconds to minutes, store values.
  cSecs = actualSecs - restartSecs; //seconds to be shown on screen
  cMins = actualMins - restartMins; //minutes to be shown on screen

  //drawn lines
  line(random(w), random(h), random(w), random(h));
  line(random(w*0.85f), random(h*0.85f), random(w*0.85f), random(h*0.85f));
  line(random(w*0.65f), random(h*0.65f), random(w*0.65f), random(h*0.65f));
  line(random(w*0.35f), random(h*0.35f), random(w*0.35f), random(h*0.35f));
  line(random(w*0.55f), random(h*0.55f), random(w*0.55f), random(h*0.55f));
  line(random(w), random(h), random(w), random(h));

  //controls the sensitivity
  if (in > 0) {
    colorShift();
  }

  //Picture/Timer stuff
  if (actualSecs % 60 == 0) { //after 60 secs, restart second timer 
    restartSecs = actualSecs;   //placeholder for this second in time
  }

  //save frame/begin reset
  if ((cMins == 5)) { 
    saveFrame("######.jpg");
    reset = true;
  }

  //send to reset
  if (reset = true) {
    restartSecs = actualSecs; //stores elapsed SECONDS
    cSecs = startSec; //restart screen timer 
    restartMins = actualMins; //stores elapsed MINUTES
    cMins = startMin; //restart screen timer
    reset = false;
  }
}


//decides color
public void colorShift() {
  //black
  stroke(0);

  //reset lines/colors
  s = 0;

  //change value to make more/less black/white lines appear based on input value
  if (in > 165) {
    s = 1;
    if (s == 1) {
      stroke (255);
    }
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "mIP5_final_" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
