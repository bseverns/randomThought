import processing.opengl.*;
import processing.video.*;
import s373.flob.*;

import krister.Ess.*;

AudioStream myStream;
SineWave myWave1;
TriangleWave myWave2;

FadeOut myFadeOut;
FadeIn myFadeIn;
Reverb myReverb;

int frequency = 35;

int oldFrequency=0;
boolean doFadeIn=false;

boolean recording=false;
AudioFile myFile=new AudioFile();
int bytesWritten;

Capture video;   
Flob flob;       
ArrayList blobs; 

int tresh = 6;   // adjust treshold value here or keys t/T
int fade = 15;
int om = 1;
int videores=256;
String info="";
PFont font;
float fps = 60;
int videotex = 0; //case 0: videotex = videoimg;//case 1: videotex = videotexbin; 
//case 2: videotex = videotexmotion//case 3: videotex = videoteximgmotion;


void setup() {
  // osx quicktime bug 882 processing 1.0.1
  try { 
    quicktime.QTSession.open();
  } 
  catch (quicktime.QTException qte) { 
    qte.printStackTrace();
  }

  // start up Ess
  Ess.start(this);

  // create a new AudioStream
  myStream=new AudioStream();
  myStream.smoothPan=true;

  // our waves
  myWave1=new SineWave(0,.33);
  myWave2=new TriangleWave(0,.66);

  // our effects
  myFadeOut=new FadeOut();
  myFadeIn=new FadeIn();
  myReverb=new Reverb();

  // start
  myStream.start();
  
  size(640,480,OPENGL);
  frameRate(fps);
  rectMode(CENTER);
  // init video data and stream
  video = new Capture(this, videores, videores, (int)fps);  
  flob = new Flob(videores, videores, width, height);

  flob.setThresh(tresh).setSrcImage(videotex)
    .setBackground(video).setBlur(0).setOm(1).
      setFade(fade).setMirror(true,false);
}



void draw() {

  if(video.available()) {
    video.read();
    blobs = flob.calc(flob.binarize(video));
  }

  image(flob.getSrcImage(), 0, 0, width, height);

  rectMode(CENTER);

  int numblobs = blobs.size();
  for(int i = 0; i < numblobs; i++) {
    ABlob ab = (ABlob)flob.getABlob(i); 

    int mx=numblobs;
    int my=height-numblobs;

    myStream.pan((mx-width/2f)/(width/2f));

    //box
    fill(0,0,255,100);
    rect(ab.cx,ab.cy,ab.dimx,ab.dimy);
    //centroid
    fill(0,255,0,200);
    rect(ab.cx,ab.cy, 5, 5);
    info = ""+ab.id+" "+ab.cx+" "+ab.cy;
    text(info,ab.cx,ab.cy+20);
  }

  int interp=(int)(((millis()-myStream.bufferStartTime)/(float)myStream.duration)*myStream.size);

  for (int i=0;i<256;i++) {
    float left=numblobs;
    float right=numblobs;

    if (i+interp+1<myStream.buffer2.length) {
      left-=myStream.buffer2[i+interp]*75.0;
      right-=myStream.buffer2[i+1+interp]*75.0;
    }
  }
}



