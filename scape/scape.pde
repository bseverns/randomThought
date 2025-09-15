//OP grab
//Severns
//3/1/17

//Activate based on Minim level input - softsculpture visuals
import ddf.minim.*;

int cols, rows;
int scale = 20;
int w=1800;
int h=600;
float flying=0;
float[][] terrain;

Minim minim;
AudioInput in;
AudioPlayer groove;
int loopcount;

PImage bg1;
PImage bg2;

float inOFF = 10;

void setup() {

  frameRate(30);
  fullScreen(P3D);
  //size(600, 300, P3D);
  cols = w/scale;//drawing
  rows = h/scale;
  terrain = new float[cols][rows];
  minim = new Minim(this);//sound                          
  in = minim.getLineIn();
  bg2 = loadImage("bigwolf1.png");//background
  bg1 = loadImage("bigwolf2.png");
  background(255);
}

void draw() {
  //animate scape
  flying -= 0.02;
  float yoff = flying;
  for (int y=0; y<rows; y++) {
    float xoff = 0;
    for (int x=0; x<cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -110, 110);
      xoff+=0.1;
    }
    yoff+=0.1;


    //Check sound level - performance
    //println(in.left.level());
    if (in.left.level()*inOFF>3) {
      //which background?
      int a = int(random(20));
       println(a);
      if (a >= 19) {
        background(bg1);
      } else if (a >= 15) {
        background(bg2);
      } else {
        background(255);
      }
    }
  }

  //draw scape
  int b = int(random(10));
  if (b >= 9) {
    stroke(255, 75);
  } else if (b >= 7) {
    stroke(255, 0, 0, 50);
  } else {
    stroke(30, 25);
  }
  noFill();
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);

  for (int y=0; y<rows -1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<cols; x++) {
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
  
}

//volume up/down
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      inOFF = inOFF + 5;
    } else if (keyCode == DOWN) {
      inOFF = inOFF - 5;
    }
  }
}

//reset
void mouseClicked() {
  setup();
}