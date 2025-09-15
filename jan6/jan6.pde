import processing.video.*;

Capture video;

int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
float brightestValue = 0; // Brightness of the brightest video pixel


void setup() {
  size(600, 600, P3D);

  video = new Capture(this, width, height);
  video.start();
  smooth();
}

void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    background(0);
    lights();
    translate(width/2, height/2);
    rotateY(map(brightestX, 0, width, 0, TWO_PI));
    rotateZ(map(brightestY, 0, height, 0, -TWO_PI));
    strokeWeight(5);
    translate(0, -40, 0);
    drawCylinder(10, 180, 200, 16); // Draw a mix between a cylinder and a cone
    //drawCylinder(70, 70, 120, 64); // Draw a cylinder
    //drawCylinder(0, 180, 200, 4); // Draw a pyramid
  }
}

  void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
    float angle = 0;
    float angleIncrement = TWO_PI / sides;

    fill(255, brightestX, brightestY, 120);
    stroke(200, 200, brightestY, 60);
    beginShape(TRIANGLE_FAN);
    for (int i = 0; i < sides + 1; ++i) {
      vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
      vertex(bottomRadius*cos(angle)*14, tall*12, bottomRadius*sin(angle)*14);
      angle += angleIncrement;
    }
    endShape();

    // If it is not a cone, draw the circular top cap
    if (topRadius != 0) {
      angle = 0;
      beginShape(TRIANGLE_FAN);
      // Center point
      vertex(0, 0, 0);
      for (int i = 0; i < sides + 1; i++) {
        vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
        angle += angleIncrement;
      }
      endShape();
    }

    if (bottomRadius != 0) {
      angle = 0;
      beginShape(TRIANGLE_FAN);
      // Center point
      vertex(0, tall, 0);
      for (int i = 0; i < sides+1; i++) {
        vertex(bottomRadius * cos(angle), tall*(brightestX/600), bottomRadius * sin(angle));
        angle += angleIncrement;
      }
      endShape();
    }

    fill(brightestX, brightestY, brightestY, 120);
    stroke(brightestY, 200, 200, 60);
    beginShape(TRIANGLE_FAN);
    for (int i = 0; i < sides + 1; ++i) {
      vertex(topRadius*-cos(angle), 0, topRadius*-sin(angle));
      vertex(bottomRadius*-cos(angle)*14, -tall*12, bottomRadius*-sin(angle)*14);
      angle += angleIncrement;
    }
    endShape();

    // If it is not a cone, draw the circular top cap
    if (topRadius != 0) {
      angle = 0;
      beginShape(TRIANGLE_FAN);
      // Center point
      vertex(0, 0, 0);
      for (int i = 0; i < sides + 1; i++) {
        vertex(topRadius * -cos(angle), 0, topRadius * -sin(angle));
        angle += angleIncrement;
      }
      endShape();
    }

    if (bottomRadius != 0) {
      angle = 0;
      beginShape(TRIANGLE_FAN);
      // Center point
      vertex(0, -tall, 0);
      for (int i = 0; i < sides+1; i++) {
        vertex(bottomRadius * -cos(angle), -tall*(brightestX/600), bottomRadius * -sin(angle));
        angle += angleIncrement;
      }
      endShape();
    }
  }

