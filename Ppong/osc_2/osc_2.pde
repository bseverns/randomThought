/**
 Processing Arduino to OSC example sketch - written by Liam Lacey (http://liamtmlacey.tumblr.com)
 
 This processing sketch allows communication to and from the Arduino (using the processing arduino library), 
 and then converts the data into/from OSC (using the oscP5 library) to communicate to/from other OSC compatible software/hardware, e.g. Max/MSP.
 
 In this example sketch, all analog pins are being read, as well as digital pins 2, 4 and 7.
 Digital pins 3, 5 and 6 are used as PWM pins, and the rest of the digital pins (8-13) are set to regular output pins.
 
 
 * In order for this sketch to communicate with the Arduino board, the StandardFirmata Arduino sketch must be uploaded onto the board
 (Examples > Firmata > StandardFirmata)
 
 * OSC code adapted from 'oscP5sendreceive' by andreas schlegel
 * Arduino code taken from the tutorial at http://www.arduino.cc/playground/Interfacing/Processing
 
 
 */


//libraries needed for osc
import oscP5.*;
import netP5.*;


//variables needed for osc
OscP5 oscP5;
NetAddress myLocation;

//set/change port numbers here
int incomingPort = 12000;
int outgoingPort = 12001;

//set/change the IP address that the OSC data is being sent to
//127.0.0.1 is the local address (for sending osc to an application on the same computer)
String ipAddress = "127.0.0.1";





//---------------setup code goes in the following function---------------------
void setup() 
{
  size(400, 400);
  frameRate(25);

  /* start oscP5, listening for incoming messages at port ##### */
  //for INCOMING osc messages (e.g. from Max/MSP)
  oscP5 = new OscP5(this, incomingPort); //port number set above

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. 
   */
  //for OUTGOING osc messages (to another device/application)
  myRemoteLocation = new NetAddress(ipAddress, outgoingPort); //ip address set above
}





//----------the following function runs continuously as the app is open------------
//In here you should enter the code that reads any arduino pin data, and sends the data out as OSC
void draw() 
{
  background(0);
}




//--------incoming osc message are forwarded to the following oscEvent method. Write to the arduino pins here--------
//----------------------------------This method is called for each OSC message recieved------------------------------
void oscEvent(OscMessage theOscMessage) 
{
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  print(" typetag: "+theOscMessage.typetag());
  print(" value: "+theOscMessage.get(0).intValue() +"\n");
  //-----------------------------------------------------------------------

  int i;
  int oscValue = theOscMessage.get(0).intValue(); //sets the incoming value of the OSC message to the oscValue variable
  OscMessage myMessage = new OscMessage("/test");

  myMessage.add(123); /* add an int to the osc message */
}

