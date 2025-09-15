void playBack() {
  if (isPlaying == true) {
    OscMessage myMessage = new OscMessage("/play");
    myMessage.add(1); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);
  }
  else {
    //do nothing
  }
  }

  /* incoming osc message are forwarded to the oscEvent method. */
  void oscEvent(OscMessage theOscMessage) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());
  }

