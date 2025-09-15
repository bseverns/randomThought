import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
int processingListeningPort = 12000;
int maxMSPListeningPort = 7400;
String maxMSPipAddress = "127.0.0.1";

void setup() {
  size(400, 400);
  frameRate(30);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, processingListeningPort);
  /* set it to send to the maxmsp on port 7400 */
  myRemoteLocation = new NetAddress(maxMSPipAddress, maxMSPListeningPort);
}


void draw() {
  background(0);
}

void keyPressed() {
  if (key == 'k') {
    OscMessage myMessage = new OscMessage("/play");
    myMessage.add(1); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);
    println("k");
  }
  if (key == 'j') {
    OscMessage myMessage = new OscMessage("/play");
    myMessage.add(0); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);
    println("j");
  }
  
   if (key == 'l') {
    OscMessage myMessage = new OscMessage("/load");
    myMessage.add("/Users/bseverns/Desktop/BenS-1/senior.wav"); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);
    println("l");
  }
  
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

