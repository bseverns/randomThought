// Code by @MetaGlitch

float fps = 16.666;

int inFrames = 15;
int outFrames = 15;
int otherFrames = 60;
int numFrames = inFrames + otherFrames + outFrames;

float t1 = inFrames * 1.0/numFrames;
float t2 = (inFrames+otherFrames) * 1.0/numFrames;

int samplesPerFrame = 8;
float exposure = 0.75; // exposure time in frames. >1 allowed for blending multiple frames
float subFrameAttenuation = 1; // 1 for weighting every subframe the same. <1 for attenuation effect.
boolean looping = true; // false: t=1 on the last frame; true: t=1-1/nummFrames on last frame.

boolean recording = true;

void setup_() {
  size(500, 500, P3D);
  smooth(8);
  noStroke();
}

float exposureCopy = exposure;
void draw_() {
  // collab settings: hit t=1 and remove motion blur on first and last frame.
  looping = false; if (frameCount==1 || frameCount==numFrames) exposure=0; else exposure=exposureCopy;
  
  background(255);
  fill(0);

  float x = 250;
  float y = 0;
    
  if (t<t1) y = map(t, 0,t1, -50,50); // entry
  if (t>t2) y = map(t, t2,1, 450,550); // exit
  if (t>=t1 && t<=t2) {
    float tt = map(t, t1,t2, 0,1);
    y = map(t, t1,t2, 50,450);
    x = 250 + sin(tt*TAU)*150 * ease(pingpong(tt),3);
  }
  
  ellipse(x,y, 100,100);  
}

//////////////////

float pingpong(float t) { //  / => /\
  return 1-2*abs(t-0.5);
}

float ease(float t, float e) {
  return t < 0.5 ? 0.5 * pow(2*t, e) : 1 - 0.5 * pow(2*(1 - t), e);  
}

float ease(float t, float in, float out) {
  return (1-t)*ease(t, in) + t*ease(t, out);  
}

