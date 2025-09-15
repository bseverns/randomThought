//panHEIZEN Syndrome
//09/2015
//SevernsReimers
//Random Video player

import processing.video.*;

int startSECOND, startMINUTE, startTOTAL;
int stopSECOND, stopMINUTE, stopTOTAL;
int cm, cs;
int target_m = 0;
int target_s = 0;
int movTOTAL = 10; //set this to the total number of .mov files in library 
boolean startcount = true;
boolean isPlaying = false;
boolean trig = true;

Movie mov;
String playSelection;

void setup() {
  startcount = true;
  startSECOND=second();
  startMINUTE=minute();
  startTOTAL = startMINUTE*60 + startSECOND;
  target_m = 0;
  target_s = 3;


  frameRate(30);

  size (720, 480);
  println("start");
}

void draw() {
  background(0);

  if (startcount==true && trig==true) {
    startSECOND=second();
    startMINUTE=minute();
    startTOTAL = startMINUTE*60 + startSECOND;
    trig = false;
    println("count");
  }

  videoplay();

  if (isPlaying==false) { //not playing atm
    if (target_m==cm) { //target minute
      if (target_s==cs) { //target second
        isPlaying = true; //we are playing now
        println("bingo!");
        videoSelect();
      }
    }
  }
}

void videoSelect() {
  startcount = false; //turn off the watch
  playSelection = nf(int(random(10, 15))) + ".mov";//randomized file selector
  println(playSelection);
  mov = new Movie(this, playSelection); //new video

  mov.play(); //go!
  videoplay(); //update
}


void videoplay() {
  if (isPlaying==true) {
    mov.read();
    image(mov, 0, 0, width, height);
    if (mov.time() == mov.duration()) {
      println("done!");
      isPlaying = false;
      trig = true;

      if (trig==true) {
        //variables - maybe this is manipulated via CV?
        //think about being hypper-self-conscious. Rushing through everything
        //How would they overlap?
        target_m = int(random(0, 5)); //serial midi
        target_s = int(random(1, 59));

        startcount = true;
        println("resetting");
        startMINUTE = minute();
        startSECOND = second();
      }
    }
  } else {
    calculate();
  }
}


void calculate() {

  if (startcount==true) {
    stopMINUTE = minute();
    stopSECOND = second();
    stopTOTAL = stopMINUTE*60 + stopSECOND;
    // println(nf(stopTOTAL));

    int diff = stopTOTAL-startTOTAL;
    cm = diff/60;
    cs = diff - cm*60;
  }
}
