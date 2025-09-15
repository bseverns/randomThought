/**
 * User Defined Signal
 * by Damien Di Fede.
 *  
 * This sketch demonstrates how to implement your own AudioSignal 
 * for Minim. See MouseSaw.pde for the implementation.
 */

import ddf.minim.*;
import ddf.minim.signals.*;

String currentRecorderFilename = "currentActivity.wav";

Minim minim;
AudioInput in;
AudioRecorder recorder;
AudioPlayer currentActivity;
MouseSaw msaw;

void setup()
{
  size(512, 200, P2D);

  minim = new Minim(this);
  msaw = new MouseSaw();
  in = minim.getLineIn(Minim.STEREO, 512);


  recorder = minim.createRecorder(in, currentRecorderFilename, true);
  currentRecorderFilename.addListener(msaw);
  recorder.beginRecord();
}

void draw()
{
  background(0);
  stroke(255);
  // draw the waveforms
  for(int i = 0; i < in.bufferSize()-1; i++)
  {
    float x1 = map(i, 0, in.bufferSize(), 0, width);
    float x2 = map(i+1, 0, in.bufferSize(), 0, width);
    line(x1, 50 + in.left.get(i)*50, x2, 50 + in.left.get(i+1)*50);
    line(x1, 150 + in.right.get(i)*50, x2, 150 + in.right.get(i+1)*50);
  }
}

void stop()
{
  recorder.save();
  recorder.endRecord();
  in.close();
  minim.stop();

  super.stop();
}

