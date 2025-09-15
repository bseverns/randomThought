import processing.serial.*;


Serial port;

void setup() {
    String arduinoPort = Serial.list()[0]; 
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino
}

void draw() {
  
}

void keyPressed() {
  if (key == 'k') {
    port.write(0);
  }
  else if (key == 'f') {
      port.write(255);
  }
}
