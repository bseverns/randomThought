import processing.video.*;

// refers to class / [] = Array / particles is name of the array
Particle[] particles = new Particle[0];

int maxParticles = 15;

int mtSum = 0; // Amount of movement in the frame


int numPixels;
int[] previousFrame;
Capture video;

void setup () {
  size (400, 400);

  video = new Capture(this, width, height);
  video.start();
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();
}


void draw() {
  if (video.available()) {
    video.read();

    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video

    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {// Get the color stored in the pixel
        int pixelValue = video.pixels[index];// Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);// If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
      duff();
    }
    background(0);
    // this line of code makes a new particle and appends it onto the end of the particles Array
    // name of array (particles) / (particle[]) = force code, append adds to a particle
    particles = (Particle[]) append(particles, new Particle(300, 0));
    // The code below kills off the particles so that they do not overload
    // if statement to test the length of the maxParticles
    // subset to delete the particles

    if (particles.length>maxParticles) {
      particles = (Particle[]) subset(particles, 1);
    }
    // for loop for updating particles in the array
    for (int i=0; i<particles.length; i++) {
      // variable dave.x plus xVel, this adds them together from the particle class
      // repeat with Y
      // This code makes it move by adding them together

      particles[i].x += particles[i].xVel;
      particles[i].y += particles[i].yVel;
      // particles[i].partsize *=0.95;      // times the number of to make it shrink
      // particles[i].yVel +=0.5;   // gravity
      // dave.x dave.y refers to the x & y position of particle dave class

      ellipse(particles[i].x, particles[i].y, particles[i].partsize, particles[i].partsize);
    }
  }
}

void duff() {
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
    mtSum += diffR + diffG + diffB;
    // Render the difference image to the screen
    pixels[i] = color(diffR, diffG, diffB);
    // The following line is much faster, but more confusing to read
    //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
    // Save the current color into the 'previous' buffer
    previousFrame[i] = currColor;
  }
  // To prevent flicker from frames that are all black (no movement),
  // only update the screen if the image has changed.
  if (mtSum > 0) {
    updatePixels();
    //println(movementSum); // Print the total amount of movement to the console
  }
}

// THIS IS THE CLASS
// defines a custom class, allows it to be used above void setup
//class name always has to start with a capital - seb said
class Particle {

  float x;          // adds x position property
  float y;          // adds y position property
  float xVel;       // adds xvel property
  float yVel;       // adds yvel property
  float partsize;   // adds a size property


  //Constructor = function// float says where it is xpos/ypos
  Particle(float xpos, float ypos) {
    // assigning the values
    x = xpos = mtSum*random (0, 5);
    y = ypos;
    xVel = random (-2, 2);   // random,(the length of the random)
    yVel = random (0, 5);    // controls the speed that the snow falls
    partsize = random (5, 50);
  }
}

