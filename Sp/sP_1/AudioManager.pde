//-----------------------------------------SOUND GENERATOR--------------------------------
// this is a stricly mono signal
void startPlaying() {
  currentActivity = minimOut.loadFile(currentRecorderFilename, 2048);
  currentActivity.play();
}

void stopPlaying() {
  minimOut.stop();
}

//-------------------------------------------RECORDING---------------------------------------
void record() {
  if (recorder != null && recorder.isRecording()) {
    stopRecording();
  }
  //File.delete(currentActivity.wav); //delete the recording that we just made
  recorder = minimIn.createRecorder(in, currentRecorderFilename, true);
  recorder.beginRecord();
}

void stopRecording() {
  recorder.save();
  recorder.endRecord();
}

