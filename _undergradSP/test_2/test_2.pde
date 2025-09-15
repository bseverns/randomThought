/**
 * User Defined Signal
 * by Damien Di Fede.
 *  
 * This sketch demonstrates how to implement your own AudioSignal 
 * for Minim. See MouseSaw.pde for the implementation.
 */

import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioInput in;
AudioOutput out;
AudioRecorder recorder;
MouseSaw msaw;

void setup()
{
  size(512, 200, P2D);

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  out = minim.getLineOut(Minim.STEREO, 2048);
  recorder = minim.createRecorder(in, "myrecording.wav", true);
  msaw = new MouseSaw();
  //.addListener();
  // adds the signal to the output
  out.addSignal(msaw);
}

void draw()
{
  background(0);
  if (mousePressed)
  {
    recorder.beginRecord();
    //println("Recording");
  }
  else
  {
    recorder.endRecord();
    //println("Done Recording");
    recorder.save();
    //println("Done saving.");
  }
}


void stop()
{
  out.close();
  minim.stop();
  in.close();
  super.stop();
}

