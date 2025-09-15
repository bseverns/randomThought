// Code by @MetaGlitch

float t;
float[][] result;

void setup() {
  setup_();
  result = new float[width*height][3];
}

void draw() {
  if (!recording) {
    if (mousePressed) {
      frameRate(60);
      t = mouseX*1.0/width;
      if (mouseButton == LEFT) t = constrain(t, 0, 1);
      while(t<0) t+=1.0;
      while(t>1) t-=1.0;
    } else {
      frameRate(fps);
      t = float((frameCount-1)%numFrames) / numFrames;
    }
    draw_();  
  } else { // sub frame rendering inspired by @beesandbombs
    for (int i=0; i<width*height; i++) for (int a=0; a<3; a++) result[i][a] = 0;

    float divider = 0; 
    for (int sa=0; sa<samplesPerFrame; sa++) {
      noLights(); // reset lights
      t = map(frameCount-1 + exposure*sa/samplesPerFrame, 0, numFrames - (looping?0:1) , 0, 1) % 1;
      pushMatrix();
      draw_();
      popMatrix();
      loadPixels();
      float weight = pow(subFrameAttenuation, samplesPerFrame-sa-1);
      divider += weight;
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += weight * (pixels[i] >> 16 & 0xff);
        result[i][1] += weight * (pixels[i] >> 8 & 0xff);
        result[i][2] += weight * (pixels[i] & 0xff);
      }
    }
 
    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/divider) << 16 | 
        int(result[i][1]*1.0/divider) << 8 | 
        int(result[i][2]*1.0/divider);
    updatePixels();
 
    saveFrame("frames/f###.png");
    if (frameCount==numFrames)
      exit();
  }
  
}

