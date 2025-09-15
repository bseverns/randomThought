void runNonRealTime() {
  //frequency modulation
  Function modFreq = new Function(carrierFreq, modFreqRatio) {
    public float calculate() {
      return x[0] * x[1];
    }
  };
  //wave player needs to be paused somehow or silence for recording
  WavePlayer freqModulator = new WavePlayer(acRecord, modFreq, Buffer.SAW);
  Function carrierMod = new Function(freqModulator, carrierFreq) {
    public float calculate() {
      return x[0] * 400.0 + x[1];
    }
  };
  mySample = SampleManager.sample("mySample.wav");
  RecordToSample cp = new RecordToSample(acRecord, );
  WavePlayer wp = new WavePlayer(acRecord, carrierMod, Buffer.SQUARE);
  Gain g = new Gain(acRecord, 1, 0.5);

  g.addInput(wp);
  acRecord.out.addInput(g);
  //acRecord.addDependent(cp);
}

void generate() {
  RecordToSample cp = null;
try {
	cp = new RecordToSample(acRecord, mySample);
} catch(Exception e) {
	e.printStackTrace();
}
  
  acRecord.start();
  //These values need to change
  carrierFreq.setValue((float)rawDepthToMeters * 1000 + 50);
  modFreqRatio.setValue((1 - (float)rawDepthToMeters) * 10 + 0.1);
}
