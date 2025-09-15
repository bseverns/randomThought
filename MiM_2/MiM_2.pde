/**
 * Frame Differencing 
 * by Golan Levin. 
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
 */

import ddf.minim.*;
import processing.serial.*;
import processing.video.*;

//audio
Minim minim;
AudioPlayer player;

//image analysis
int numPixels;
int[] previousFrame;
Capture video;

//---------------------------The serial port
Serial port;

//upper limit of target range
int val = 10;

void setup() {
  size(640, 480);

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);

  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  player = minim.loadFile("02 Shake Your Rump copy.mp3");  //Speech about humanity- the perils of indifference

    // play the file from start to finish.
  // if you want to play the file again, 
  // you need to call rewind() first.
  player.loop();

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);
  // Start capturing the images from the camera
  video.start(); 

  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();

  // serial/arduino things
  String arduinoPort = Serial.list()[0]; 
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino


  frameRate(10);
  stroke(255);
}

void draw() {
  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
    video.loadPixels(); // Make its pixels[] array available

    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];

      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;

      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;

      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);

      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;

      // Render the difference image to the screen
      //  pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }


    // To prevent flicker from frames that are all black (no movement),
    // only update the screen if the image has changed.

    if (movementSum > 0) {
      updatePixels();
      float a = map(movementSum, 250000, 90000000, 0, val);

      println(a);
      //serial communications
      if (a > 0.9) {
        port.write(6);
        println("1");

        if (a > 1.4) {
          port.write(12);
          println("2");

          if (a > 2.1); 
          {
            port.write(25);
            println("3");

            if (a > 3) {
              port.write(45);
              println("4");
            }
          }
        }
      }
    }
  }
  background(0);

  // draw the waveforms so we can see what we are monitoring
  for (int i = 0; i < player.bufferSize () - 1; i++)
  {
    line( i, 50 + player.left.get(i)*50, i+1, 50 + player.left.get(i+1)*50 );
    line( i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50 );
  }
}

