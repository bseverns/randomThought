import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioInput in;
AudioOutput out;
AudioRecorder recorder;
SawWave saw;

void setup()
{
  size(512, 200);
  minim = new Minim(this);
  out = minim.getLineOut();
  in = minim.getLineIn(Minim.STEREO, 2048);
  recorder = minim.createRecorder(in, "myrecording.wav", true);
  // see the example AudioOutput >> SawWaveSignal for more about this
  saw = new SawWave(100, 0.2, out.sampleRate());
  // see the example Polyphonic >> addSignal for more about this
  out.addSignal(saw);

  textFont(createFont("Arial", 12));
}

void draw()
{
  background(0);
  // see waveform.pde for more about this

  if ( out.hasControl(Controller.MUTE) )
  {
    if (mousePressed)
    {
      out.mute();
      recorder.beginRecord();
      println("Recording");
    }
    else
    {
      out.unmute();
      recorder.endRecord();
      println("Done Recording");
      recorder.save();
      println("Done saving.");
    }
    if ( out.isMuted() )
    {
      text("The output is muted.", 5, 15);
    }
    else
    {
      text("The output is not muted.", 5, 15);
    }
  }
  else
  {
    text("The output doesn't have a mute control.", 5, 15);
  }
}

void stop()
{
  // always close Minim audio classes when you are finished with them
  out.close();
  minim.stop();
  in.close();
  super.stop();
}

