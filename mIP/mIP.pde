import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
AudioInput input;

void setup() {
  //size (150, 150, P3D);
  size(displayWidth, displayHeight, P3D);
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 512);

  frameRate(2.5);
}

void draw() {
  println(input.left.level()*1000);
  {
    stroke(0);
    //line(random(displayWidth*0.85), random(displayHeight*0.85), random(displayWidth*0.85), random(displayHeight*0.85));
    //line(random(displayWidth), random(displayHeight), random(displayWidth), random(displayHeight));
  }
  if (input.left.level ()*1000 > (1.25));
  {
    stroke(255);
    //line(random(displayWidth*0.85), random(displayHeight*0.85), random(displayWidth*0.85), random(displayHeight*0.85));
    //line(random(displayWidth), random(displayHeight), random(displayWidth), random(displayHeight));
  } 
  else if { 
    stroke(0);
  }
  line(random(displayWidth*0.85), random(displayHeight*0.85), random(displayWidth*0.85), random(displayHeight*0.85));
  line(random(displayWidth), random(displayHeight), random(displayWidth), random(displayHeight));
  line(random(displayWidth*0.65), random(displayHeight*0.65), random(displayWidth*0.65), random(displayHeight*0.65));
  line(random(displayWidth*0.35), random(displayHeight*0.35), random(displayWidth*0.35), random(displayHeight*0.35));
}
}
