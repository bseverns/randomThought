import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput input;

float s = 0;
int p = 0;


void setup() {
  //size (150, 150, P3D);
  size(displayWidth, displayHeight, P3D);
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 512);

  frameRate(60);
  //stroke(0);
}

void draw() { 
  line(random(displayWidth), random(displayHeight), random(displayWidth), random(displayHeight));
  line(random(displayWidth*0.85), random(displayHeight*0.85), random(displayWidth*0.85), random(displayHeight*0.85));
  line(random(displayWidth*0.65), random(displayHeight*0.65), random(displayWidth*0.65), random(displayHeight*0.65));
  line(random(displayWidth*0.35), random(displayHeight*0.35), random(displayWidth*0.35), random(displayHeight*0.35));

  println(input.left.level()*1000);
  //println(ErrorBreakpoint());
  if (input.left.level ()*1000 > 0) {
    colorShift();
  }
}

void colorShift() {
  println("start"); 
  stroke(0);
  println("black");
  if (input.left.level ()*1000 > 3) {
    s = 1;
    if (s == 1) {
      stroke (255);
      println("white");
    }
  }
}

/*void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT)
    //effectively taking a photograph of the screen, saving it, and  replacing the 'drawing' with a new layer of grey (127)
*/
