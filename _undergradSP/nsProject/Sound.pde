
void audioStreamWrite(AudioStream theStream) {

  // next wave
  myWave1.generate(myStream);
  myWave2.generate(myStream,Ess.ADD);

  // adjust our phases
  myWave1.phase+=myStream.size;
  myWave1.phase%=myStream.sampleRate; 
  myWave2.phase=myWave1.phase;

  if (doFadeIn) {
    myFadeIn.filter(myStream);
    doFadeIn=false;
  }

  if (frequency!=oldFrequency) {
    // we have a new frequency    
    myWave1.frequency=frequency;

    // non integer frequencies can cause timing issues with our simple timing code
    myWave2.frequency=(int)(frequency*4.33); 
    myWave1.phase=myWave2.phase=0;

    // out with the old
    // fade out the old sound to create a 
    myFadeOut.filter(myStream);
    doFadeIn=true;
    println("Playing frequency: "+frequency);
    oldFrequency=frequency;
  } 

  // reverb
  myReverb.filter(myStream,.5);

  // record
  if (recording) {
    myFile.write(myStream);
    bytesWritten+=myStream.size*2;
  }
}

void keyPressed() {
  if (recording) {
    // stop
    myFile.close();

    println("Finished recording. "+bytesWritten+" bytes written.");
  } 
  else {
    // start
    myFile.open("spookyStream.aif",myStream.sampleRate,Ess.WRITE);
    bytesWritten=0;

    println("Recording started.");
  }

  recording=!recording;
}

// we are done, clean up Ess

public void stop() {
  Ess.stop();
  super.stop();
}

